#!/usr/bin/env dart
// Validates phone-entry channel constants across Dart, Android, and iOS.

import 'dart:io';

void main() {
  final root = Directory.current.path.endsWith('tool')
      ? Directory('..')
      : Directory.current;

  final dartConstants = _readDartConstants(
    File('${root.path}/lib/src/constants/channel_names.dart'),
  );
  final dartViewType = _readDartViewType(
    File('${root.path}/lib/src/constants/view_types.dart'),
  );

  final androidConstants = _readKotlinConstants(
    File(
      '${root.path}/android/src/main/kotlin/com/ridehovr/hovr_native_platform_view/PhoneEntryChannelConstants.kt',
    ),
  );
  final iosConstants = _readSwiftConstants(
    File('${root.path}/ios/Classes/PhoneEntryChannelConstants.swift'),
  );

  var failed = false;

  for (final entry in dartConstants.entries) {
    if (androidConstants[entry.key] != entry.value) {
      stderr.writeln('Android mismatch for ${entry.key}: ${entry.value}');
      failed = true;
    }
    if (iosConstants[entry.key] != entry.value) {
      stderr.writeln('iOS mismatch for ${entry.key}: ${entry.value}');
      failed = true;
    }
  }

  if (androidConstants['viewType'] != dartViewType) {
    stderr.writeln('Android viewType mismatch');
    failed = true;
  }
  if (iosConstants['viewType'] != dartViewType) {
    stderr.writeln('iOS viewType mismatch');
    failed = true;
  }

  if (failed) {
    exit(1);
  }

  stdout.writeln('Channel contract check passed.');
}

Map<String, String> _readDartConstants(File file) {
  final text = file.readAsStringSync();
  return {
    'phoneEntryBase': _singleQuoteValue(text, 'phoneEntryBase'),
    'onPhoneSubmitted': _singleQuoteValue(text, 'onPhoneSubmitted'),
    'updateSubmissionStatus': _singleQuoteValue(text, 'updateSubmissionStatus'),
  };
}

String _readDartViewType(File file) {
  return _singleQuoteValue(file.readAsStringSync(), 'phoneEntry');
}

Map<String, String> _readKotlinConstants(File file) {
  final text = file.readAsStringSync();
  return {
    'phoneEntryBase': _doubleQuoteValue(text, 'PHONE_ENTRY_BASE'),
    'onPhoneSubmitted': _doubleQuoteValue(text, 'ON_PHONE_SUBMITTED'),
    'updateSubmissionStatus': _doubleQuoteValue(
      text,
      'UPDATE_SUBMISSION_STATUS',
    ),
    'viewType': _doubleQuoteValue(text, 'VIEW_TYPE'),
  };
}

Map<String, String> _readSwiftConstants(File file) {
  final text = file.readAsStringSync();
  return {
    'phoneEntryBase': _swiftStaticLet(text, 'phoneEntryBase'),
    'onPhoneSubmitted': _swiftStaticLet(text, 'onPhoneSubmitted'),
    'updateSubmissionStatus': _swiftStaticLet(text, 'updateSubmissionStatus'),
    'viewType': _swiftStaticLet(text, 'viewType'),
  };
}

String _singleQuoteValue(String text, String name) {
  final match = RegExp("$name = '([^']+)'").firstMatch(text);
  return match?.group(1) ?? '';
}

String _doubleQuoteValue(String text, String name) {
  final match = RegExp('const val $name = "([^"]+)"').firstMatch(text);
  return match?.group(1) ?? '';
}

String _swiftStaticLet(String text, String name) {
  final match = RegExp('static let $name = "([^"]+)"').firstMatch(text);
  return match?.group(1) ?? '';
}
