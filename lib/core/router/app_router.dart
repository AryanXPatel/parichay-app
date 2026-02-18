import 'package:parichay_candidate/core/router/app_routes.dart';
import 'package:parichay_candidate/features/app_shell/presentation/candidate_app_shell.dart';
import 'package:parichay_candidate/features/auth/presentation/language_selection_screen.dart';
import 'package:parichay_candidate/features/auth/presentation/sign_in_screen.dart';
import 'package:parichay_candidate/features/auth/presentation/sign_up_screen.dart';
import 'package:parichay_candidate/features/auth/presentation/welcome_screen.dart';
import 'package:parichay_candidate/features/notifications/presentation/notifications_screen.dart';
import 'package:parichay_candidate/features/payouts/presentation/payouts_screen.dart';
import 'package:parichay_candidate/features/privacy/presentation/privacy_controls_screen.dart';
import 'package:parichay_candidate/features/profile/presentation/profile_screen.dart';
import 'package:parichay_candidate/features/settings/presentation/settings_screen.dart';
import 'package:parichay_candidate/features/splash/presentation/splash_screen.dart';
import 'package:parichay_candidate/features/verification/presentation/verification_center_screen.dart';
import 'package:flutter/material.dart';
import 'package:parichay_candidate/l10n/app_localizations.dart';

class AppRouter {
  const AppRouter._();

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return MaterialPageRoute<void>(builder: (_) => const SplashScreen());
      case AppRoutes.languageSelection:
        return MaterialPageRoute<void>(
          builder: (_) => const LanguageSelectionScreen(),
        );
      case AppRoutes.signIn:
        return MaterialPageRoute<void>(builder: (_) => const SignInScreen());
      case AppRoutes.signUp:
        return MaterialPageRoute<void>(builder: (_) => const SignUpScreen());
      case AppRoutes.welcome:
        return MaterialPageRoute<void>(builder: (_) => const WelcomeScreen());
      case AppRoutes.appShell:
        return MaterialPageRoute<void>(
          builder: (_) => const CandidateAppShell(),
        );
      case AppRoutes.profile:
        return MaterialPageRoute<void>(
          builder: (context) => Scaffold(
            appBar: AppBar(
              title: Text(AppLocalizations.of(context)!.tabProfile),
            ),
            body: const ProfileScreen(),
          ),
        );
      case AppRoutes.notifications:
        return MaterialPageRoute<void>(
          builder: (_) => const NotificationsScreen(),
        );
      case AppRoutes.privacy:
        return MaterialPageRoute<void>(
          builder: (_) => const PrivacyControlsScreen(),
        );
      case AppRoutes.settings:
        return MaterialPageRoute<void>(
          builder: (context) => Scaffold(
            appBar: AppBar(
              title: Text(AppLocalizations.of(context)!.commonSettings),
            ),
            body: const SettingsScreen(),
          ),
        );
      case AppRoutes.verification:
        return MaterialPageRoute<void>(
          builder: (_) => const VerificationCenterScreen(),
        );
      case AppRoutes.payouts:
        return MaterialPageRoute<void>(builder: (_) => const PayoutsScreen());
      default:
        return MaterialPageRoute<void>(builder: (_) => const SplashScreen());
    }
  }
}
