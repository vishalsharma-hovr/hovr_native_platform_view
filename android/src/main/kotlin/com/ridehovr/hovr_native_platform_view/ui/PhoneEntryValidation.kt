package com.ridehovr.hovr_native_platform_view.ui

/**
 * Lightweight phone-entry helpers. Format / region validation is intentionally
 * left to the backend — the UI only requires a non-empty national number.
 */
object PhoneEntryValidation {
    fun digitCount(phone: String): Int = phone.count { it.isDigit() }

    /** Enables Continue when the national number has at least one digit. */
    fun canEnableContinue(phone: String, regionIso: String = ""): Boolean {
        return phone.any { it.isDigit() }
    }

    /** True when the national number has at least one digit. */
    fun isValidPhone(phone: String, regionIso: String = ""): Boolean {
        return canEnableContinue(phone, regionIso)
    }

    fun errorMessage(
        phone: String,
        emptyMessage: String,
        invalidMessage: String,
    ): String {
        return if (phone.isEmpty()) emptyMessage else invalidMessage
    }
}
