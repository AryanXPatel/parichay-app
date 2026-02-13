import 'package:best_flutter_ui_templates/core/router/app_routes.dart';
import 'package:best_flutter_ui_templates/features/app_shell/presentation/candidate_app_shell.dart';
import 'package:best_flutter_ui_templates/features/auth/presentation/sign_in_screen.dart';
import 'package:best_flutter_ui_templates/features/notifications/presentation/notifications_screen.dart';
import 'package:best_flutter_ui_templates/features/payouts/presentation/payouts_screen.dart';
import 'package:best_flutter_ui_templates/features/privacy/presentation/privacy_controls_screen.dart';
import 'package:best_flutter_ui_templates/features/profile/presentation/profile_screen.dart';
import 'package:best_flutter_ui_templates/features/settings/presentation/settings_screen.dart';
import 'package:best_flutter_ui_templates/features/splash/presentation/splash_screen.dart';
import 'package:best_flutter_ui_templates/features/verification/presentation/verification_center_screen.dart';
import 'package:flutter/material.dart';

class AppRouter {
  const AppRouter._();

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return MaterialPageRoute<void>(builder: (_) => const SplashScreen());
      case AppRoutes.signIn:
        return MaterialPageRoute<void>(builder: (_) => const SignInScreen());
      case AppRoutes.appShell:
        return MaterialPageRoute<void>(builder: (_) => const CandidateAppShell());
      case AppRoutes.profile:
        return MaterialPageRoute<void>(
          builder: (_) => Scaffold(
            appBar: AppBar(title: const Text('Profile')),
            body: const ProfileScreen(),
          ),
        );
      case AppRoutes.notifications:
        return MaterialPageRoute<void>(builder: (_) => const NotificationsScreen());
      case AppRoutes.privacy:
        return MaterialPageRoute<void>(builder: (_) => const PrivacyControlsScreen());
      case AppRoutes.settings:
        return MaterialPageRoute<void>(builder: (_) => const SettingsScreen());
      case AppRoutes.verification:
        return MaterialPageRoute<void>(builder: (_) => const VerificationCenterScreen());
      case AppRoutes.payouts:
        return MaterialPageRoute<void>(builder: (_) => const PayoutsScreen());
      default:
        return MaterialPageRoute<void>(builder: (_) => const SplashScreen());
    }
  }
}
