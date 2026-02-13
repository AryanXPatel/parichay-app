import 'package:best_flutter_ui_templates/core/router/app_routes.dart';
import 'package:best_flutter_ui_templates/core/services/app_services.dart';
import 'package:best_flutter_ui_templates/core/theme/app_spacing.dart';
import 'package:best_flutter_ui_templates/core/ui/app_ui.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  Future<void> _signOut(BuildContext context) async {
    await AppServices.instance.authRepository.signOut();
    if (!context.mounted) {
      return;
    }
    Navigator.of(
      context,
    ).pushNamedAndRemoveUntil(AppRoutes.signIn, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          AppCard(
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.account_circle_outlined),
                  title: const Text('Account'),
                  subtitle: const Text('Manage personal details and identity.'),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () =>
                      Navigator.of(context).pushNamed(AppRoutes.profile),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: Icon(Icons.credit_score_outlined),
                  title: const Text('Payout methods'),
                  subtitle: const Text('Configure bank account / UPI details.'),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () =>
                      Navigator.of(context).pushNamed(AppRoutes.payouts),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.lock_outline_rounded),
                  title: const Text('Privacy controls'),
                  subtitle: const Text(
                    'Choose what recruiters can view in profile preview.',
                  ),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () =>
                      Navigator.of(context).pushNamed(AppRoutes.privacy),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: Icon(Icons.help_outline_rounded),
                  title: const Text('Help & support'),
                  subtitle: const Text(
                    'Raise verification and payout queries.',
                  ),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () =>
                      Navigator.of(context).pushNamed(AppRoutes.verification),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          AppPrimaryButton(
            label: 'Sign out',
            icon: Icons.logout_rounded,
            onPressed: () => _signOut(context),
          ),
        ],
      ),
    );
  }
}
