# ExtendedPlatformView

Adds the `ExtendedPlatformView` widget to simplify `PlatformView` initialization & communication.

`ExtendedPlatformView` has these functionalities.

- Use the single `ExtendedPlatformView` widget to create `PlatformView` on Android and iOS
- `MethodChannel` support
- Switching `HybridComposition` and `VirtualDisplay` on Android

## How to Use
### Create an ExtendedPlatformView widget [Flutter]
```dart
Widget build(BuildContext context) {
  return ExtendedPlatformView(
    config: const ExtendedPlatformViewConfig(
      viewType: 'sample_platform_view',
      creationParams: "text",
    ),
  );
}
```

### Add PlatformView class & register viewType [Android]
1. Add `PlatformView` class that extends the `ExtendedPlatformView`
```kotlin
class SamplePlatformView: ExtendedPlatformView() {
    override fun initialize(params: CreationParams): View {
        return TextView(context).apply {
            text = params.args as String
        }
    }
}
```

2. Register the `PlatformView` on `FlutterActivity`
```kotlin
class MainActivity: FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        flutterEngine.extendedPlatformView.register("sample_platform_view") { SamplePlatformView() }
    }
}
```

### Add PlatformView class & register viewType [iOS]

1. Add `PlatformView` class that extends the `ExtendedPlatformView`
```swift
import extended_platform_view

class SamplePlatformView: ExtendedPlatformView {
    override func initialize(params: CreationParams) -> UIView {
        let label = UILabel(frame: params.frame)
        label.text = (params.args as! String)

        return label
    }
}
```

2. Register the `PlatformView` on `AppDelegate`
```swift
import extended_platform_view

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        // You have to register ExtendedPlatformView before calling `GeneratedPluginRegistrant.register(with: self)`
        ExtendedPlatformViewRegistrar.register(viewType: "sample_platform_view", builder: { SamplePlatformView() })
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}
```

## MethodChannel
`MethodChannel` will be created if you pass the `methodChannelDelegate` argument.

On the platform side, `ExtendedPlatformView` has `methodChannel` property and 
it will be assigned automatically before the `initialize(params: CreationParams)` method call.

```dart
Widget build(BuildContext context) {
  return ExtendedPlatformView(
    config: const ExtendedPlatformViewConfig(
      viewType: 'sample_platform_view',
      creationParams: "text",
    ),
    methodChannelDelegate: MethodChannelDelegate(
      onCreate: (methodChannel) {
        // do something...
      },
    ),
  );
}
```

On Android
```kotlin
override fun initialize(params: CreationParams): View {
    val textView = TextView(context).apply {
        text = params.args as String
    }
    
    methodChannel.setMethodCallHandler { call, result ->
        // do something...
    }
    
    return textView
}
```

On iOS
```swift
override func initialize(params: CreationParams) -> UIView {
    let label = UILabel(frame: params.frame)
    label.text = (params.args as! String)
    
    methodChannel.setMethodCallHandler({ call, result in
        // do something...
    })
    
    return label
}
```

## AndroidCompositionMode
Flutter has two `PlatformView` composition mode on Android.

By default, `ExtendedPlatformView` will use the `HybridComposition`.

If you need to use the `VirtualDisplay` mode, set the `ExtendedPlatformViewConfig.androidCompositionMode` to `AndroidCompositionMode.virtualDisplay`

```dart
ExtendedPlatformViewConfig(
    viewType: 'sample_platform_view',
    androidCompositionMode: AndroidCompositionMode.virtualDisplay,
)
```
