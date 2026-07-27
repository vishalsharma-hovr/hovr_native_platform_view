import Foundation

struct PhoneEntryCopy {
    var title: String = "Enter your phone number"
    var subtitle: String = "We'll text you a code to verify it."
    var mobileNumberLabel: String = "Mobile Number"
    var continueLabel: String = "Continue"
    var emptyPhoneError: String = "Please enter your phone number."
    var invalidPhoneError: String =
        "Sorry, we couldn't use this number. Please ensure it's correct for your region."
    var consentText: String =
        "By proceeding, you consent to get calls, WhatsApp or SMS messages, including by automated dialer, from Hovr and its affiliates to your provided number. You can opt out any time."
    var recaptchaPrefix: String = "This site is protected by reCAPTCHA and the AWS "
    var privacyPolicyLabel: String = "Privacy Policy"
    var recaptchaAnd: String = " and "
    var termsOfServiceLabel: String = "Terms of Service"
    var recaptchaSuffix: String = " apply."

    static func fromArgs(_ args: Any?) -> PhoneEntryCopy {
        guard let map = args as? [String: Any] else {
            return PhoneEntryCopy()
        }

        func read(_ key: String, _ fallback: String) -> String {
            if let value = map[key] as? String, !value.isEmpty {
                return value
            }
            return fallback
        }

        let defaults = PhoneEntryCopy()
        return PhoneEntryCopy(
            title: read("title", defaults.title),
            subtitle: read("subtitle", defaults.subtitle),
            mobileNumberLabel: read("mobileNumberLabel", defaults.mobileNumberLabel),
            continueLabel: read("continueLabel", defaults.continueLabel),
            emptyPhoneError: read("emptyPhoneError", defaults.emptyPhoneError),
            invalidPhoneError: read("invalidPhoneError", defaults.invalidPhoneError),
            consentText: read("consentText", defaults.consentText),
            recaptchaPrefix: read("recaptchaPrefix", defaults.recaptchaPrefix),
            privacyPolicyLabel: read("privacyPolicyLabel", defaults.privacyPolicyLabel),
            recaptchaAnd: read("recaptchaAnd", defaults.recaptchaAnd),
            termsOfServiceLabel: read("termsOfServiceLabel", defaults.termsOfServiceLabel),
            recaptchaSuffix: read("recaptchaSuffix", defaults.recaptchaSuffix)
        )
    }
}
