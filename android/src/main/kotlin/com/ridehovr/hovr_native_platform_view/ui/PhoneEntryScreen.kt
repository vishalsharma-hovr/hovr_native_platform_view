package com.ridehovr.hovr_native_platform_view.ui

import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Info
import androidx.compose.material3.HorizontalDivider
import androidx.compose.material3.Icon
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.focus.FocusRequester
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.platform.LocalDensity
import androidx.compose.ui.platform.LocalFocusManager
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.compose.ui.zIndex
import androidx.compose.foundation.layout.WindowInsets
import androidx.compose.foundation.layout.ime

import com.ridehovr.hovr_native_platform_view.CountryCodeLoader

@Composable
fun PhoneEntryScreen(
    externalShowValidationError: Boolean,
    onSubmit: (phoneNumber: String, dialCode: String, countryIso: String) -> Unit,
) {
    val context = LocalContext.current
    val initialCountries = remember(context) { CountryCodeLoader.loadSync(context) }
    var countries by remember(initialCountries) { mutableStateOf(initialCountries) }
    var isCountriesLoading by remember { mutableStateOf(false) }
    var dialCode by remember { mutableStateOf("+1") }
    var countryIso by remember { mutableStateOf("CA") }
    var countryFlag by remember { mutableStateOf("🇨🇦") }
    var phoneNumber by remember { mutableStateOf("") }
    var canContinue by remember { mutableStateOf(false) }
    var showValidationError by remember { mutableStateOf(false) }
    var isDropDownOpen by remember { mutableStateOf(false) }

    val focusRequester = remember { FocusRequester() }
    val focusManager = LocalFocusManager.current
    val keyboardOpen = WindowInsets.ime.getBottom(LocalDensity.current) > 0
    val displayError = showValidationError || externalShowValidationError

    LaunchedEffect(externalShowValidationError) {
        if (externalShowValidationError) {
            showValidationError = true
        }
    }

    Column(
        modifier = Modifier
            .fillMaxSize()
            .padding(top = 2.dp),
    ) {
        Text(
            text = "Enter your phone number",
            style = TextStyle(
                fontSize = 24.sp,
                lineHeight = 28.8.sp,
                fontWeight = FontWeight.SemiBold,
                color = PhoneEntryColors.black900,
            ),
            modifier = Modifier.padding(horizontal = 16.dp),
        )
        Spacer(modifier = Modifier.height(8.dp))
        Text(
            text = "We'll text you a code to verify it.",
            style = TextStyle(
                fontSize = 16.sp,
                lineHeight = 24.sp,
                fontWeight = FontWeight.Normal,
                color = PhoneEntryColors.grey600,
            ),
            modifier = Modifier.padding(horizontal = 16.dp),
        )
        Spacer(modifier = Modifier.height(32.dp))

        Box(
            modifier = Modifier
                .fillMaxWidth()
                .padding(horizontal = 16.dp)
                .padding(bottom = 10.dp)
                .zIndex(if (isDropDownOpen) 10f else 0f),
        ) {
            Column {
                Text(
                    text = "Mobile Number",
                    style = TextStyle(
                        fontSize = 14.sp,
                        fontWeight = FontWeight.Normal,
                        color = PhoneEntryColors.grey600,
                    ),
                    modifier = Modifier.padding(bottom = 8.dp),
                )

                Row(verticalAlignment = Alignment.CenterVertically) {
                    CountryCodeDropdown(
                        countryFlag = countryFlag,
                        isDropDownOpen = isDropDownOpen,
                        onDropDownToggle = { isDropDownOpen = it },
                        onDismissPhoneFocus = { focusManager.clearFocus() },
                    )
                    Spacer(modifier = Modifier.width(8.dp))
                    PhoneNumberField(
                        dialCode = dialCode,
                        phoneNumber = phoneNumber,
                        focusRequester = focusRequester,
                        onPhoneNumberChange = { value ->
                            phoneNumber = value
                            canContinue = PhoneEntryValidation.canEnableContinue(value)
                            if (canContinue) {
                                showValidationError = false
                            }
                        },
                        onFocusChanged = { focused ->
                            if (focused) {
                                isDropDownOpen = false
                            }
                        },
                    )
                }
            }

            CountryDropdownOverlay(
                countries = countries,
                isVisible = isDropDownOpen,
                isLoading = isCountriesLoading,
                onCountrySelected = { country ->
                    dialCode = country.dialCode
                    countryIso = country.code
                    countryFlag = country.flag
                    isDropDownOpen = false
                    canContinue = PhoneEntryValidation.canEnableContinue(phoneNumber)
                },
                modifier = Modifier
                    .padding(top = 88.dp)
                    .padding(horizontal = 0.dp),
            )
        }

        if (displayError) {
            Row(
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(horizontal = 16.dp)
                    .padding(bottom = 16.dp),
                verticalAlignment = Alignment.Top,
            ) {
                Icon(
                    imageVector = Icons.Filled.Info,
                    contentDescription = null,
                    tint = PhoneEntryColors.errorColor,
                    modifier = Modifier
                        .padding(end = 8.dp)
                        .width(15.dp)
                        .height(15.dp),
                )
                Text(
                    text = PhoneEntryValidation.errorMessage(phoneNumber),
                    style = TextStyle(
                        fontSize = 13.sp,
                        lineHeight = 18.2.sp,
                        color = PhoneEntryColors.errorColor,
                    ),
                )
            }
        } else {
            Spacer(modifier = Modifier.height(3.dp))
        }

        if (!isDropDownOpen) {
            HorizontalDivider(
                modifier = Modifier.padding(top = 21.dp),
                thickness = 0.75.dp,
                color = PhoneEntryColors.grey050,
            )

            Box(
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(top = 16.dp)
                    .padding(horizontal = 16.dp)
                    .height(60.dp)
                    .background(PhoneEntryColors.green400, RoundedCornerShape(16.dp))
                    .clickable {
                        when {
                            phoneNumber.isEmpty() -> showValidationError = true
                            !PhoneEntryValidation.isValidPhone(phoneNumber, dialCode) -> {
                                showValidationError = true
                            }
                            !canContinue -> showValidationError = true
                            else -> {
                                showValidationError = false
                                onSubmit(phoneNumber, dialCode, countryIso)
                            }
                        }
                    },
                contentAlignment = Alignment.Center,
            ) {
                Text(
                    text = "Continue",
                    style = TextStyle(
                        fontSize = 18.sp,
                        fontWeight = FontWeight.SemiBold,
                        color = PhoneEntryColors.white000,
                    ),
                )
            }
        }

        Spacer(modifier = Modifier.weight(1f))

        if (!keyboardOpen) {
            PhoneEntryFooter()
            Spacer(modifier = Modifier.height(50.dp))
        }
    }
}

data class CountryItem(
    val name: String,
    val flag: String,
    val code: String,
    val dialCode: String,
)
