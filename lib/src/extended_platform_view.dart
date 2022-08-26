import 'dart:io';

import 'package:extended_platform_view/extended_platform_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// PlatformView has two composition mode.
/// Normally, you should use [AndroidCompositionMode.hybridComposition] mode.
/// See the [official document](https://docs.flutter.dev/development/platform-integration/android/platform-views#performance) for more details.
enum AndroidCompositionMode {
  hybridComposition,
  virtualDisplay,
}

class ExtendedPlatformViewConfig {
  const ExtendedPlatformViewConfig({
    required this.viewType,
    this.androidCompositionMode = AndroidCompositionMode.hybridComposition,
    this.hitTestBehavior = PlatformViewHitTestBehavior.opaque,
    this.layoutDirection,
    this.creationParams,
  });

  final String viewType;
  final AndroidCompositionMode androidCompositionMode;
  final PlatformViewHitTestBehavior hitTestBehavior;
  final TextDirection? layoutDirection;
  final dynamic creationParams;
}

/// [ExtendedPlatformView] will integrate the PlatformView generation logic on iOS and Android.
/// Also, it generates [MethodChannel] if the [MethodChannelDelegate] is provided.
class ExtendedPlatformView extends StatefulWidget {
  ExtendedPlatformView({
    Key? key,
    required ExtendedPlatformViewConfig config,
    MethodChannelDelegate? methodChannelDelegate,
  }) : this.delegates(
          key: key,
          config: config,
          delegates: [
            if (methodChannelDelegate != null) methodChannelDelegate,
          ],
        );

  const ExtendedPlatformView.delegates({
    Key? key,
    required this.config,
    this.delegates = const [],
  }) : super(key: key);

  final ExtendedPlatformViewConfig config;
  final List<ExtendedPlatformViewDelegate> delegates;

  @override
  State<ExtendedPlatformView> createState() => _ExtendedPlatformViewState();
}

class _ExtendedPlatformViewState extends State<ExtendedPlatformView> {
  var _viewCreated = false;

  @override
  void dispose() {
    if (_viewCreated) {
      widget.delegates.forEach((d) => d.onPlatformViewDispose());
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    assert(Platform.isAndroid || Platform.isIOS);

    if (Platform.isAndroid) {
      return _buildAndroidView(context);
    }

    return _buildIOSView(context);
  }

  Widget _buildAndroidView(BuildContext context) {
    switch (widget.config.androidCompositionMode) {
      case AndroidCompositionMode.hybridComposition:
        return _buildAndroidHybridComposition(context);
      case AndroidCompositionMode.virtualDisplay:
        return _buildAndroidVirtualDisplay();
    }
  }

  Widget _buildAndroidHybridComposition(BuildContext context) {
    return PlatformViewLink(
      viewType: widget.config.viewType,
      surfaceFactory: (context, controller) {
        return AndroidViewSurface(
          controller: controller as AndroidViewController,
          gestureRecognizers: const <Factory<OneSequenceGestureRecognizer>>{},
          hitTestBehavior: widget.config.hitTestBehavior,
        );
      },
      onCreatePlatformView: (params) {
        final layoutDirection =
            widget.config.layoutDirection ?? Directionality.of(context);
        return PlatformViewsService.initSurfaceAndroidView(
          id: params.id,
          viewType: widget.config.viewType,
          layoutDirection: layoutDirection,
          creationParams: widget.config.creationParams,
          creationParamsCodec: const StandardMessageCodec(),
          onFocus: () {
            params.onFocusChanged(true);
          },
        )
          ..addOnPlatformViewCreatedListener(params.onPlatformViewCreated)
          ..addOnPlatformViewCreatedListener(_onPlatformViewCreated)
          ..create();
      },
    );
  }

  Widget _buildAndroidVirtualDisplay() {
    return AndroidView(
      viewType: widget.config.viewType,
      hitTestBehavior: widget.config.hitTestBehavior,
      layoutDirection: widget.config.layoutDirection,
      creationParams: widget.config.creationParams,
      creationParamsCodec: const StandardMessageCodec(),
      onPlatformViewCreated: _onPlatformViewCreated,
    );
  }

  Widget _buildIOSView(BuildContext context) {
    return UiKitView(
      viewType: widget.config.viewType,
      hitTestBehavior: widget.config.hitTestBehavior,
      creationParams: widget.config.creationParams,
      creationParamsCodec: const StandardMessageCodec(),
      onPlatformViewCreated: _onPlatformViewCreated,
    );
  }

  void _onPlatformViewCreated(int id) {
    _viewCreated = true;
    widget.delegates.forEach(
      (d) => d.onPlatformViewCreated(widget.config.viewType, id),
    );
  }
}
