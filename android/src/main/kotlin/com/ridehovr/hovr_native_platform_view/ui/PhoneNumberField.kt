package com.ridehovr.hovr_native_platform_view.ui

import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxHeight
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.text.BasicTextField
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.focus.FocusRequester
import androidx.compose.ui.focus.focusRequester
import androidx.compose.ui.focus.onFocusChanged
import androidx.compose.ui.graphics.SolidColor
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.input.KeyboardType
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp

@Composable
internal fun PhoneNumberField(
    dialCode: String,
    phoneNumber: String,
    onPhoneNumberChange: (String) -> Unit,
    onFocusChanged: (Boolean) -> Unit,
    focusRequester: FocusRequester = remember { FocusRequester() },
    requestInitialFocus: Boolean = true,
    modifier: Modifier = Modifier,
) {
    var isFocused by remember { mutableStateOf(false) }

    if (requestInitialFocus) {
        LaunchedEffect(Unit) {
            focusRequester.requestFocus()
        }
    }

    Box(
        modifier = modifier
            .height(50.dp)
            .fillMaxWidth()
            .clip(RoundedCornerShape(8.dp))
            .background(PhoneEntryColors.grey025)
            .then(
                if (isFocused) {
                    Modifier.border(
                        width = 2.dp,
                        color = PhoneEntryColors.primaryBrand,
                        shape = RoundedCornerShape(10.dp),
                    )
                } else {
                    Modifier
                },
            ),
        contentAlignment = Alignment.CenterStart,
    ) {
        Row(
            modifier = Modifier
                .fillMaxWidth()
                .fillMaxHeight()
                .padding(horizontal = 17.dp),
            verticalAlignment = Alignment.CenterVertically,
        ) {
            Text(
                text = dialCode,
                style = TextStyle(fontSize = 16.sp, color = PhoneEntryColors.black900),
            )
            Spacer(modifier = Modifier.width(6.dp))
            BasicTextField(
                value = phoneNumber,
                onValueChange = { value ->
                    onPhoneNumberChange(value.filter(Char::isDigit))
                },
                modifier = Modifier
                    .weight(1f)
                    .focusRequester(focusRequester)
                    .onFocusChanged {
                        isFocused = it.isFocused
                        onFocusChanged(it.isFocused)
                    },
                textStyle = TextStyle(fontSize = 16.sp, color = PhoneEntryColors.black900),
                keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number),
                singleLine = true,
                cursorBrush = SolidColor(PhoneEntryColors.primaryBrand),
            )
        }
    }
}
