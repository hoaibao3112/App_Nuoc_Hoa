import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_app/screens/login/login_screen.dart';

void main() {
  testWidgets('Login screen renders app branding', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: LoginScreen()));

    expect(find.text('Scentie'), findsOneWidget);
    expect(find.byType(TextField), findsNWidgets(2));
  });
}
