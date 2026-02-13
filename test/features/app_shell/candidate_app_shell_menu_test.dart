import 'package:best_flutter_ui_templates/core/router/app_routes.dart';
import 'package:best_flutter_ui_templates/features/app_shell/presentation/candidate_app_shell.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('three-dot menu opens settings route', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: const CandidateAppShell(),
        routes: {
          AppRoutes.settings: (_) => const Scaffold(body: Text('Settings Route Target')),
          AppRoutes.notifications: (_) => const Scaffold(body: Text('Notifications Target')),
          AppRoutes.privacy: (_) => const Scaffold(body: Text('Privacy Target')),
          AppRoutes.verification: (_) => const Scaffold(body: Text('Verification Target')),
          AppRoutes.payouts: (_) => const Scaffold(body: Text('Payouts Target')),
        },
      ),
    );

    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('More actions'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();

    expect(find.text('Settings Route Target'), findsOneWidget);
  });
}
