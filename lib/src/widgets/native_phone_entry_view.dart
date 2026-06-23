import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants/view_types.dart';
import '../models/phone_entry_result.dart';
import '../models/phone_submission.dart';
import '../platform/phone_entry_channel.dart';
import 'native_platform_view.dart';

/// Controller to send results back to the native phone entry view.
class PhoneEntryController {
  int? _viewId;

  int? get viewId => _viewId;

  bool get isAttached => _viewId != null;

  void attach(int viewId) {
    _viewId = viewId;
  }

  void detach() {
    _viewId = null;
  }

  Future<void> notifyResult(PhoneEntryResult result) {
    final id = _viewId;
    if (id == null) {
      return Future<void>.value();
    }
    return notifyPhoneEntryResult(id, result);
  }
}

/// Embeds the native phone-entry PlatformView and forwards submission events.
class NativePhoneEntryView extends StatefulWidget {
  const NativePhoneEntryView({
    required this.onSubmitted,
    this.controller,
    this.onValidationError,
    super.key,
  });

  final ValueChanged<PhoneSubmission> onSubmitted;
  final PhoneEntryController? controller;
  final ValueChanged<String>? onValidationError;

  @override
  State<NativePhoneEntryView> createState() => _NativePhoneEntryViewState();
}

class _NativePhoneEntryViewState extends State<NativePhoneEntryView> {
  PhoneEntryChannel? _channel;

  @override
  void dispose() {
    _channel?.setHandler(null);
    widget.controller?.detach();
    super.dispose();
  }

  Future<dynamic> _onNativeCall(MethodCall call) async {
    final submission = PhoneEntryChannel.parseSubmission(call);
    if (submission != null) {
      widget.onSubmitted(submission);
      return null;
    }

    return null;
  }

  void _onPlatformViewCreated(int viewId) {
    _channel?.setHandler(null);
    _channel = PhoneEntryChannel(viewId)..setHandler(_onNativeCall);
    widget.controller?.attach(viewId);
  }

  @override
  Widget build(BuildContext context) {
    return NativePlatformView(
      key: const ValueKey(ViewTypes.phoneEntry),
      viewType: ViewTypes.phoneEntry,
      creationParams: const {'id': ViewCreationParams.defaultId},
      onPlatformViewCreated: _onPlatformViewCreated,
    );
  }
}
