import 'package:best_flutter_ui_templates/core/models/domain_models.dart';
import 'package:best_flutter_ui_templates/core/router/app_routes.dart';
import 'package:best_flutter_ui_templates/core/services/app_services.dart';
import 'package:best_flutter_ui_templates/core/theme/app_gradients.dart';
import 'package:best_flutter_ui_templates/core/theme/app_spacing.dart';
import 'package:best_flutter_ui_templates/core/ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:best_flutter_ui_templates/l10n/app_localizations.dart';

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

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(gradient: AppGradients.spotlight),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 460),
                child: FutureBuilder<CandidateProfile>(
                  future: _futureProfile,
                  builder: (context, snapshot) {
                    final name = snapshot.data?.firstName ?? l10n.brandName;
                    return AppCard(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                            icon: Icons.arrow_forward_rounded,
                            onPressed: _continueToApp,
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          TextButton.icon(
                            onPressed: () => Navigator.of(
                              context,
                            ).pushNamed(AppRoutes.profile),
                            icon: const Icon(Icons.person_outline_rounded),
                            label: Text(l10n.welcomeProfile),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
