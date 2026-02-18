import 'package:parichay_candidate/core/router/app_routes.dart';
import 'package:parichay_candidate/core/theme/app_colors.dart';
import 'package:parichay_candidate/core/theme/app_motion.dart';
import 'package:parichay_candidate/core/theme/app_spacing.dart';
import 'package:parichay_candidate/core/ui/app_icons.dart';
import 'package:parichay_candidate/features/dashboard/presentation/dashboard_screen.dart';
import 'package:parichay_candidate/features/documents/presentation/documents_screen.dart';
import 'package:parichay_candidate/features/profile/presentation/profile_screen.dart';
import 'package:parichay_candidate/features/settings/presentation/settings_screen.dart';
import 'package:parichay_candidate/features/wallet/presentation/wallet_screen.dart';
import 'package:flutter/material.dart';
import 'package:parichay_candidate/l10n/app_localizations.dart';

class CandidateAppShell extends StatefulWidget {
  const CandidateAppShell({super.key});

  @override
  State<CandidateAppShell> createState() => _CandidateAppShellState();
}

class _CandidateAppShellState extends State<CandidateAppShell> {
  int _index = 0;

  static final _screens = [
    const DashboardScreen(),
    const ProfileScreen(),
    const DocumentsScreen(),
    const WalletScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final titles = <String>[
      l10n.tabHome,
      l10n.tabProfile,
      l10n.tabDocuments,
      l10n.tabWallet,
      l10n.tabSettings,
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(titles[_index]),
        actions: [
          IconButton(
            onPressed: () =>
                Navigator.of(context).pushNamed(AppRoutes.notifications),
            icon: const Icon(AppIcons.alerts),
            tooltip: l10n.tooltipNotifications,
          ),
          const SizedBox(width: AppSpacing.xs),
        ],
      ),
      body: AnimatedSwitcher(
        duration: AppMotion.medium,
        switchInCurve: AppMotion.standardCurve,
        switchOutCurve: AppMotion.standardCurve,
        child: KeyedSubtree(
          key: ValueKey<int>(_index),
          child: IndexedStack(index: _index, children: _screens),
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (idx) => setState(() => _index = idx),
        destinations: [
          NavigationDestination(
            icon: Icon(AppIcons.home),
            selectedIcon: Icon(AppIcons.homeFilled, color: AppColors.brand700),
            label: l10n.tabHome,
          ),
          NavigationDestination(
            icon: Icon(AppIcons.profile),
            selectedIcon: Icon(
              AppIcons.profileFilled,
              color: AppColors.brand700,
            ),
            label: l10n.tabProfile,
          ),
          NavigationDestination(
            icon: Icon(AppIcons.documents),
            selectedIcon: Icon(
              AppIcons.documentsFilled,
              color: AppColors.brand700,
            ),
            label: l10n.tabDocuments,
          ),
          NavigationDestination(
            icon: Icon(AppIcons.wallet),
            selectedIcon: Icon(
              AppIcons.walletFilled,
              color: AppColors.brand700,
            ),
            label: l10n.tabWallet,
          ),
          NavigationDestination(
            icon: Icon(AppIcons.settings),
            selectedIcon: Icon(
              AppIcons.settingsFilled,
              color: AppColors.brand700,
            ),
            label: l10n.tabSettings,
          ),
        ],
      ),
    );
  }
}
