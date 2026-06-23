import Foundation

enum PhoneEntryChannelConstants {
    static let viewType = "phone_entry_view"
    static let phoneEntryBase = "hovr_native_platform_view/phone_entry"

    static func channelName(viewId: Int64) -> String {
        "\(phoneEntryBase)_\(viewId)"
    }

    static let onPhoneSubmitted = "onPhoneSubmitted"
    static let updateSubmissionStatus = "updateSubmissionStatus"
}

struct CountryCodeItem: Codable, Identifiable {
    var id: String { code }
    let name: String
    let flag: String
    let code: String
    let dial_code: String
}
