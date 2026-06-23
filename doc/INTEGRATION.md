# Integration Guide

## 1. Add dependency

```yaml
dependencies:
  hovr_native_platform_view:
    path: packages/hovr_native_platform_view
```

Run `flutter pub get` from the host app root.

**iOS minimum:** 15.0 (plugin uses SwiftUI `FocusState`). HOVR driver targets iOS 16+.

**Android:** Host `MainActivity` should extend `FlutterFragmentActivity` (not `FlutterActivity`) so Compose PlatformViews receive a `LifecycleOwner` and `SavedStateRegistryOwner`.

## 2. Use the widget

```dart
import 'package:hovr_native_platform_view/hovr_native_platform_view.dart';

class PhoneScreen extends StatefulWidget {
  @override
  State<PhoneScreen> createState() => _PhoneScreenState();
}

class _PhoneScreenState extends State<PhoneScreen> {
  final _controller = PhoneEntryController();

  @override
  Widget build(BuildContext context) {
    return NativePhoneEntryView(
      controller: _controller,
      onSubmitted: _handleSubmission,
    );
  }

  Future<void> _handleSubmission(PhoneSubmission submission) async {
    try {
      await requestOtp(submission.e164);
      if (!mounted) return;
      await _controller.notifyResult(PhoneEntryResult.success());
    } catch (error) {
      if (!mounted) return;
      await _controller.notifyResult(PhoneEntryResult.error('$error'));
    }
  }
}
```

## 3. Native registration

**Not required.** The plugin registers `phone_entry_view` through `FlutterPlugin` when the host app includes the dependency.

Remove any legacy manual registration such as:

- `registerViewFactory("enter_your_phone_number_view", ...)` in Android
- Custom `registerPlatformViews` entries for the old phone view on iOS

## 4. Fonts

The plugin uses system fonts by default. To match HOVR branding with Inter, bundle Inter in the host app `pubspec.yaml` — the native UI will pick it up when configured in host theme resources.

## Troubleshooting

| Issue | Fix |
|-------|-----|
| Blank native view | Confirm `flutter pub get` and rebuild; check `phone_entry_view` is registered (plugin in `GeneratedPluginRegistrant`) |
| No callback on submit | Ensure `onSubmitted` is set; verify channel name includes correct `viewId` via `PhoneEntryController` |
| Error state not shown | Call `controller.notifyResult(PhoneEntryResult.error(...))` after async work |
| Gesture conflicts | `NativePlatformView` sets pan/scale/tap recognizers; wrap in `Expanded` or full-screen scaffold |
