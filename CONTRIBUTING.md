# Contributing

## Setup

```bash
cd packages/hovr_native_platform_view
flutter pub get
```

## Before opening a PR

1. Format: `dart format lib test example/lib`
2. Analyze: `dart analyze lib test example/lib`
3. Contract: `dart run tool/check_channel_contract.dart`
4. Test: `flutter test`

## Engineering rules

Follow the Power of 10 rules in the repository root [`AGENTS.md`](../../AGENTS.md):

- No `setState(` in `lib/`
- No silent `catch (_)` in `lib/`
- Bridge owns method channels; UI uses callbacks only
- Clear channel handlers in `dispose()`

## Channel changes

Update **all three** layers when changing method names or payloads:

1. `lib/src/constants/channel_names.dart`
2. `android/.../PhoneEntryChannelConstants.kt`
3. `ios/Classes/PhoneEntryChannelConstants.swift`

Document breaking changes in `CHANGELOG.md` and `doc/CHANNEL_CONTRACT.md`.

## Publishing to GitHub

```bash
./tool/publish_to_github.sh v0.1.0
```

Target repo: [vishalsharma-hovr/hovr_native_platform_view](https://github.com/vishalsharma-hovr/hovr_native_platform_view)

Requires `brew install gh && gh auth login`.
