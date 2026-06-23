package com.ridehovr.hovr_native_platform_view.ui

object PhoneEntryValidation {
    fun digitCount(phone: String): Int = phone.count { it.isDigit() }

    fun canEnableContinue(phone: String): Boolean = digitCount(phone) >= 10

    fun isValidPhone(phone: String, dialCode: String): Boolean {
        val digits = digitCount(phone)
        return when (dialCode) {
            "+91", "+1" -> digits == 10
            else -> digits in 6..12
        }
    }

    fun errorMessage(phone: String): String {
        return if (phone.isEmpty()) {
            "Please enter your phone number."
        } else {
            "Sorry, we couldn't use this number. Please ensure it's correct for your region."
        }
    }
}
