import Flutter
import UIKit

public class HovrNativePlatformViewPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let factory = PhoneEntryViewFactory(messenger: registrar.messenger())
        registrar.register(
            factory,
            withId: PhoneEntryChannelConstants.viewType
        )
    }
}
