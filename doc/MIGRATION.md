# Migration from in-app PlatformView

## Before

The HOVR driver app embedded phone-entry native code directly:

- iOS: `ios/Runner/NativeViews/EnterPhoneNumber/`, `ios/Runner/NativeViews/CountryCodeDropDown/`, `ios/Runner/Plugins/EnterYourPhoneNumber/`
- Android: `android/.../platformView/enterYourPhoneNumber/`, `EnterPhoneNumberActivity.kt`
- Dart: raw `AndroidView` / `UiKitView` and `enter_phone_number_method` channel
- Manual `registerViewFactory` in host native registrars
- Global channel `enter_phone_number_method` with `onOtpRequested` / `verifyOtp`

## After (host app)

1. Add `hovr_native_platform_view` dependency (`path` during development, `git` after publish).
2. Use `NativePhoneEntryView` + `PhoneEntryController` in [`enter_your_phone_number.dart`](../../../lib/features/authentication-feature/presentation/pages/enter_your_phone_number.dart).
3. Map `PhoneSubmission.e164` to your domain model (e.g. `Phone` proto).
4. Call `controller.notifyResult(PhoneEntryResult.success())` or `.error()` after async work.

No manual platform view registration is required in the host app.

## Host cleanup completed

The following legacy host paths were removed once the plugin was verified:

- [x] `ios/Runner/NativeViews/EnterPhoneNumber/`
- [x] `ios/Runner/NativeViews/CountryCodeDropDown/`
- [x] `ios/Runner/Plugins/EnterYourPhoneNumber/`
- [x] `ios/Runner/Plugins/PlatformVIew/CountryCodeDropDownPlatformView.swift`
- [x] `android/app/.../platformView/enterYourPhoneNumber/`
- [x] `android/app/.../EnterPhoneNumberActivity.kt`
- [x] `lib/core/platform/method_channels/enter-phone-number-channel/`
- [x] `NativeChannels.enterPhoneNumber` and legacy `native-view-channel` `enterYourPhoneNumber` handler

The Flutter route name `enterYourPhoneNumber` in `routes_name.dart` is unchanged; it navigates to the Dart screen that embeds the plugin.

## Publish consumption

After publishing to GitHub:

```yaml
dependencies:
  hovr_native_platform_view:
    git:
      url: https://github.com/vishalsharma-hovr/hovr_native_platform_view.git
      ref: v0.1.0
```
