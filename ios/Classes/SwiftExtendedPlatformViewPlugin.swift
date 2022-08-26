import Flutter
import UIKit

public class SwiftExtendedPlatformViewPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let messenger = registrar.messenger()
        for (viewType, builder) in ExtendedPlatformViewRegistrar.registeredViews {
            let factory = ExtendedPlatformViewFactoryWrapper(messenger: messenger, viewType: viewType, builder: builder)
            registrar.register(factory, withId: viewType)
        }
    }
}
