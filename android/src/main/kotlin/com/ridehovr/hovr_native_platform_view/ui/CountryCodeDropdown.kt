package com.ridehovr.hovr_native_platform_view.ui

import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.ArrowDropDown
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.material3.CircularProgressIndicator
import androidx.compose.material3.Icon
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.draw.rotate
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.compose.ui.zIndex

@Composable
internal fun CountryCodeDropdown(
    countryFlag: String,
    isDropDownOpen: Boolean,
    onDropDownToggle: (Boolean) -> Unit,
    onDismissPhoneFocus: () -> Unit,
) {
    Box(
        modifier = Modifier
            .width(81.dp)
            .height(50.dp)
            .clip(RoundedCornerShape(8.dp))
            .background(PhoneEntryColors.grey025)
            .then(
                if (isDropDownOpen) {
                    Modifier.border(1.5.dp, PhoneEntryColors.green700, RoundedCornerShape(8.dp))
                } else {
                    Modifier
                },
            )
            .clickable {
                onDismissPhoneFocus()
                onDropDownToggle(!isDropDownOpen)
            },
        contentAlignment = Alignment.Center,
    ) {
        Row(verticalAlignment = Alignment.CenterVertically) {
            Text(text = countryFlag, style = TextStyle(fontSize = 20.sp))
            Icon(
                imageVector = Icons.Filled.ArrowDropDown,
                contentDescription = null,
                tint = PhoneEntryColors.green800,
                modifier = Modifier.rotate(if (isDropDownOpen) 180f else 0f),
            )
        }
    }
}

@Composable
internal fun CountryDropdownOverlay(
    countries: List<CountryItem>,
    isVisible: Boolean,
    isLoading: Boolean,
    onCountrySelected: (CountryItem) -> Unit,
    modifier: Modifier = Modifier,
) {
    if (!isVisible) {
        return
    }

    Box(
        modifier = modifier
            .zIndex(1f)
            .fillMaxWidth()
            .height(280.dp)
            .clip(RoundedCornerShape(8.dp))
            .background(PhoneEntryColors.white000),
        contentAlignment = Alignment.Center,
    ) {
        if (isLoading) {
            CircularProgressIndicator(
                color = PhoneEntryColors.primaryBrand,
            )
            return
        }

        Column(
            modifier = Modifier
                .fillMaxSize()
                .verticalScroll(rememberScrollState())
                .padding(8.dp),
        ) {
            countries.forEach { country ->
                Row(
                    modifier = Modifier
                        .fillMaxWidth()
                        .clickable { onCountrySelected(country) }
                        .padding(vertical = 10.dp, horizontal = 8.dp),
                    verticalAlignment = Alignment.CenterVertically,
                ) {
                    Text(text = country.flag)
                    Text(
                        text = country.name,
                        modifier = Modifier
                            .weight(1f)
                            .padding(horizontal = 8.dp),
                    )
                    Text(text = country.dialCode)
                }
            }
        }
    }
}
