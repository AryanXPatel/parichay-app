import 'package:parichay_candidate/core/router/app_routes.dart';
import 'package:parichay_candidate/core/services/app_services.dart';
import 'package:parichay_candidate/core/theme/app_spacing.dart';
import 'package:parichay_candidate/core/ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:parichay_candidate/l10n/app_localizations.dart';

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
    final l10n = AppLocalizations.of(context)!;
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        AppCard(
          tone: AppCardTone.muted,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.settingsPrimaryTitle,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                l10n.settingsPrimarySubtitle,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        _SettingsGroup(
          title: l10n.settingsPrimaryTitle,
          actions: [
            _SettingsAction(
              icon: AppIcons.account,
              title: l10n.settingsAccountTitle,
              subtitle: l10n.settingsAccountSubtitle,
              onTap: () => Navigator.of(context).pushNamed(AppRoutes.profile),
            ),
            _SettingsAction(
              icon: AppIcons.lock,
              title: l10n.settingsPrivacyTitle,
              subtitle: l10n.settingsPrivacySubtitle,
              onTap: () => Navigator.of(context).pushNamed(AppRoutes.privacy),
            ),
            _SettingsAction(
              icon: AppIcons.help,
              title: l10n.settingsHelpTitle,
              subtitle: l10n.settingsHelpSubtitle,
              onTap: () =>
                  Navigator.of(context).pushNamed(AppRoutes.verification),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        _SettingsGroup(
          title: l10n.settingsExtrasTitle,
          actions: [
            _SettingsAction(
              icon: AppIcons.card,
              title: l10n.settingsPayoutTitle,
              subtitle: l10n.settingsPayoutSubtitle,
              onTap: () => Navigator.of(context).pushNamed(AppRoutes.payouts),
            ),
            _SettingsAction(
              icon: AppIcons.alertsActive,
              title: l10n.tooltipNotifications,
              subtitle: l10n.dashboardRecentSubtitle,
              onTap: () =>
                  Navigator.of(context).pushNamed(AppRoutes.notifications),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        AppPrimaryButton(
          label: l10n.settingsSignOut,
          icon: AppIcons.signOut,
          onPressed: () => _signOut(context),
        ),
      ],
    );
  }
}

class _SettingsGroup extends StatelessWidget {
  const _SettingsGroup({required this.title, required this.actions});

  final String title;
  final List<_SettingsAction> actions;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      tone: AppCardTone.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: AppSpacing.xs),
          for (var i = 0; i < actions.length; i++) ...[
            if (i > 0) const Divider(height: AppSpacing.lg),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(actions[i].icon),
              title: Text(actions[i].title),
              subtitle: Text(actions[i].subtitle),
              trailing: const Icon(AppIcons.chevronRight),
              onTap: actions[i].onTap,
            ),
          ],
        ],
      ),
    );
  }
}

class _SettingsAction {
  const _SettingsAction({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
}
