import 'package:best_flutter_ui_templates/core/router/app_routes.dart';
import 'package:best_flutter_ui_templates/core/theme/app_colors.dart';
import 'package:best_flutter_ui_templates/core/theme/app_motion.dart';
import 'package:best_flutter_ui_templates/core/theme/app_spacing.dart';
import 'package:best_flutter_ui_templates/features/dashboard/presentation/dashboard_screen.dart';
import 'package:best_flutter_ui_templates/features/documents/presentation/documents_screen.dart';
import 'package:best_flutter_ui_templates/features/profile/presentation/profile_screen.dart';
import 'package:best_flutter_ui_templates/features/settings/presentation/settings_screen.dart';
import 'package:best_flutter_ui_templates/features/wallet/presentation/wallet_screen.dart';
import 'package:flutter/material.dart';
import 'package:best_flutter_ui_templates/l10n/app_localizations.dart';

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
            icon: const Icon(Icons.notifications_none_rounded),
            tooltip: l10n.tooltipNotifications,
          ),
          PopupMenuButton<String>(
            tooltip: l10n.tooltipMoreActions,
            onSelected: (value) {
              switch (value) {
                case 'verification':
                  Navigator.of(context).pushNamed(AppRoutes.verification);
                  break;
                case 'payouts':
                  Navigator.of(context).pushNamed(AppRoutes.payouts);
                  break;
                case 'privacy':
                  Navigator.of(context).pushNamed(AppRoutes.privacy);
                  break;
              }
            },
            itemBuilder: (_) => [
              PopupMenuItem(
                value: 'verification',
                child: Text(l10n.menuVerification),
              ),
              PopupMenuItem(value: 'payouts', child: Text(l10n.menuPayouts)),
              PopupMenuItem(value: 'privacy', child: Text(l10n.menuPrivacy)),
            ],
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
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(
              Icons.dashboard_rounded,
              color: AppColors.brand700,
            ),
            label: l10n.tabHome,
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(Icons.person_rounded, color: AppColors.brand700),
            label: l10n.tabProfile,
          ),
          NavigationDestination(
            icon: Icon(Icons.folder_open_outlined),
            selectedIcon: Icon(Icons.folder_open, color: AppColors.brand700),
            label: l10n.tabDocuments,
          ),
          NavigationDestination(
            icon: Icon(Icons.account_balance_wallet_outlined),
            selectedIcon: Icon(
              Icons.account_balance_wallet_rounded,
              color: AppColors.brand700,
            ),
            label: l10n.tabWallet,
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(
              Icons.settings_rounded,
              color: AppColors.brand700,
            ),
            label: l10n.tabSettings,
          ),
        ],
      ),
    );
  }
}
