/// Typed payload sent from native when the user submits a phone number.
class PhoneSubmission {
  const PhoneSubmission({
    required this.phoneNumber,
    required this.dialCode,
    required this.countryIso,
  });

  factory PhoneSubmission.fromMap(Map<dynamic, dynamic> map) {
    return PhoneSubmission(
      phoneNumber: map['phoneNumber'] as String? ?? '',
      dialCode: map['dialCode'] as String? ?? '',
      countryIso: map['countryIso'] as String? ?? '',
    );
  }

  final String phoneNumber;
  final String dialCode;
  final String countryIso;

  String get e164 => '$dialCode$phoneNumber';

  Map<String, String> toMap() => {
    'phoneNumber': phoneNumber,
    'dialCode': dialCode,
    'countryIso': countryIso,
    'e164': e164,
  };

  @override
  String toString() => 'PhoneSubmission(e164: $e164, iso: $countryIso)';
}
