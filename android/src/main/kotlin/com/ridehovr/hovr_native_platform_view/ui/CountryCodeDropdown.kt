package com.ridehovr.hovr_native_platform_view.ui

import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.clickable
import androidx.compose.foundation.gestures.detectTapGestures
import androidx.compose.foundation.interaction.MutableInteractionSource
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.text.BasicTextField
import androidx.compose.foundation.text.KeyboardActions
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.ArrowDropDown
import androidx.compose.material.icons.filled.Search
import androidx.compose.material3.CircularProgressIndicator
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
import androidx.compose.ui.draw.clip
import androidx.compose.ui.draw.rotate
import androidx.compose.ui.graphics.SolidColor
import androidx.compose.ui.input.pointer.pointerInput
import androidx.compose.ui.platform.LocalFocusManager
import androidx.compose.ui.platform.LocalSoftwareKeyboardController
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.input.ImeAction
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
    searchHint: String = "Search country",
    modifier: Modifier = Modifier,
) {
    if (!isVisible) {
        return
    }

    var searchQuery by remember { mutableStateOf("") }
    val focusManager = LocalFocusManager.current
    val keyboardController = LocalSoftwareKeyboardController.current

    LaunchedEffect(isVisible) {
        if (!isVisible) {
            searchQuery = ""
        }
    }

    val filteredCountries = remember(countries, searchQuery) {
        filterCountries(countries, searchQuery)
    }

    fun selectCountry(country: CountryItem) {
        // Capture first so clearing search / focus cannot drop the selection.
        val selected = country
        focusManager.clearFocus(force = true)
        keyboardController?.hide()
        onCountrySelected(selected)
        searchQuery = ""
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
        } else {
            Column(modifier = Modifier.fillMaxSize()) {
                CountrySearchField(
                    query = searchQuery,
                    hint = searchHint,
                    onQueryChange = { value -> searchQuery = value },
                    onSearchAction = {
                        focusManager.clearFocus(force = true)
                        keyboardController?.hide()
                    },
                    modifier = Modifier
                        .fillMaxWidth()
                        .padding(horizontal = 12.dp, vertical = 10.dp),
                )
                HorizontalDivider(
                    thickness = 0.75.dp,
                    color = PhoneEntryColors.grey050,
                )
                LazyColumn(
                    modifier = Modifier
                        .fillMaxSize()
                        .padding(horizontal = 8.dp),
                ) {
                    items(
                        items = filteredCountries,
                        key = { country -> "${country.code}-${country.dialCode}" },
                    ) { country ->
                        Row(
                            modifier = Modifier
                                .fillMaxWidth()
                                .pointerInput(country.code, country.dialCode) {
                                    // Hide IME on press so layout does not jump and
                                    // cancel the gesture before selection completes.
                                    detectTapGestures(
                                        onPress = {
                                            focusManager.clearFocus(force = true)
                                            keyboardController?.hide()
                                            val released = tryAwaitRelease()
                                            if (released) {
                                                selectCountry(country)
                                            }
                                        },
                                    )
                                }
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
    }
}

@Composable
private fun CountrySearchField(
    query: String,
    hint: String,
    onQueryChange: (String) -> Unit,
    onSearchAction: () -> Unit,
    modifier: Modifier = Modifier,
) {
    Row(
        modifier = modifier
            .height(40.dp)
            .clip(RoundedCornerShape(8.dp))
            .background(PhoneEntryColors.grey025)
            .padding(horizontal = 12.dp),
        verticalAlignment = Alignment.CenterVertically,
    ) {
        Icon(
            imageVector = Icons.Filled.Search,
            contentDescription = null,
            tint = PhoneEntryColors.grey600,
            modifier = Modifier
                .padding(end = 8.dp)
                .width(18.dp)
                .height(18.dp),
        )
        Box(modifier = Modifier.weight(1f)) {
            if (query.isEmpty()) {
                Text(
                    text = hint,
                    style = TextStyle(fontSize = 14.sp, color = PhoneEntryColors.grey600),
                )
            }
            BasicTextField(
                value = query,
                onValueChange = onQueryChange,
                singleLine = true,
                textStyle = TextStyle(fontSize = 14.sp, color = PhoneEntryColors.black900),
                cursorBrush = SolidColor(PhoneEntryColors.primaryBrand),
                keyboardOptions = KeyboardOptions(imeAction = ImeAction.Search),
                keyboardActions = KeyboardActions(onSearch = { onSearchAction() }),
                modifier = Modifier.fillMaxWidth(),
                interactionSource = remember { MutableInteractionSource() },
            )
        }
    }
}

internal fun filterCountries(countries: List<CountryItem>, query: String): List<CountryItem> {
    val normalized = query.trim().lowercase()
    if (normalized.isEmpty()) {
        return countries
    }
    val dialQuery = normalized.removePrefix("+")
    return countries.filter { country ->
        country.name.lowercase().contains(normalized) ||
            country.code.lowercase().contains(normalized) ||
            country.dialCode.lowercase().contains(normalized) ||
            country.dialCode.removePrefix("+").contains(dialQuery)
    }
}
