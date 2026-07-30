import Foundation

/// Lightweight phone-entry helpers. Format / region validation is intentionally
/// left to the backend — the UI only requires a non-empty national number.
enum PhoneEntryValidation {
    static func digitCount(_ phone: String) -> Int {
        phone.filter(\.isNumber).count
    }

    /// Enables Continue when the national number has at least one digit.
    static func canEnableContinue(phone: String, regionIso: String = "") -> Bool {
        phone.contains(where: \.isNumber)
    }

    /// True when the national number has at least one digit.
    static func isValidPhone(phone: String, regionIso: String = "") -> Bool {
        canEnableContinue(phone: phone, regionIso: regionIso)
    }

    static func errorMessage(
        phone: String,
        emptyMessage: String,
        invalidMessage: String
    ) -> String {
        if phone.isEmpty {
            return emptyMessage
        }
        return invalidMessage
    }
}
