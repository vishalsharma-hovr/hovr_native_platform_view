import SwiftUI

final class PhoneEntryViewModel: ObservableObject {
    @Published var phoneNumber = ""
    @Published var dialCode = "+1"
    @Published var countryIso = "CA"
    @Published var isKeyboardVisible = false
    @Published var showValidationError = false
    @Published var canContinue = false
    @Published var countries: [CountryCodeItem] = []
    @Published var isCountriesLoading = true

    var onSubmit: ((String, String, String) -> Void)?

    init() {
        CountryCodeLoader.loadAsync { [weak self] items in
            self?.countries = items
            self?.isCountriesLoading = false
        }
    }

    func applySubmissionStatus(isSuccess: Bool, message: String) {
        showValidationError = !isSuccess
    }

    func updatePhoneState(
        showContinue: Bool,
        phone: String,
        dialCode: String,
        countryIso: String
    ) {
        canContinue = showContinue
        phoneNumber = phone
        self.dialCode = dialCode
        self.countryIso = countryIso
        if showContinue {
            showValidationError = false
        }
    }

    func submit() {
        if phoneNumber.isEmpty {
            showValidationError = true
            return
        }

        if !PhoneEntryValidation.isValidPhone(phone: phoneNumber, dialCode: dialCode) {
            showValidationError = true
            return
        }

        guard canContinue else {
            showValidationError = true
            return
        }

        showValidationError = false
        onSubmit?(phoneNumber, dialCode, countryIso)
    }
}
