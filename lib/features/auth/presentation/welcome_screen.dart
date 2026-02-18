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
  bool _continuing = false;

  @override
  void initState() {
    super.initState();
    _futureProfile = _loadProfile();
  }

  Future<CandidateProfile> _loadProfile() {
    return AppServices.instance.profileRepository.getProfile();
  }

  void _retryProfileLoad() {
    setState(() {
      _futureProfile = _loadProfile();
    });
  }

  Future<void> _continueToApp() async {
    if (_continuing) {
      return;
    }
    setState(() {
      _continuing = true;
    });
    await AppServices.instance.appSessionStore.setHasSeenWelcome(true);
    if (!mounted) {
      return;
    }
    setState(() {
      _continuing = false;
    });
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
          if (snapshot.connectionState != ConnectionState.done) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppStatusChip(
                  label: 'Preparing workspace',
                  tone: AppStatusTone.info,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  l10n.welcomeHeading(l10n.brandName),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Loading your profile context...',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: AppSpacing.md),
                const LinearProgressIndicator(minHeight: 6),
              ],
            );
          }

          if (snapshot.hasError) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppStatusChip(
                  label: 'Could not load profile details',
                  tone: AppStatusTone.warning,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  l10n.welcomeHeading(l10n.brandName),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Try again to continue with your personalized workspace.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: AppSpacing.md),
                OutlinedButton.icon(
                  onPressed: _retryProfileLoad,
                  icon: const Icon(AppIcons.arrowRight),
                  label: Text(l10n.commonRefresh),
                ),
              ],
            );
          }

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
                isLoading: _continuing,
                onPressed: _continuing ? null : _continueToApp,
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
