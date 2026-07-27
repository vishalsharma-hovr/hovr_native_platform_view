import SwiftUI

struct CountryCodeDropDownUIView: View {
    @Binding var isDropDown: Bool
    let countries: [CountryCodeItem]
    let isCountriesLoading: Bool
    var mobileNumberLabel: String = "Mobile Number"
    var countrySearchHint: String = "Search country"
    let onPhoneChanged: (_ showContinue: Bool, _ phone: String, _ dialCode: String, _ countryIso: String) -> Void

    @State private var countryFlag = "🇨🇦"
    @State private var countryCode = "+1"
    @State private var countryCodeISO = "CA"
    @State private var validMobileNumber = true
    @State private var iconName = "arrowtriangle.down.fill"
    @FocusState private var mobileNumberIsFocused: Bool
    @State private var mobileNumber = ""

    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                Text(mobileNumberLabel)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundStyle(PhoneEntryTheme.grey600)

                HStack {
                    Rectangle()
                        .frame(height: 50)
                        .foregroundStyle(PhoneEntryTheme.grey025)
                        .frame(width: 81)
                        .cornerRadius(8)
                        .overlay {
                            CountryFlagView(countryFlag: $countryFlag, iconName: $iconName)
                            if isDropDown {
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(lineWidth: 1.5)
                                    .foregroundStyle(PhoneEntryTheme.green700)
                            }
                        }
                        .onTapGesture {
                            mobileNumberIsFocused = false
                            isDropDown.toggle()
                            iconName = isDropDown ? "arrowtriangle.up.fill" : "arrowtriangle.down.fill"
                        }

                    Rectangle()
                        .frame(height: 50)
                        .foregroundStyle(validMobileNumber ? PhoneEntryTheme.errorCode : PhoneEntryTheme.grey025)
                        .cornerRadius(8)
                        .overlay {
                            ZStack {
                                Rectangle()
                                    .foregroundStyle(PhoneEntryTheme.grey025)
                                    .cornerRadius(8)
                                    .overlay {
                                        if mobileNumberIsFocused {
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(lineWidth: 2)
                                                .foregroundStyle(PhoneEntryTheme.primaryBrand)
                                        }
                                    }

                                HStack(alignment: .center, spacing: 6) {
                                    Text(countryCode)
                                        .font(.system(size: 16))
                                        .foregroundStyle(.black)
                                    TextField("", text: $mobileNumber)
                                        .textFieldStyle(.plain)
                                        .font(.system(size: 16))
                                        .keyboardType(.numberPad)
                                        .focused($mobileNumberIsFocused)
                                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                                        .onChange(of: mobileNumber) { newValue in
                                            let digits = newValue.filter(\.isNumber)
                                            mobileNumber = digits
                                            if PhoneEntryValidation.canEnableContinue(
                                                phone: digits,
                                                regionIso: countryCodeISO
                                            ) {
                                                validMobileNumber = true
                                                onPhoneChanged(
                                                    true,
                                                    digits,
                                                    countryCode,
                                                    countryCodeISO
                                                )
                                            } else {
                                                validMobileNumber = false
                                                onPhoneChanged(false, "", "", "")
                                            }
                                        }
                                        .onChange(of: mobileNumberIsFocused) { focused in
                                            if focused, isDropDown {
                                                isDropDown = false
                                                iconName = "arrowtriangle.down.fill"
                                            }
                                        }
                                        .textInputAutocapitalization(.never)
                                        .disableAutocorrection(true)
                                        .onAppear {
                                            mobileNumberIsFocused = true
                                        }
                                }
                                .padding(.horizontal, 17)
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                            }
                        }
                }
            }
            .padding(.bottom, 10)
            .zIndex(0)
            .overlay {
                ExpandedDropDownView(
                    countries: countries,
                    isLoading: isCountriesLoading,
                    searchHint: countrySearchHint,
                    showDropDown: $isDropDown,
                    selectedData: { flag, dialCode, iso in
                        countryCode = dialCode
                        countryFlag = flag
                        countryCodeISO = iso
                        iconName = "arrowtriangle.down.fill"
                        onPhoneChanged(
                            PhoneEntryValidation.canEnableContinue(
                                phone: mobileNumber,
                                regionIso: countryCodeISO
                            ),
                            mobileNumber,
                            countryCode,
                            countryCodeISO
                        )
                    }
                )
            }
        }
    }
}

struct CountryFlagView: View {
    @Binding var countryFlag: String
    @Binding var iconName: String

    var body: some View {
        HStack {
            Text(countryFlag)
            Image(systemName: iconName)
                .resizable()
                .frame(width: 10, height: 5)
                .foregroundStyle(PhoneEntryTheme.green800)
        }
    }
}

/// Avoid first-tap-dismisses-keyboard eating row selection (iOS 16+).
private struct KeepKeyboardOnScrollModifier: ViewModifier {
    func body(content: Content) -> some View {
        if #available(iOS 16.0, *) {
            content.scrollDismissesKeyboard(.never)
        } else {
            content
        }
    }
}

struct ExpandedDropDownView: View {
    let countries: [CountryCodeItem]
    let isLoading: Bool
    var searchHint: String = "Search country"
    @Binding var showDropDown: Bool
    let selectedData: (_ countryFlag: String, _ countryCode: String, _ countryCodeISO: String) -> Void

    @State private var searchQuery = ""
    @FocusState private var searchIsFocused: Bool

