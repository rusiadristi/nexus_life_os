import 'package:flutter_test/flutter_test.dart';
import 'package:nexus_life_os/main.dart';

void main() {
  testWidgets('NEXUS App Smoke Test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const NexusFutureApp());

    // Verify that NEXUS app loads properly
    expect(find.byType(NexusFutureApp), findsOneWidget);
  });
}
