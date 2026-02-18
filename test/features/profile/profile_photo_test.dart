import 'package:parichay_candidate/features/profile/presentation/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parichay_candidate/l10n/app_localizations.dart';

void main() {
  testWidgets('profile supports mock photo attach and save', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [Locale('en'), Locale('hi')],
        home: Scaffold(body: ProfileScreen()),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('No photo selected'), findsOneWidget);
    await tester.tap(find.text('Add mock photo'));
    await tester.pumpAndSettle();
    expect(find.text('Photo attached'), findsOneWidget);

    await tester.tap(find.widgetWithText(FilledButton, 'Save profile'));
    await tester.pumpAndSettle();
    expect(find.widgetWithText(FilledButton, 'Save profile'), findsOneWidget);
  });
}
