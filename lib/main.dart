import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:parichay_candidate/core/router/app_router.dart';
import 'package:parichay_candidate/core/router/app_routes.dart';
import 'package:parichay_candidate/core/services/app_services.dart';
import 'package:parichay_candidate/core/theme/parichay_theme.dart';
import 'package:parichay_candidate/l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(const ParichayApp());
}

class ParichayApp extends StatefulWidget {
  const ParichayApp({super.key});

  @override
  State<ParichayApp> createState() => _ParichayAppState();
}

class _ParichayAppState extends State<ParichayApp> {
  Locale? _locale;
  final _services = AppServices.instance;

  @override
  void initState() {
    super.initState();
    _services.localeNotifier.addListener(_handleLocaleChanged);
    _services.loadInitialLocale();
  }

  void _handleLocaleChanged() {
    if (!mounted) {
      return;
    }
    setState(() {
      _locale = _services.localeNotifier.value;
    });
  }

  @override
  void dispose() {
    _services.localeNotifier.removeListener(_handleLocaleChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateTitle: (context) =>
          AppLocalizations.of(context)?.appTitle ?? 'Parichay Candidate',
      debugShowCheckedModeBanner: false,
      theme: ParichayTheme.lightTheme,
      locale: _locale,
      supportedLocales: const [Locale('en'), Locale('hi')],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      initialRoute: AppRoutes.splash,
      onGenerateRoute: AppRouter.onGenerateRoute,
    );
  }
}

/// Backward-compatible color helper used by existing template modules.
class HexColor extends Color {
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));

  static int _getColorFromHex(String hexColor) {
    var value = hexColor.toUpperCase().replaceAll('#', '');
    if (value.length == 6) {
      value = 'FF$value';
    }
    return int.parse(value, radix: 16);
  }
}
