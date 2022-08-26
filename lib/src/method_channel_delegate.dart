import 'dart:async';

import 'package:extended_platform_view/src/extended_platform_view_delegate.dart';
import 'package:flutter/services.dart';

/// [ExtendedPlatformViewDelegate] class that manages the associated
/// [MethodChannel] to communicate with native platform view.
class MethodChannelDelegate with ExtendedPlatformViewDelegate {
  MethodChannelDelegate({
    this.onCreate,
    this.onDispose,
  });

  final void Function(MethodChannel)? onCreate;
  final void Function(MethodChannel)? onDispose;

  final _methodChannelCompleter = Completer<MethodChannel>();
  Future<MethodChannel> getMethodChannel() => _methodChannelCompleter.future;

  @override
  void onPlatformViewCreated(String viewType, int id) {
    final methodChannel = MethodChannel('$viewType/$id/method');
    _methodChannelCompleter.complete(methodChannel);
    onCreate?.call(methodChannel);
  }

  @override
  void onPlatformViewDispose() async {
    if (!_methodChannelCompleter.isCompleted || onDispose == null) {
      return;
    }

    final methodChannel = await _methodChannelCompleter.future;
    onDispose!(methodChannel);
  }
}
