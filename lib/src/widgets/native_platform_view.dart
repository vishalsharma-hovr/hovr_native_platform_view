import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

/// Cross-platform wrapper for embedding a registered native PlatformView.
class NativePlatformView extends StatelessWidget {
  const NativePlatformView({
    required this.viewType,
    this.creationParams = const {},
    this.onPlatformViewCreated,
    super.key,
  });

  final String viewType;
  final Map<String, dynamic> creationParams;
  final ValueChanged<int>? onPlatformViewCreated;

  static final Set<Factory<OneSequenceGestureRecognizer>> gestureRecognizers =
      <Factory<OneSequenceGestureRecognizer>>{
        Factory<PanGestureRecognizer>(PanGestureRecognizer.new),
        Factory<ScaleGestureRecognizer>(ScaleGestureRecognizer.new),
        Factory<TapGestureRecognizer>(TapGestureRecognizer.new),
      };

  @override
  Widget build(BuildContext context) {
    final params = Map<String, dynamic>.from(creationParams);
    final codec = const StandardMessageCodec();

    if (Platform.isAndroid) {
      return AndroidView(
        viewType: viewType,
        creationParams: params,
        creationParamsCodec: codec,
        gestureRecognizers: gestureRecognizers,
        hitTestBehavior: PlatformViewHitTestBehavior.opaque,
        onPlatformViewCreated: onPlatformViewCreated,
      );
    }

    return UiKitView(
      viewType: viewType,
      creationParams: params,
      creationParamsCodec: codec,
      gestureRecognizers: gestureRecognizers,
      hitTestBehavior: PlatformViewHitTestBehavior.opaque,
      onPlatformViewCreated: onPlatformViewCreated,
    );
  }
}
