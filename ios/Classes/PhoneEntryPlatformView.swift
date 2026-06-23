import Flutter
import SwiftUI
import UIKit

final class PhoneEntryPlatformView: NSObject, FlutterPlatformView {
    private let viewModel = PhoneEntryViewModel()
    private let hostingController: UIHostingController<PhoneEntryUIView>
    private let channel: FlutterMethodChannel

    init(
        frame: CGRect,
        viewIdentifier viewId: Int64,
        messenger: FlutterBinaryMessenger
    ) {
        channel = FlutterMethodChannel(
            name: PhoneEntryChannelConstants.channelName(viewId: viewId),
            binaryMessenger: messenger
        )
        hostingController = UIHostingController(
            rootView: PhoneEntryUIView(viewModel: viewModel)
        )
        super.init()

        viewModel.onSubmit = { [weak self] phoneNumber, dialCode, countryIso in
            self?.sendSubmission(
                phoneNumber: phoneNumber,
                dialCode: dialCode,
                countryIso: countryIso
            )
        }

        channel.setMethodCallHandler { [weak self] call, result in
            self?.handleDartCall(call, result: result)
        }
        hostingController.view.frame = frame
        hostingController.view.backgroundColor = .clear
    }

    func view() -> UIView {
        hostingController.view
    }

    func dispose() {
        channel.setMethodCallHandler(nil)
        viewModel.onSubmit = nil
    }

    private func sendSubmission(
        phoneNumber: String,
        dialCode: String,
        countryIso: String
    ) {
        let payload: [String: Any] = [
            "phoneNumber": phoneNumber,
            "dialCode": dialCode,
            "countryIso": countryIso,
        ]
        channel.invokeMethod(PhoneEntryChannelConstants.onPhoneSubmitted, arguments: payload)
    }

    private func handleDartCall(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard call.method == PhoneEntryChannelConstants.updateSubmissionStatus else {
            result(FlutterMethodNotImplemented)
            return
        }

        let args = call.arguments as? [String: Any] ?? [:]
        let status = args["status"] as? String ?? "error"
        let message = args["message"] as? String ?? ""
        let isSuccess = status == "success"

        DispatchQueue.main.async { [weak self] in
            self?.viewModel.applySubmissionStatus(isSuccess: isSuccess, message: message)
        }
        result(nil)
    }
}
