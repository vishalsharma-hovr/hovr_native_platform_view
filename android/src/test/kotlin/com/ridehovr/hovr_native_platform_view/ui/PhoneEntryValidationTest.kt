package com.ridehovr.hovr_native_platform_view.ui

import org.junit.Assert.assertEquals
import org.junit.Assert.assertFalse
import org.junit.Assert.assertTrue
import org.junit.Test

class PhoneEntryValidationTest {
    @Test
    fun canEnableContinue_requiresTenDigits() {
        assertFalse(PhoneEntryValidation.canEnableContinue("123456789"))
        assertTrue(PhoneEntryValidation.canEnableContinue("1234567890"))
    }

    @Test
    fun isValidPhone_usCanadaIndia() {
        assertTrue(PhoneEntryValidation.isValidPhone("1234567890", "+1"))
        assertFalse(PhoneEntryValidation.isValidPhone("12345", "+1"))
    }

    @Test
    fun errorMessage_matchesEmptyAndInvalid() {
        assertEquals(
            "Please enter your phone number.",
            PhoneEntryValidation.errorMessage(""),
        )
        assertEquals(
            "Sorry, we couldn't use this number. Please ensure it's correct for your region.",
            PhoneEntryValidation.errorMessage("123"),
        )
    }
}
