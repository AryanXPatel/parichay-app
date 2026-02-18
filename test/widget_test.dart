import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parichay_candidate/l10n/app_localizations.dart';

import 'package:parichay_candidate/features/auth/presentation/sign_in_screen.dart';

void main() {
  testWidgets('sign-in screen renders primary fields', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [Locale('en'), Locale('hi')],
        home: SignInScreen(),
      ),
    );

    expect(find.text('Welcome to Parichay'), findsOneWidget);
    expect(find.text('Phone or Email'), findsOneWidget);
    expect(find.text('Request OTP'), findsOneWidget);
  });
}