    private var filteredCountries: [CountryCodeItem] {
        Self.filterCountries(countries, query: searchQuery)
    }

    var body: some View {
        if showDropDown {
            Rectangle()
                .foregroundStyle(PhoneEntryTheme.white000)
                .cornerRadius(8)
                .shadow(color: .black.opacity(0.12), radius: 8, y: 4)
                .frame(height: 280)
                .offset(y: 175)
                .zIndex(20)
                .overlay {
                    if isLoading {
                        ProgressView()
                            .tint(PhoneEntryTheme.primaryBrand)
                            .offset(y: 175)
                    } else {
                        VStack(spacing: 0) {
                            HStack(spacing: 8) {
                                Image(systemName: "magnifyingglass")
                                    .foregroundStyle(PhoneEntryTheme.grey600)
                                    .font(.system(size: 14))
                                TextField(searchHint, text: $searchQuery)
                                    .textFieldStyle(.plain)
                                    .font(.system(size: 14))
                                    .focused($searchIsFocused)
                                    .textInputAutocapitalization(.never)
                                    .disableAutocorrection(true)
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 10)
                            .background(PhoneEntryTheme.grey025)
                            .cornerRadius(8)
                            .padding(.horizontal, 12)
                            .padding(.top, 10)
                            .padding(.bottom, 8)

                            Divider()
                                .background(PhoneEntryTheme.grey050)

                            ScrollView {
                                LazyVStack(spacing: 0) {
                                    ForEach(filteredCountries) { country in
                                        HStack {
                                            Text(country.flag)
                                            Text(country.name)
                                                .multilineTextAlignment(.leading)
                                                .truncationMode(.tail)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                            Text(country.dial_code)
                                        }
                                        .padding(.vertical, 10)
                                        .padding(.horizontal, 8)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .contentShape(Rectangle())
                                        .onTapGesture {
                                            let selected = country
                                            searchIsFocused = false
                                            showDropDown = false
                                            selectedData(
                                                selected.flag,
                                                selected.dial_code,
                                                selected.code
                                            )
                                            searchQuery = ""
                                        }
                                        .foregroundStyle(.black)
                                    }
                                }
                                .padding(.horizontal, 8)
                            }
                            .modifier(KeepKeyboardOnScrollModifier())
                        }
                        .offset(y: 175)
                    }
                }
                .onChange(of: showDropDown) { isOpen in
                    if !isOpen {
                        searchQuery = ""
                        searchIsFocused = false
                    }
                }
        }
    }

    static func filterCountries(_ countries: [CountryCodeItem], query: String) -> [CountryCodeItem] {
        let normalized = query.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        guard !normalized.isEmpty else { return countries }
        let dialQuery = normalized.hasPrefix("+") ? String(normalized.dropFirst()) : normalized
        return countries.filter { country in
            country.name.lowercased().contains(normalized)
                || country.code.lowercased().contains(normalized)
                || country.dial_code.lowercased().contains(normalized)
                || country.dial_code.replacingOccurrences(of: "+", with: "").contains(dialQuery)
        }
    }
}

#if DEBUG
private enum CountryCodeDropDownPreviewData {
    static let sampleCountries: [CountryCodeItem] = [
        CountryCodeItem(name: "Canada", flag: "🇨🇦", code: "CA", dial_code: "+1"),
        CountryCodeItem(name: "Afghanistan", flag: "🇦🇫", code: "AF", dial_code: "+93"),
        CountryCodeItem(name: "Albania", flag: "🇦🇱", code: "AL", dial_code: "+355"),
        CountryCodeItem(name: "Algeria", flag: "🇩🇿", code: "DZ", dial_code: "+213"),
        CountryCodeItem(name: "American Samoa", flag: "🇦🇸", code: "AS", dial_code: "+1684"),
        CountryCodeItem(name: "India", flag: "🇮🇳", code: "IN", dial_code: "+91"),
        CountryCodeItem(name: "United States", flag: "🇺🇸", code: "US", dial_code: "+1"),
    ]
}

private struct CountryCodeDropDownPreviewContainer: View {
    @State private var isDropDown: Bool
    let isCountriesLoading: Bool

    init(isDropDown: Bool = false, isCountriesLoading: Bool = false) {
        _isDropDown = State(initialValue: isDropDown)
        self.isCountriesLoading = isCountriesLoading
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Enter your phone number")
                .font(.system(size: 24, weight: .semibold))
                .foregroundStyle(PhoneEntryTheme.black900)
            Text("We'll text you a code to verify it.")
                .font(.system(size: 16))
                .foregroundStyle(PhoneEntryTheme.grey600)
                .padding(.top, 8)
                .padding(.bottom, 32)

            CountryCodeDropDownUIView(
                isDropDown: $isDropDown,
                countries: CountryCodeDropDownPreviewData.sampleCountries,
                isCountriesLoading: isCountriesLoading,
                onPhoneChanged: { _, _, _, _ in }
            )
        }
        .padding(.horizontal, 16)
        .padding(.top, 2)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(PhoneEntryTheme.white000)
    }
}

#Preview("Country code dropdown") {
    CountryCodeDropDownPreviewContainer()
}

#Preview("Dropdown open") {
    CountryCodeDropDownPreviewContainer(isDropDown: true)
}

#Preview("Dropdown loading") {
    CountryCodeDropDownPreviewContainer(isDropDown: true, isCountriesLoading: true)
}
#endif
