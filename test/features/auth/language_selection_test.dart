import 'package:best_flutter_ui_templates/core/router/app_routes.dart';
import 'package:best_flutter_ui_templates/features/auth/presentation/language_selection_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:best_flutter_ui_templates/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('continue enables after language selection', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('en'), Locale('hi')],
        home: const LanguageSelectionScreen(),
        routes: {AppRoutes.signIn: (_) => const Scaffold(body: Text('SignIn'))},
      ),
    );

    await tester.pumpAndSettle();

    final continueButton = find.widgetWithText(FilledButton, 'Continue');
    expect(continueButton, findsOneWidget);
    expect(tester.widget<FilledButton>(continueButton).onPressed, isNull);

    await tester.tap(find.text('English'));
    await tester.pumpAndSettle();

    expect(tester.widget<FilledButton>(continueButton).onPressed, isNotNull);

    await tester.tap(continueButton);
    await tester.pumpAndSettle();

    expect(find.text('SignIn'), findsOneWidget);
  });
}
