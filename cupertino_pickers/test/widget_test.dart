// Smoke test for the focus session demo app.

import 'package:flutter_test/flutter_test.dart';

import 'package:cupertino_pickers/main.dart';

void main() {
  testWidgets('Focus session app renders', (WidgetTester tester) async {
    await tester.pumpWidget(const FocusSessionApp());

    expect(find.text('Focus Session'), findsWidgets);
    expect(find.text('Session date'), findsOneWidget);
    expect(find.text('Session length'), findsOneWidget);
    expect(find.text('Schedule Focus Session'), findsOneWidget);
  });
}
