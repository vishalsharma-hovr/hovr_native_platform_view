/// Result sent from Dart back to native after async processing.
sealed class PhoneEntryResult {
  const PhoneEntryResult();

  factory PhoneEntryResult.success() = PhoneEntrySuccess;

  factory PhoneEntryResult.error([String message]) = PhoneEntryError;

  Map<String, String> toMap();
}

final class PhoneEntrySuccess extends PhoneEntryResult {
  const PhoneEntrySuccess();

  @override
  Map<String, String> toMap() => const {'status': 'success'};
}

final class PhoneEntryError extends PhoneEntryResult {
  const PhoneEntryError([this.message = '']);

  final String message;

  @override
  Map<String, String> toMap() => {'status': 'error', 'message': message};
}
