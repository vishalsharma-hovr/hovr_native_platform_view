/// Localized copy for [NativePhoneEntryView].
///
/// Defaults match the previous hardcoded English UI so callers can opt in
/// gradually. Values are forwarded to Android/iOS via platform-view creation
/// params.
class PhoneEntryStrings {
  const PhoneEntryStrings({
    this.title = 'Enter your phone number',
    this.subtitle = "We'll text you a code to verify it.",
    this.mobileNumberLabel = 'Mobile Number',
    this.countrySearchHint = 'Search country',
    this.continueLabel = 'Continue',
    this.emptyPhoneError = 'Please enter your phone number.',
    this.invalidPhoneError =
        "Sorry, we couldn't use this number. Please ensure it's correct for your region.",
    this.consentText =
        'By proceeding, you consent to get calls, WhatsApp or SMS messages, including by automated dialer, from Hovr and its affiliates to your provided number. You can opt out any time.',
    this.recaptchaPrefix = 'This site is protected by reCAPTCHA and the AWS ',
    this.privacyPolicyLabel = 'Privacy Policy',
    this.recaptchaAnd = ' and ',
    this.termsOfServiceLabel = 'Terms of Service',
    this.recaptchaSuffix = ' apply.',
  });

  final String title;
  final String subtitle;
  final String mobileNumberLabel;
  final String countrySearchHint;
  final String continueLabel;
  final String emptyPhoneError;
  final String invalidPhoneError;
  final String consentText;
  final String recaptchaPrefix;
  final String privacyPolicyLabel;
  final String recaptchaAnd;
  final String termsOfServiceLabel;
  final String recaptchaSuffix;

  Map<String, dynamic> toCreationParams() {
    return {
      'title': title,
      'subtitle': subtitle,
      'mobileNumberLabel': mobileNumberLabel,
      'countrySearchHint': countrySearchHint,
      'continueLabel': continueLabel,
      'emptyPhoneError': emptyPhoneError,
      'invalidPhoneError': invalidPhoneError,
      'consentText': consentText,
      'recaptchaPrefix': recaptchaPrefix,
      'privacyPolicyLabel': privacyPolicyLabel,
      'recaptchaAnd': recaptchaAnd,
      'termsOfServiceLabel': termsOfServiceLabel,
      'recaptchaSuffix': recaptchaSuffix,
    };
  }

  static PhoneEntryStrings fromCreationParams(Map<Object?, Object?>? params) {
    if (params == null || params.isEmpty) {
      return const PhoneEntryStrings();
    }

    String read(String key, String fallback) {
      final value = params[key];
      if (value is String && value.isNotEmpty) {
        return value;
      }
      return fallback;
    }

    const defaults = PhoneEntryStrings();
    return PhoneEntryStrings(
      title: read('title', defaults.title),
      subtitle: read('subtitle', defaults.subtitle),
      mobileNumberLabel: read('mobileNumberLabel', defaults.mobileNumberLabel),
      countrySearchHint: read('countrySearchHint', defaults.countrySearchHint),
      continueLabel: read('continueLabel', defaults.continueLabel),
      emptyPhoneError: read('emptyPhoneError', defaults.emptyPhoneError),
      invalidPhoneError: read('invalidPhoneError', defaults.invalidPhoneError),
      consentText: read('consentText', defaults.consentText),
      recaptchaPrefix: read('recaptchaPrefix', defaults.recaptchaPrefix),
      privacyPolicyLabel: read('privacyPolicyLabel', defaults.privacyPolicyLabel),
      recaptchaAnd: read('recaptchaAnd', defaults.recaptchaAnd),
      termsOfServiceLabel: read('termsOfServiceLabel', defaults.termsOfServiceLabel),
      recaptchaSuffix: read('recaptchaSuffix', defaults.recaptchaSuffix),
    );
  }
}
