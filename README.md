# ExtendedPlatformView

Adds the ExtendedPlatformView widget to simplify PlatformView initialization & communication.
ExtendedPlatformView has these functionalities.

- Use the single ExtendedPlatformView widget to create PlatformView on Android and iOS
- Switching HybridComposition and VirtualDisplay on Android
- MethodChannel support


## [Flutter] Create an ExtendedPlatformView widget
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

## [Android] Add PlatformView class & register viewType
1. Add PlatformView class that extends the ExtendedPlatformView
```kotlin
class SamplePlatformView: ExtendedPlatformView() {
    override fun initialize(params: CreationParams): View {
        return TextView(context).apply {
            text = params.args as String
        }
    }
}
```

2. Register the PlatformView on FlutterActivity
```kotlin
class MainActivity: FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        flutterEngine.extendedPlatformView.apply {
            register("sample_platform_view") { SamplePlatformView() }
        }
    }
}
```

## [iOS] Add PlatformView class & register viewType

1. Add PlatformView class that extends the ExtendedPlatformView
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

2. Register the PlatformView on AppDelegate
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
