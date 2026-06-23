package com.ridehovr.hovr_native_platform_view

import io.flutter.embedding.engine.plugins.FlutterPlugin

class HovrNativePlatformViewPlugin : FlutterPlugin {
    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        binding.platformViewRegistry.registerViewFactory(
            PhoneEntryChannelConstants.VIEW_TYPE,
            PhoneEntryViewFactory(binding.binaryMessenger),
        )
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        // Platform views dispose individually.
    }
}
