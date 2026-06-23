import SwiftUI

struct CountryCodeDropDownUIView: View {
    @Binding var isDropDown: Bool
    let countries: [CountryCodeItem]
    let isCountriesLoading: Bool
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
                Text("Mobile Number")
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

                                HStack {
                                    Text(countryCode)
                                        .font(.system(size: 16))
                                        .foregroundStyle(.black)
                                        .padding(.leading, 17)
                                    TextField("", text: $mobileNumber)
                                        .keyboardType(.numberPad)
                                        .focused($mobileNumberIsFocused)
                                        .onChange(of: mobileNumber) { newValue in
                                            let digits = newValue.filter(\.isNumber)
                                            mobileNumber = digits
                                            if PhoneEntryValidation.canEnableContinue(phone: digits) {
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
                    showDropDown: $isDropDown,
                    selectedData: { flag, dialCode, iso in
                        countryCode = dialCode
                        countryFlag = flag
                        countryCodeISO = iso
                        iconName = "arrowtriangle.down.fill"
                        onPhoneChanged(
                            PhoneEntryValidation.canEnableContinue(phone: mobileNumber),
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

struct ExpandedDropDownView: View {
    let countries: [CountryCodeItem]
    let isLoading: Bool
    @Binding var showDropDown: Bool
    let selectedData: (_ countryFlag: String, _ countryCode: String, _ countryCodeISO: String) -> Void

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
                        ScrollView {
                            VStack {
                                ForEach(countries) { country in
                                    Button {
                                        showDropDown = false
                                        selectedData(country.flag, country.dial_code, country.code)
                                    } label: {
                                        HStack {
                                            Text(country.flag)
                                            Text(country.name)
                                                .multilineTextAlignment(.leading)
                                                .truncationMode(.tail)
                                                .frame(alignment: .leading)
                                            Spacer()
                                            Text(country.dial_code)
                                        }
                                        .padding(.vertical, 10)
                                        .padding(.horizontal, 8)
                                        .background(
                                            RoundedRectangle(cornerRadius: 5)
                                                .fill(PhoneEntryTheme.white000)
                                        )
                                    }
                                    .foregroundStyle(.black)
                                    .background(PhoneEntryTheme.white000)
                                }
                            }
                        }
                        .offset(y: 175)
                    }
                }
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
