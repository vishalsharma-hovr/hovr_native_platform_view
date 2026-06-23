# Channel Contract

Version: **0.1.0**

## View type

| Platform | Identifier |
|----------|------------|
| Dart | `ViewTypes.phoneEntry` → `phone_entry_view` |
| Android | `PhoneEntryChannelConstants.VIEW_TYPE` |
| iOS | `PhoneEntryChannelConstants.viewType` |

## Channel name

Per platform view instance:

```
hovr_native_platform_view/phone_entry_<viewId>
```

`<viewId>` is the integer from `onPlatformViewCreated`.

## Methods

### Native → Dart: `onPhoneSubmitted`

Payload:

| Field | Type | Description |
|-------|------|-------------|
| `phoneNumber` | string | National number without dial code |
| `dialCode` | string | E.164 dial prefix, e.g. `+1` |
| `countryIso` | string | ISO 3166-1 alpha-2, e.g. `CA` |

Dart type: `PhoneSubmission`

### Dart → Native: `updateSubmissionStatus`

Payload:

| Field | Type | Description |
|-------|------|-------------|
| `status` | string | `success` or `error` |
| `message` | string | Optional error message when `status` is `error` |

Dart type: `PhoneEntryResult`

## Versioning

- **Patch**: documentation, non-breaking native UI tweaks
- **Minor**: new optional payload fields (backward compatible)
- **Major**: renamed methods, removed fields, or view type changes

Update `tool/check_channel_contract.dart` when changing constants.
