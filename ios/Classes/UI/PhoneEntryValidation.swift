import Foundation
import PhoneNumberKit

/// Worldwide phone validation via PhoneNumberKit / libphonenumber metadata
/// (bundled offline — no network call at runtime).
enum PhoneEntryValidation {
    private static let phoneNumberKit = PhoneNumberKit()

    static func digitCount(_ phone: String) -> Int {
        phone.filter(\.isNumber).count
    }

    /// Enables Continue once the number is valid for [regionIso].
    static func canEnableContinue(phone: String, regionIso: String) -> Bool {
        isValidPhone(phone: phone, regionIso: regionIso)
    }

    /// Strict validity check for the selected country region.
    static func isValidPhone(phone: String, regionIso: String) -> Bool {
        guard !phone.isEmpty, !regionIso.isEmpty else { return false }
        let region = regionIso.uppercased()
        return phoneNumberKit.isValidPhoneNumber(phone, withRegion: region)
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
