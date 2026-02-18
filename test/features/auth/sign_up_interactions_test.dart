import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parichay_candidate/core/router/app_routes.dart';
import 'package:parichay_candidate/features/auth/presentation/sign_up_screen.dart';
import 'package:parichay_candidate/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets(
    'signup request button enables after required details and consent',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('en'), Locale('hi')],
          home: const SignUpScreen(),
        ),
      );

      await tester.pumpAndSettle();

      FilledButton createButton() => tester.widget<FilledButton>(
        find.widgetWithText(FilledButton, 'Create account'),
      );

      expect(createButton().onPressed, isNull);

      await tester.enterText(
        find.widgetWithText(TextField, 'Full name'),
        'Anvi Singh',
      );
      await tester.enterText(
        find.widgetWithText(TextField, 'Phone or Email'),
        '9876543210',
      );
      await tester.enterText(
        find.widgetWithText(TextField, 'Preferred role'),
        'QA Engineer',
      );
      await tester.pumpAndSettle();

      expect(createButton().onPressed, isNull);

      await tester.tap(find.byType(Checkbox));
      await tester.pumpAndSettle();

      expect(createButton().onPressed, isNotNull);

      await tester.tap(find.widgetWithText(FilledButton, 'Create account'));
      await tester.pumpAndSettle();

      expect(find.widgetWithText(FilledButton, 'Verify OTP'), findsOneWidget);
    },
  );

  testWidgets('signup verify OTP routes to welcome', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('en'), Locale('hi')],
        home: const SignUpScreen(),
        routes: {
          AppRoutes.welcome: (_) =>
              const Scaffold(body: Text('Welcome Route Target')),
        },
      ),
    );

    await tester.pumpAndSettle();

    await tester.enterText(
      find.widgetWithText(TextField, 'Full name'),
      'Anvi Singh',
    );
    await tester.enterText(
      find.widgetWithText(TextField, 'Phone or Email'),
      '9876543210',
    );
    await tester.enterText(
      find.widgetWithText(TextField, 'Preferred role'),
      'QA Engineer',
    );
    await tester.tap(find.byType(Checkbox));
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(FilledButton, 'Create account'));
    await tester.pumpAndSettle();

    await tester.enterText(find.widgetWithText(TextField, 'OTP'), '123456');
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.widgetWithText(FilledButton, 'Verify OTP'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Verify OTP'));
    await tester.pumpAndSettle();

    expect(find.text('Welcome Route Target'), findsOneWidget);
  });
}
