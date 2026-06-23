import 'package:flutter_test/flutter_test.dart';
import 'package:hovr_native_platform_view/hovr_native_platform_view.dart';
import 'package:integration_test/integration_test.dart';

import 'package:hovr_native_platform_view_example/main.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('phone entry demo renders', (WidgetTester tester) async {
    await tester.pumpWidget(const ExampleApp());
    await tester.pumpAndSettle();

    expect(find.text('Phone Entry Demo'), findsOneWidget);
    expect(find.byType(NativePhoneEntryView), findsOneWidget);
  });
}
