import 'package:flutter/services.dart';

import '../constants/channel_names.dart';
import '../models/phone_entry_result.dart';
import '../models/phone_submission.dart';

/// Per-view method channel for phone entry native ↔ Dart communication.
class PhoneEntryChannel {
  PhoneEntryChannel(this.viewId)
    : _channel = MethodChannel(ChannelNames.phoneEntry(viewId));

  final int viewId;
  final MethodChannel _channel;

  void setHandler(Future<dynamic> Function(MethodCall call)? handler) {
    _channel.setMethodCallHandler(handler);
  }

  Future<void> notifyResult(PhoneEntryResult result) {
    return _channel.invokeMethod(
      ChannelMethods.updateSubmissionStatus,
      result.toMap(),
    );
  }

  static PhoneSubmission? parseSubmission(MethodCall call) {
    if (call.method != ChannelMethods.onPhoneSubmitted) {
      return null;
    }
    if (call.arguments is! Map) {
      return null;
    }
    return PhoneSubmission.fromMap(
      Map<dynamic, dynamic>.from(call.arguments as Map),
    );
  }
}

/// Notifies the native view at [viewId] of submission result.
Future<void> notifyPhoneEntryResult(int viewId, PhoneEntryResult result) {
  return PhoneEntryChannel(viewId).notifyResult(result);
}
