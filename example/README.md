# Example App

Demonstrates `NativePhoneEntryView` without the full HOVR driver app.

```bash
cd packages/hovr_native_platform_view/example
flutter pub get
flutter run
```

On submit, the example shows the captured E.164 number and sends `PhoneEntryResult.success()` back to native.
