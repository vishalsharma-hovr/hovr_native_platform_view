package com.ridehovr.hovr_native_platform_view

object PhoneEntryChannelConstants {
    const val VIEW_TYPE = "phone_entry_view"
    const val PHONE_ENTRY_BASE = "hovr_native_platform_view/phone_entry"
    const val ON_PHONE_SUBMITTED = "onPhoneSubmitted"
    const val UPDATE_SUBMISSION_STATUS = "updateSubmissionStatus"

    fun channelName(viewId: Int): String = "${PHONE_ENTRY_BASE}_$viewId"
}
