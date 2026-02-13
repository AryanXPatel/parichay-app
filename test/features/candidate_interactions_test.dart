import 'package:best_flutter_ui_templates/core/router/app_routes.dart';
import 'package:best_flutter_ui_templates/features/auth/presentation/sign_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
    'Sign-in button enables only after identifier and OTP rules are met',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const SignInScreen(),
          routes: {
            AppRoutes.appShell: (_) => const Scaffold(body: Text('App Shell')),
          },
        ),
      );

      await tester.pumpAndSettle();

      FilledButton requestButton() => tester.widget<FilledButton>(
        find.widgetWithText(FilledButton, 'Request OTP'),
      );

      expect(requestButton().onPressed, isNull);

      await tester.enterText(
        find.widgetWithText(TextField, 'Phone or Email'),
        '9876543210',
      );
      await tester.pumpAndSettle();
      expect(requestButton().onPressed, isNotNull);

      await tester.tap(find.widgetWithText(FilledButton, 'Request OTP'));
      await tester.pumpAndSettle();

      FilledButton verifyButton() => tester.widget<FilledButton>(
        find.widgetWithText(FilledButton, 'Verify OTP'),
      );

      expect(verifyButton().onPressed, isNull);

      await tester.enterText(find.widgetWithText(TextField, 'OTP'), '123');
      await tester.pumpAndSettle();
      expect(verifyButton().onPressed, isNull);

      await tester.enterText(find.widgetWithText(TextField, 'OTP'), '123456');
      await tester.pumpAndSettle();
      expect(verifyButton().onPressed, isNotNull);
    },
  );
}
