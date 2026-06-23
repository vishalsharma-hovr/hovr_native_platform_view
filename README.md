# hovr_native_platform_view

Native **PlatformView** plugin for HOVR Flutter apps. Ships a phone-entry UI on iOS (SwiftUI) and Android (Jetpack Compose) with a typed method-channel contract.

## Features

- `NativePhoneEntryView` — drop-in widget for phone number capture
- Per-view method channels (`hovr_native_platform_view/phone_entry_<viewId>`)
- Typed `PhoneSubmission` and `PhoneEntryResult` models
- Bundled `country_code.json`
- Example app under `example/`

## Requirements

- Flutter `>=3.24.0`
- Dart `>=3.10.0`
- iOS `15.0+` (SwiftUI `FocusState` and `foregroundStyle`)
- Android `minSdk 24` — host `MainActivity` must extend `FlutterFragmentActivity`

## Installation

### Path dependency (monorepo)

```yaml
dependencies:
  hovr_native_platform_view:
    path: packages/hovr_native_platform_view
```

### Git dependency

```yaml
dependencies:
  hovr_native_platform_view:
    git:
      url: https://github.com/vishalsharma-hovr/hovr_native_platform_view.git
      ref: v0.1.0
```

Then run `flutter pub get`. No manual native registration is required — the plugin registers `phone_entry_view` via `FlutterPlugin`.

## Quick start

```dart
import 'package:hovr_native_platform_view/hovr_native_platform_view.dart';

final controller = PhoneEntryController();

NativePhoneEntryView(
  controller: controller,
  onSubmitted: (submission) async {
    // submission.e164, submission.dialCode, submission.countryIso
    await controller.notifyResult(PhoneEntryResult.success());
  },
);
```

## Example app

```bash
cd example
flutter run
```

## Documentation

- [Architecture](doc/ARCHITECTURE.md)
- [Integration guide](doc/INTEGRATION.md)
- [Channel contract](doc/CHANNEL_CONTRACT.md)
- [Migration from in-app views](doc/MIGRATION.md)
- [Contributing](CONTRIBUTING.md)

## License

See [LICENSE](LICENSE).
