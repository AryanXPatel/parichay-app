import 'package:parichay_candidate/core/router/app_routes.dart';
import 'package:parichay_candidate/features/app_shell/presentation/candidate_app_shell.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parichay_candidate/l10n/app_localizations.dart';

void main() {
  testWidgets('notification action opens notifications route', (
    WidgetTester tester,
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
        routes: {
          AppRoutes.notifications: (_) =>
              const Scaffold(body: Text('Notifications Target')),
        },
      ),
    );

    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Notifications'));
    await tester.pumpAndSettle();

    expect(find.text('Notifications Target'), findsOneWidget);
  });
}
