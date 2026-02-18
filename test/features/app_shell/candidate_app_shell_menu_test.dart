import 'package:parichay_candidate/core/router/app_routes.dart';
import 'package:parichay_candidate/features/app_shell/presentation/candidate_app_shell.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parichay_candidate/l10n/app_localizations.dart';

void main() {
  testWidgets('three-dot menu opens privacy route', (
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
          AppRoutes.settings: (_) =>
              const Scaffold(body: Text('Settings Route Target')),
          AppRoutes.notifications: (_) =>
              const Scaffold(body: Text('Notifications Target')),
          AppRoutes.privacy: (_) =>
              const Scaffold(body: Text('Privacy Target')),
          AppRoutes.verification: (_) =>
              const Scaffold(body: Text('Verification Target')),
          AppRoutes.payouts: (_) =>
              const Scaffold(body: Text('Payouts Target')),
        },
      ),
    );

    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('More actions'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Privacy controls'));
    await tester.pumpAndSettle();

    expect(find.text('Privacy Target'), findsOneWidget);
  });
}
