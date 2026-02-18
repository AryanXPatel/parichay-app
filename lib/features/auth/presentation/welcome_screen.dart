import 'package:parichay_candidate/core/models/domain_models.dart';
import 'package:parichay_candidate/core/router/app_routes.dart';
import 'package:parichay_candidate/core/services/app_services.dart';
import 'package:parichay_candidate/core/theme/app_spacing.dart';
import 'package:parichay_candidate/core/ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:parichay_candidate/features/auth/presentation/auth_shell.dart';
import 'package:parichay_candidate/l10n/app_localizations.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  late Future<CandidateProfile> _futureProfile;

  @override
  void initState() {
    super.initState();
    _futureProfile = AppServices.instance.profileRepository.getProfile();
  }

  Future<void> _continueToApp() async {
    await AppServices.instance.appSessionStore.setHasSeenWelcome(true);
    if (!mounted) {
      return;
    }
    Navigator.of(context).pushReplacementNamed(AppRoutes.appShell);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AuthShell(
      maxWidth: 460,
      child: FutureBuilder<CandidateProfile>(
        future: _futureProfile,
        builder: (context, snapshot) {
          final name = snapshot.data?.firstName ?? l10n.brandName;
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppStatusChip(
                label: l10n.commonVerified,
                tone: AppStatusTone.success,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                l10n.welcomeHeading(name),
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                l10n.welcomeMessage,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: AppSpacing.md),
              AppPrimaryButton(
                label: l10n.welcomeContinue,
                icon: AppIcons.arrowRight,
                onPressed: _continueToApp,
              ),
              const SizedBox(height: AppSpacing.xs),
              TextButton.icon(
                onPressed: () =>
                    Navigator.of(context).pushNamed(AppRoutes.profile),
                icon: const Icon(AppIcons.profile),
                label: Text(l10n.welcomeProfile),
              ),
            ],
          );
        },
      ),
    );
  }
}
