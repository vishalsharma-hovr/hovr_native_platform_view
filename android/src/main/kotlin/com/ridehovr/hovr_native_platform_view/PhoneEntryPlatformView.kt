package com.ridehovr.hovr_native_platform_view

import android.content.Context
import android.view.View
import androidx.compose.runtime.mutableStateOf
import androidx.compose.ui.platform.ComposeView
import com.ridehovr.hovr_native_platform_view.ui.PhoneEntryScreen
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.platform.PlatformView

class PhoneEntryPlatformView(
    context: Context,
    messenger: BinaryMessenger,
    viewId: Int,
) : PlatformView {

    private val channel = MethodChannel(
        messenger,
        PhoneEntryChannelConstants.channelName(viewId),
    )
    private val externalShowValidationError = mutableStateOf(false)
    private val composeView = ComposeView(context)

    init {
        ComposePlatformViewHelper.configure(composeView, context)
        channel.setMethodCallHandler(::handleDartCall)
        composeView.setContent {
            PhoneEntryScreen(
                externalShowValidationError = externalShowValidationError.value,
                onSubmit = ::sendSubmission,
            )
        }
    }

    override fun getView(): View = composeView

    override fun dispose() {
        channel.setMethodCallHandler(null)
    }

    private fun sendSubmission(phoneNumber: String, dialCode: String, countryIso: String) {
        channel.invokeMethod(
            PhoneEntryChannelConstants.ON_PHONE_SUBMITTED,
            mapOf(
                "phoneNumber" to phoneNumber,
                "dialCode" to dialCode,
                "countryIso" to countryIso,
            ),
        )
    }

    private fun handleDartCall(call: MethodCall, result: MethodChannel.Result) {
        if (call.method != PhoneEntryChannelConstants.UPDATE_SUBMISSION_STATUS) {
            result.notImplemented()
            return
        }

        val args = call.arguments as? Map<*, *> ?: emptyMap<Any, Any>()
        val status = args["status"] as? String ?: "error"
        externalShowValidationError.value = status != "success"
        result.success(null)
    }
}
