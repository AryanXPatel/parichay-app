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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppSectionHeader(
                title: l10n.settingsPrimaryTitle,
                subtitle: l10n.settingsPrimarySubtitle,
              ),
              const SizedBox(height: AppSpacing.xs),
              ListTile(
                leading: const Icon(AppIcons.account),
                title: Text(l10n.settingsAccountTitle),
                subtitle: Text(l10n.settingsAccountSubtitle),
                trailing: const Icon(AppIcons.chevronRight),
                onTap: () => Navigator.of(context).pushNamed(AppRoutes.profile),
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(AppIcons.lock),
                title: Text(l10n.settingsPrivacyTitle),
                subtitle: Text(l10n.settingsPrivacySubtitle),
                trailing: const Icon(AppIcons.chevronRight),
                onTap: () => Navigator.of(context).pushNamed(AppRoutes.privacy),
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(AppIcons.help),
                title: Text(l10n.settingsHelpTitle),
                subtitle: Text(l10n.settingsHelpSubtitle),
                trailing: const Icon(AppIcons.chevronRight),
                onTap: () =>
                    Navigator.of(context).pushNamed(AppRoutes.verification),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppSectionHeader(title: l10n.settingsExtrasTitle),
              const SizedBox(height: AppSpacing.xs),
              ListTile(
                leading: const Icon(AppIcons.card),
                title: Text(l10n.settingsPayoutTitle),
                subtitle: Text(l10n.settingsPayoutSubtitle),
                trailing: const Icon(AppIcons.chevronRight),
                onTap: () => Navigator.of(context).pushNamed(AppRoutes.payouts),
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(AppIcons.alertsActive),
                title: Text(l10n.tooltipNotifications),
                subtitle: Text(l10n.dashboardRecentSubtitle),
                trailing: const Icon(AppIcons.chevronRight),
                onTap: () =>
                    Navigator.of(context).pushNamed(AppRoutes.notifications),
              ),
            ],
          ),
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
