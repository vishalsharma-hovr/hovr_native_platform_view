package com.ridehovr.hovr_native_platform_view.ui

import androidx.compose.foundation.border
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.fillMaxHeight
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.material3.Text
import androidx.compose.material3.TextField
import androidx.compose.material3.TextFieldDefaults
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.focus.FocusRequester
import androidx.compose.ui.focus.focusRequester
import androidx.compose.ui.focus.onFocusChanged
import androidx.compose.ui.graphics.Color
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
) {
    var isFocused by remember { mutableStateOf(false) }

    if (requestInitialFocus) {
        LaunchedEffect(Unit) {
            focusRequester.requestFocus()
        }
    }

    Box(
        modifier = Modifier
            .height(50.dp)
            .clip(RoundedCornerShape(8.dp)),
    ) {
        TextField(
            value = phoneNumber,
            onValueChange = { value ->
                onPhoneNumberChange(value.filter(Char::isDigit))
            },
            modifier = Modifier
                .fillMaxHeight()
                .focusRequester(focusRequester)
                .onFocusChanged {
                    isFocused = it.isFocused
                    onFocusChanged(it.isFocused)
                },
            textStyle = TextStyle(fontSize = 16.sp, color = PhoneEntryColors.black900),
            keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number),
            colors = TextFieldDefaults.colors(
                focusedContainerColor = PhoneEntryColors.grey025,
                unfocusedContainerColor = PhoneEntryColors.grey025,
                focusedIndicatorColor = Color.Transparent,
                unfocusedIndicatorColor = Color.Transparent,
            ),
            shape = RoundedCornerShape(8.dp),
            singleLine = true,
            leadingIcon = {
                Text(
                    text = dialCode,
                    style = TextStyle(fontSize = 16.sp, color = PhoneEntryColors.black900),
                    modifier = Modifier.padding(start = 8.dp),
                )
            },
        )

        if (isFocused) {
            Box(
                modifier = Modifier
                    .matchParentSize()
                    .border(
                        width = 2.dp,
                        color = PhoneEntryColors.primaryBrand,
                        shape = RoundedCornerShape(10.dp),
                    ),
            )
        }
    }
}
