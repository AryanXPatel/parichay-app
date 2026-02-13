import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:best_flutter_ui_templates/features/auth/presentation/sign_in_screen.dart';

void main() {
  testWidgets('sign-in screen renders primary fields', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: SignInScreen(),
      ),
    );

    expect(find.text('Welcome to Parichay'), findsOneWidget);
    expect(find.text('Phone or Email'), findsOneWidget);
    expect(find.text('Request OTP'), findsOneWidget);
  });
}
