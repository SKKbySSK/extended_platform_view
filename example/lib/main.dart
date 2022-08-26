import 'package:extended_platform_view/extended_platform_view.dart';
import 'package:extended_platform_view/method_channel_delegate.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: _buildSamplePlatformView(),
      ),
    );
  }

  Widget _buildSamplePlatformView() {
    return ExtendedPlatformView(
      config: const ExtendedPlatformViewConfig(
        viewType: 'sample_platform_view',
        androidCompositionMode: AndroidCompositionMode.hybridComposition,
        creationParams: "initial text",
      ),
      methodChannelDelegate: MethodChannelDelegate(
        onCreate: (channel) async {
          await Future.delayed(const Duration(seconds: 3));
          channel.invokeMethod(
            'set_text',
            '3 seconds elapsed',
          );
        },
      ),
    );
  }
}
