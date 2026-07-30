# Changelog

All notable changes to this project are documented in this file.

## 0.1.2

- Remove client-side phone number format / region validation (libphonenumber, PhoneNumberKit)
- Enable Continue for any non-empty national number; keep empty-field error only
- Drop Android `libphonenumber` and iOS `PhoneNumberKit` dependencies
- Add country search in the phone-entry dropdown (name, ISO, dial code)
- Localize search hint via `countrySearchHint` creation param
- Vertically center dial code / number text in the phone field
- Fix first-tap country selection while the search keyboard is open
- Remove duplicate Kotlin sourceSet that caused conflicting overloads

## 0.1.1

- Pass localized phone-entry strings from Flutter via platform-view creation params
- Validate phone numbers worldwide with libphonenumber (Android) and PhoneNumberKit (iOS)

## [0.1.0] - 2026-06-23

### Added

- Initial release of `hovr_native_platform_view` Flutter plugin
- `NativePhoneEntryView` with iOS SwiftUI and Android Compose implementations
- Typed `PhoneSubmission` / `PhoneEntryResult` channel contract
- `PhoneEntryController` for Dart → native status updates
- Example app, tests, CI workflow, and channel contract checker
