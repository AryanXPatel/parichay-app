import 'package:best_flutter_ui_templates/core/router/app_routes.dart';
import 'package:best_flutter_ui_templates/core/theme/app_colors.dart';
import 'package:best_flutter_ui_templates/core/theme/app_motion.dart';
import 'package:best_flutter_ui_templates/core/theme/app_spacing.dart';
import 'package:best_flutter_ui_templates/features/dashboard/presentation/dashboard_screen.dart';
import 'package:best_flutter_ui_templates/features/documents/presentation/documents_screen.dart';
import 'package:best_flutter_ui_templates/features/profile/presentation/profile_screen.dart';
import 'package:best_flutter_ui_templates/features/wallet/presentation/wallet_screen.dart';
import 'package:flutter/material.dart';

class CandidateAppShell extends StatefulWidget {
  const CandidateAppShell({super.key});

  @override
  State<CandidateAppShell> createState() => _CandidateAppShellState();
}

class _CandidateAppShellState extends State<CandidateAppShell> {
  int _index = 0;

  static const _titles = ['Dashboard', 'Documents', 'Wallet', 'Profile'];

  static final _screens = [
    const DashboardScreen(),
    const DocumentsScreen(),
    const WalletScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_index]),
        actions: [
          IconButton(
            onPressed: () =>
                Navigator.of(context).pushNamed(AppRoutes.notifications),
            icon: const Icon(Icons.notifications_none_rounded),
            tooltip: 'Notifications',
          ),
          PopupMenuButton<String>(
            tooltip: 'More actions',
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
                case 'settings':
                  Navigator.of(context).pushNamed(AppRoutes.settings);
                  break;
              }
            },
            itemBuilder: (_) => const [
              PopupMenuItem(
                value: 'verification',
                child: Text('Verification center'),
              ),
              PopupMenuItem(value: 'payouts', child: Text('Payouts')),
              PopupMenuItem(value: 'privacy', child: Text('Privacy controls')),
              PopupMenuItem(value: 'settings', child: Text('Settings')),
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
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(
              Icons.dashboard_rounded,
              color: AppColors.brand700,
            ),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.folder_open_outlined),
            selectedIcon: Icon(Icons.folder_open, color: AppColors.brand700),
            label: 'Documents',
          ),
          NavigationDestination(
            icon: Icon(Icons.account_balance_wallet_outlined),
            selectedIcon: Icon(
              Icons.account_balance_wallet_rounded,
              color: AppColors.brand700,
            ),
            label: 'Wallet',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(Icons.person_rounded, color: AppColors.brand700),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
