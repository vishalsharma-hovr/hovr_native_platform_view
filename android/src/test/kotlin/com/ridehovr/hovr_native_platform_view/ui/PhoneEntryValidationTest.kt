package com.ridehovr.hovr_native_platform_view.ui

import org.junit.Assert.assertEquals
import org.junit.Assert.assertFalse
import org.junit.Assert.assertTrue
import org.junit.Test

class PhoneEntryValidationTest {
    @Test
    fun canEnableContinue_requiresAtLeastOneDigit() {
        assertFalse(PhoneEntryValidation.canEnableContinue("", "US"))
        assertFalse(PhoneEntryValidation.canEnableContinue("   ", "US"))
        assertTrue(PhoneEntryValidation.canEnableContinue("1", "US"))
        assertTrue(PhoneEntryValidation.canEnableContinue("12345", "US"))
        assertTrue(PhoneEntryValidation.canEnableContinue("2025550123", "FR"))
    }

    @Test
    fun isValidPhone_matchesCanEnableContinue() {
        assertFalse(PhoneEntryValidation.isValidPhone("", "US"))
        assertTrue(PhoneEntryValidation.isValidPhone("12", "DE"))
        assertTrue(PhoneEntryValidation.isValidPhone("9876543210", "IN"))
    }

    @Test
    fun errorMessage_matchesEmptyAndInvalid() {
        assertEquals(
            "Please enter your phone number.",
            PhoneEntryValidation.errorMessage(
                "",
                "Please enter your phone number.",
                "Sorry, we couldn't use this number. Please ensure it's correct for your region.",
            ),
        )
        assertEquals(
            "Sorry, we couldn't use this number. Please ensure it's correct for your region.",
            PhoneEntryValidation.errorMessage(
                "123",
                "Please enter your phone number.",
                "Sorry, we couldn't use this number. Please ensure it's correct for your region.",
            ),
        )
    }
}
