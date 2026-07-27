package com.ridehovr.hovr_native_platform_view.ui

import org.junit.Assert.assertEquals
import org.junit.Assert.assertFalse
import org.junit.Assert.assertTrue
import org.junit.Test

class PhoneEntryValidationTest {
    @Test
    fun canEnableContinue_usesRegionPossibleLength() {
        assertFalse(PhoneEntryValidation.canEnableContinue("12345", "US"))
        assertTrue(PhoneEntryValidation.canEnableContinue("2025550123", "US"))
        // Many EU numbers are shorter than 10 national digits.
        assertTrue(PhoneEntryValidation.canEnableContinue("612345678", "FR"))
    }

    @Test
    fun isValidPhone_validatesWorldwideRegions() {
        assertTrue(PhoneEntryValidation.isValidPhone("2025550123", "US"))
        assertFalse(PhoneEntryValidation.isValidPhone("12345", "US"))
        assertTrue(PhoneEntryValidation.isValidPhone("9876543210", "IN"))
        assertTrue(PhoneEntryValidation.isValidPhone("612345678", "FR"))
        assertFalse(PhoneEntryValidation.isValidPhone("12", "DE"))
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
