package com.ridehovr.hovr_native_platform_view

import kotlin.test.Test
import kotlin.test.assertEquals

internal class PhoneEntryChannelConstantsTest {
    @Test
    fun channelName_includesViewId() {
        assertEquals(
            "hovr_native_platform_view/phone_entry_42",
            PhoneEntryChannelConstants.channelName(42),
        )
    }

    @Test
    fun viewType_matchesDartContract() {
        assertEquals("phone_entry_view", PhoneEntryChannelConstants.VIEW_TYPE)
    }
}
