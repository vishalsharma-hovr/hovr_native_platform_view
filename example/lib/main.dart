import 'package:flutter/material.dart';
import 'package:hovr_native_platform_view/hovr_native_platform_view.dart';

void main() {
  runApp(const ExampleApp());
}

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HOVR Native Platform View',
      theme: ThemeData(colorSchemeSeed: const Color(0xFF4CAF50)),
      home: const PhoneEntryDemoPage(),
    );
  }
}

class PhoneEntryDemoPage extends StatefulWidget {
  const PhoneEntryDemoPage({super.key});

  @override
  State<PhoneEntryDemoPage> createState() => _PhoneEntryDemoPageState();
}

class _PhoneEntryDemoPageState extends State<PhoneEntryDemoPage> {
  final PhoneEntryController _controller = PhoneEntryController();
  String? _lastSubmission;

  Future<void> _onSubmitted(PhoneSubmission submission) async {
    setState(() => _lastSubmission = submission.e164);

    await Future<void>.delayed(const Duration(milliseconds: 600));

    if (!mounted) {
      return;
    }

    await _controller.notifyResult(PhoneEntryResult.success());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Phone Entry Demo')),
      body: Column(
        children: [
          if (_lastSubmission != null)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text('Last submission: $_lastSubmission'),
            ),
          Expanded(
            child: NativePhoneEntryView(
              controller: _controller,
              onSubmitted: _onSubmitted,
            ),
          ),
        ],
      ),
    );
  }
}
