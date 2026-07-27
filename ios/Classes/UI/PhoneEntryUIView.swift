import SwiftUI

struct PhoneEntryUIView: View {
    @ObservedObject var viewModel: PhoneEntryViewModel
    var copy: PhoneEntryCopy = PhoneEntryCopy()

    @State private var keyboardShowToken: NSObjectProtocol?
    @State private var keyboardHideToken: NSObjectProtocol?
    @State private var isDropdownOpen = false

    var body: some View {
        ZStack {
            GeometryReader { _ in
                Color.clear
                    .contentShape(Rectangle())
                    .onTapGesture { hideKeyboard() }
            }

            VStack(alignment: .leading, spacing: 0) {
                headerSection

                CountryCodeDropDownUIView(
                    isDropDown: $isDropdownOpen,
                    countries: viewModel.countries,
                    isCountriesLoading: viewModel.isCountriesLoading,
                    mobileNumberLabel: copy.mobileNumberLabel,
                    countrySearchHint: copy.countrySearchHint,
                    onPhoneChanged: viewModel.updatePhoneState
                )
                .padding(.horizontal, 16)
                .padding(.bottom, 3)
                .zIndex(isDropdownOpen ? 10 : 1)

                validationSection
                    .padding(.horizontal, 16)

                if !isDropdownOpen {
                    continueSection
                        .zIndex(0)
                }

                Spacer()

                if !viewModel.isKeyboardVisible {
                    footerSection
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .onAppear { registerKeyboardObservers() }
        .onDisappear { unregisterKeyboardObservers() }
    }

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(copy.title)
                .font(.system(size: 24, weight: .semibold))
                .foregroundStyle(PhoneEntryTheme.black900)
            Text(copy.subtitle)
                .font(.system(size: 16, weight: .regular))
                .foregroundStyle(PhoneEntryTheme.grey600)
        }
        .padding(.horizontal, 16)
        .padding(.top, 2)
        .padding(.bottom, 32)
    }

    @ViewBuilder
    private var validationSection: some View {
        if viewModel.showValidationError {
            HStack(alignment: .top, spacing: 8) {
                Image(systemName: "exclamationmark.circle.fill")
                    .frame(width: 15, height: 15)
                    .foregroundColor(PhoneEntryTheme.errorCode)
                Text(
                    PhoneEntryValidation.errorMessage(
                        phone: viewModel.phoneNumber,
                        emptyMessage: copy.emptyPhoneError,
                        invalidMessage: copy.invalidPhoneError
                    )
                )
                    .font(.system(size: 13, weight: .regular))
                    .foregroundColor(PhoneEntryTheme.errorCode)
                    .multilineTextAlignment(.leading)
            }
            .padding(.bottom, 16)
        }
    }

    private var continueSection: some View {
        VStack(spacing: 0) {
            Divider()
                .padding(.top, 21)
                .padding(.bottom, 16)
            RoundedRectangle(cornerRadius: 16)
                .fill(PhoneEntryTheme.green400)
                .frame(height: 60)
                .padding(.horizontal, 16)
                .overlay {
                    Text(copy.continueLabel)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(PhoneEntryTheme.white000)
                }
                .onTapGesture { viewModel.submit() }
        }
    }

    private var footerSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(copy.consentText)
            .font(.system(size: 12))
            .foregroundStyle(PhoneEntryTheme.grey600)

            Text(makeAttributedLegalText())
                .font(.system(size: 12, weight: .regular))
                .foregroundStyle(PhoneEntryTheme.grey600)
                .onOpenURL { url in
                    UIApplication.shared.open(url)
                }
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 50)
    }

    private func makeAttributedLegalText() -> AttributedString {
        var string = AttributedString(
            "\(copy.recaptchaPrefix)\(copy.privacyPolicyLabel)\(copy.recaptchaAnd)\(copy.termsOfServiceLabel)\(copy.recaptchaSuffix)"
        )

        if let privacyRange = string.range(of: copy.privacyPolicyLabel) {
            string[privacyRange].foregroundColor = PhoneEntryTheme.primaryBrand
            string[privacyRange].font = .system(size: 12, weight: .semibold)
            string[privacyRange].link = URL(string: "https://aws.amazon.com/privacy/")
        }

        if let termsRange = string.range(of: copy.termsOfServiceLabel) {
            string[termsRange].foregroundColor = PhoneEntryTheme.primaryBrand
            string[termsRange].font = .system(size: 12, weight: .semibold)
            string[termsRange].link = URL(string: "https://aws.amazon.com/service-terms/")
        }

        return string
    }

    private func hideKeyboard() {
        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil,
            from: nil,
            for: nil
        )
    }

    private func registerKeyboardObservers() {
        keyboardShowToken = NotificationCenter.default.addObserver(
            forName: UIResponder.keyboardWillShowNotification,
            object: nil,
            queue: .main
        ) { _ in viewModel.isKeyboardVisible = true }

        keyboardHideToken = NotificationCenter.default.addObserver(
            forName: UIResponder.keyboardWillHideNotification,
            object: nil,
            queue: .main
        ) { _ in viewModel.isKeyboardVisible = false }
    }

    private func unregisterKeyboardObservers() {
        if let token = keyboardShowToken {
            NotificationCenter.default.removeObserver(token)
        }
        if let token = keyboardHideToken {
            NotificationCenter.default.removeObserver(token)
        }
    }
}
