import Foundation

enum PhoneEntryValidation {
    static func digitCount(_ phone: String) -> Int {
        phone.filter(\.isNumber).count
    }

    static func canEnableContinue(phone: String) -> Bool {
        digitCount(phone) >= 10
    }

    static func isValidPhone(phone: String, dialCode: String) -> Bool {
        let digits = digitCount(phone)
        switch dialCode {
        case "+91", "+1":
            return digits == 10
        default:
            return digits >= 6 && digits <= 12
        }
    }

    static func errorMessage(phone: String) -> String {
        if phone.isEmpty {
            return "Please enter your phone number."
        }
        return "Sorry, we couldn't use this number. Please ensure it's correct for your region."
    }
}
