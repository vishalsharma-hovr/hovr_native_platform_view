import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hovr_native_platform_view/hovr_native_platform_view.dart';

void main() {
  group('PhoneSubmission', () {
    test('builds e164 from dial code and phone number', () {
      const submission = PhoneSubmission(
        phoneNumber: '9876543210',
        dialCode: '+91',
        countryIso: 'IN',
      );

      expect(submission.e164, '+919876543210');
    });

    test('fromMap parses native payload', () {
      final submission = PhoneSubmission.fromMap({
        'phoneNumber': '5551234567',
        'dialCode': '+1',
        'countryIso': 'CA',
      });

      expect(submission.phoneNumber, '5551234567');
      expect(submission.dialCode, '+1');
      expect(submission.countryIso, 'CA');
    });
  });

  group('PhoneEntryResult', () {
    test('success maps to status success', () {
      expect(PhoneEntryResult.success().toMap()['status'], 'success');
    });

    test('error maps message', () {
      final result = PhoneEntryResult.error('Invalid number');
      expect(result.toMap()['status'], 'error');
      expect(result.toMap()['message'], 'Invalid number');
    });
  });

  group('PhoneEntryChannel', () {
    test('parseSubmission returns null for unknown method', () {
      final submission = PhoneEntryChannel.parseSubmission(
        const MethodCall('unknown', null),
      );
      expect(submission, isNull);
    });
  });
}
