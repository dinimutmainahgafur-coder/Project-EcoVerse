import 'package:flutter_test/flutter_test.dart';

import 'package:ecoverse/main.dart';

void main() {
  testWidgets('App renders splash screen', (WidgetTester tester) async {
    await tester.pumpWidget(const EcoVerseApp());
    await tester.pumpAndSettle();
    expect(find.text('EcoVerse'), findsOneWidget);
  });
}
