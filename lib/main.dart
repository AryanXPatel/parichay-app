import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:best_flutter_ui_templates/core/router/app_router.dart';
import 'package:best_flutter_ui_templates/core/router/app_routes.dart';
import 'package:best_flutter_ui_templates/core/theme/parichay_theme.dart';

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

class ParichayApp extends StatelessWidget {
  const ParichayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Parichay Candidate',
      debugShowCheckedModeBanner: false,
      theme: ParichayTheme.lightTheme,
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
