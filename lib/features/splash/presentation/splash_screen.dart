import 'dart:async';

import 'package:parichay_candidate/core/router/app_routes.dart';
import 'package:parichay_candidate/core/services/app_services.dart';
import 'package:parichay_candidate/core/theme/app_colors.dart';
import 'package:parichay_candidate/core/theme/app_gradients.dart';
import 'package:parichay_candidate/core/ui/app_icons.dart';
import 'package:flutter/material.dart';
import 'package:parichay_candidate/l10n/app_localizations.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    unawaited(_bootstrap());
  }

  Future<void> _bootstrap() async {
    await Future<void>.delayed(const Duration(milliseconds: 1200));
    final preferredLocale = await AppServices.instance.appSessionStore
        .getPreferredLocale();
    final isSignedIn = await AppServices.instance.authRepository.isSignedIn();
    final hasSeenWelcome = await AppServices.instance.appSessionStore
        .getHasSeenWelcome();
    if (!mounted) {
      return;
    }
    if (preferredLocale == null) {
      Navigator.of(context).pushReplacementNamed(AppRoutes.languageSelection);
      return;
    }
    if (!isSignedIn) {
      Navigator.of(context).pushReplacementNamed(AppRoutes.signIn);
      return;
    }
    Navigator.of(context).pushReplacementNamed(
      hasSeenWelcome ? AppRoutes.appShell : AppRoutes.welcome,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(gradient: AppGradients.spotlight),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: const Icon(
                  AppIcons.brand,
                  color: AppColors.brand700,
                  size: 38,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                l10n?.brandName ?? 'Parichay',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.textPrimary,
                  fontSize: 28,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                l10n?.brandTagline ?? 'Real Jobs. Real People.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 28),
              const CircularProgressIndicator(color: AppColors.brand700),
            ],
          ),
        ),
      ),
    );
  }
}
