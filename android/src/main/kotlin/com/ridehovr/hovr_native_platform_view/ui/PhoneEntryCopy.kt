package com.ridehovr.hovr_native_platform_view.ui

data class PhoneEntryCopy(
    val title: String = "Enter your phone number",
    val subtitle: String = "We'll text you a code to verify it.",
    val mobileNumberLabel: String = "Mobile Number",
    val continueLabel: String = "Continue",
    val emptyPhoneError: String = "Please enter your phone number.",
    val invalidPhoneError: String =
        "Sorry, we couldn't use this number. Please ensure it's correct for your region.",
    val consentText: String =
        "By proceeding, you consent to get calls, WhatsApp or SMS messages, including by automated dialer, from Hovr and its affiliates to your provided number. You can opt out any time.",
    val recaptchaPrefix: String = "This site is protected by reCAPTCHA and the AWS ",
    val privacyPolicyLabel: String = "Privacy Policy",
    val recaptchaAnd: String = " and ",
    val termsOfServiceLabel: String = "Terms of Service",
    val recaptchaSuffix: String = " apply.",
) {
    companion object {
        fun fromArgs(args: Map<*, *>?): PhoneEntryCopy {
            if (args == null) return PhoneEntryCopy()
            fun read(key: String, fallback: String): String {
                val value = args[key] as? String
                return if (value.isNullOrBlank()) fallback else value
            }
            val defaults = PhoneEntryCopy()
            return PhoneEntryCopy(
                title = read("title", defaults.title),
                subtitle = read("subtitle", defaults.subtitle),
                mobileNumberLabel = read("mobileNumberLabel", defaults.mobileNumberLabel),
                continueLabel = read("continueLabel", defaults.continueLabel),
                emptyPhoneError = read("emptyPhoneError", defaults.emptyPhoneError),
                invalidPhoneError = read("invalidPhoneError", defaults.invalidPhoneError),
                consentText = read("consentText", defaults.consentText),
                recaptchaPrefix = read("recaptchaPrefix", defaults.recaptchaPrefix),
                privacyPolicyLabel = read("privacyPolicyLabel", defaults.privacyPolicyLabel),
                recaptchaAnd = read("recaptchaAnd", defaults.recaptchaAnd),
                termsOfServiceLabel = read("termsOfServiceLabel", defaults.termsOfServiceLabel),
                recaptchaSuffix = read("recaptchaSuffix", defaults.recaptchaSuffix),
            )
        }
    }
}
