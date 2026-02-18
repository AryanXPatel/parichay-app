import 'package:parichay_candidate/features/app_shell/presentation/candidate_app_shell.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parichay_candidate/l10n/app_localizations.dart';

void main() {
  testWidgets('candidate app shell shows five primary tabs in order', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('en'), Locale('hi')],
        home: const CandidateAppShell(),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Home'), findsWidgets);
    expect(find.text('Profile'), findsWidgets);
    expect(find.text('Documents'), findsWidgets);
    expect(find.text('Wallet'), findsWidgets);
    expect(find.text('Settings'), findsWidgets);
  });
}
