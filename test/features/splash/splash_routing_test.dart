import 'package:parichay_candidate/core/router/app_routes.dart';
import 'package:parichay_candidate/features/splash/presentation/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parichay_candidate/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  Future<void> pumpSplash(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('en'), Locale('hi')],
        home: const SplashScreen(),
        routes: {
          AppRoutes.languageSelection: (_) =>
              const Scaffold(body: Text('Language Route')),
          AppRoutes.signIn: (_) => const Scaffold(body: Text('SignIn Route')),
          AppRoutes.welcome: (_) => const Scaffold(body: Text('Welcome Route')),
          AppRoutes.appShell: (_) =>
              const Scaffold(body: Text('AppShell Route')),
        },
      ),
    );
    await tester.pump(const Duration(milliseconds: 1300));
    await tester.pumpAndSettle();
  }

  testWidgets('routes to language selection when locale is not set', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    await pumpSplash(tester);
    expect(find.text('Language Route'), findsOneWidget);
  });

  testWidgets('routes to sign-in when locale exists and user is signed out', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({
      'preferred_locale': 'en',
      'signed_in': false,
    });
    await pumpSplash(tester);
    expect(find.text('SignIn Route'), findsOneWidget);
  });

  testWidgets('routes to app shell when locale exists and user is signed in', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({
      'preferred_locale': 'hi',
      'signed_in': true,
      'has_seen_welcome': true,
    });
    await pumpSplash(tester);
    expect(find.text('AppShell Route'), findsOneWidget);
  });

  testWidgets('routes to welcome when signed in and welcome is pending', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({
      'preferred_locale': 'en',
      'signed_in': true,
      'has_seen_welcome': false,
    });
    await pumpSplash(tester);
    expect(find.text('Welcome Route'), findsOneWidget);
  });
}
