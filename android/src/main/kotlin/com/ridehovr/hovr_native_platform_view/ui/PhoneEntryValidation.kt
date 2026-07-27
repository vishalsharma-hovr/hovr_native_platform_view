package com.ridehovr.hovr_native_platform_view.ui

import com.google.i18n.phonenumbers.NumberParseException
import com.google.i18n.phonenumbers.PhoneNumberUtil
import com.google.i18n.phonenumbers.PhoneNumberUtil.ValidationResult

/**
 * Worldwide phone validation via Google's libphonenumber metadata
 * (bundled offline — no network call at runtime).
 */
object PhoneEntryValidation {
    private val phoneUtil: PhoneNumberUtil = PhoneNumberUtil.getInstance()

    fun digitCount(phone: String): Int = phone.count { it.isDigit() }

    /**
     * Enables Continue when the national number length is possible for [regionIso].
     */
    fun canEnableContinue(phone: String, regionIso: String): Boolean {
        if (phone.isBlank() || regionIso.isBlank()) return false
        return isPossiblePhone(phone, regionIso)
    }

    /**
     * Strict validity check for the selected country region.
     */
    fun isValidPhone(phone: String, regionIso: String): Boolean {
        if (phone.isBlank() || regionIso.isBlank()) return false
        return try {
            val region = regionIso.uppercase()
            val number = phoneUtil.parse(phone, region)
            phoneUtil.isValidNumber(number) && phoneUtil.isValidNumberForRegion(number, region)
        } catch (_: NumberParseException) {
            false
        }
    }

    fun errorMessage(
        phone: String,
        emptyMessage: String,
        invalidMessage: String,
    ): String {
        return if (phone.isEmpty()) emptyMessage else invalidMessage
    }

    private fun isPossiblePhone(phone: String, regionIso: String): Boolean {
        return try {
            val region = regionIso.uppercase()
            val number = phoneUtil.parse(phone, region)
            when (phoneUtil.isPossibleNumberWithReason(number)) {
                ValidationResult.IS_POSSIBLE,
                ValidationResult.IS_POSSIBLE_LOCAL_ONLY,
                -> true
                else -> false
            }
        } catch (_: NumberParseException) {
            false
        }
    }
}
