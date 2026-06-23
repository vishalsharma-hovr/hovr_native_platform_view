package com.ridehovr.hovr_native_platform_view.ui

import android.content.Intent
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.text.ClickableText
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.text.SpanStyle
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.buildAnnotatedString
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.withStyle
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.core.net.toUri

@Composable
internal fun PhoneEntryFooter(modifier: Modifier = Modifier) {
    val context = LocalContext.current

    Column(modifier = modifier.padding(horizontal = 16.dp)) {
        Text(
            text = "By proceeding, you consent to get calls, WhatsApp or SMS messages, including by automated dialer, from Hovr and its affiliates to your provided number. You can opt out any time.",
            style = TextStyle(fontSize = 12.sp, color = PhoneEntryColors.grey600),
            modifier = Modifier.padding(bottom = 10.dp),
        )

        val legalText = buildAnnotatedString {
            append("This site is protected by reCAPTCHA and the AWS ")

            pushStringAnnotation(tag = "PRIVACY_POLICY", annotation = "https://aws.amazon.com/privacy/")
            withStyle(
                SpanStyle(
                    color = PhoneEntryColors.primaryBrand,
                    fontSize = 12.sp,
                    fontWeight = FontWeight.SemiBold,
                ),
            ) {
                append("Privacy Policy")
            }
            pop()

            append(" and ")

            pushStringAnnotation(tag = "TERMS_OF_SERVICE", annotation = "https://aws.amazon.com/service-terms/")
            withStyle(
                SpanStyle(
                    color = PhoneEntryColors.primaryBrand,
                    fontSize = 12.sp,
                    fontWeight = FontWeight.SemiBold,
                ),
            ) {
                append("Terms of Service")
            }
            pop()

            append(" apply.")
        }

        ClickableText(
            text = legalText,
            style = TextStyle(fontSize = 12.sp, color = PhoneEntryColors.grey600),
            onClick = { offset ->
                legalText.getStringAnnotations("PRIVACY_POLICY", offset, offset)
                    .firstOrNull()
                    ?.let {
                        context.startActivity(
                            Intent(Intent.ACTION_VIEW, "https://aws.amazon.com/privacy/".toUri()),
                        )
                    }
                legalText.getStringAnnotations("TERMS_OF_SERVICE", offset, offset)
                    .firstOrNull()
                    ?.let {
                        context.startActivity(
                            Intent(Intent.ACTION_VIEW, "https://aws.amazon.com/service-terms/".toUri()),
                        )
                    }
            },
        )
    }
}
