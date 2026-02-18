import 'package:parichay_candidate/core/router/app_routes.dart';
import 'package:parichay_candidate/features/auth/presentation/sign_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parichay_candidate/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('successful OTP verification routes to welcome', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('en'), Locale('hi')],
        home: const SignInScreen(),
        routes: {
          AppRoutes.welcome: (_) =>
              const Scaffold(body: Text('Welcome Route Target')),
        },
      ),
    );

    await tester.pumpAndSettle();

    await tester.enterText(
      find.widgetWithText(TextField, 'Phone or Email'),
      '9876543210',
    );
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(FilledButton, 'Request OTP'));
    await tester.pumpAndSettle();

    await tester.enterText(find.widgetWithText(TextField, 'OTP'), '123456');
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(FilledButton, 'Verify OTP'));
    await tester.pumpAndSettle();

    expect(find.text('Welcome Route Target'), findsOneWidget);
  });
}
