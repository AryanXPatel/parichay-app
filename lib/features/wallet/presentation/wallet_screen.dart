import 'package:best_flutter_ui_templates/core/models/domain_models.dart';
import 'package:best_flutter_ui_templates/core/router/app_routes.dart';
import 'package:best_flutter_ui_templates/core/services/app_services.dart';
import 'package:best_flutter_ui_templates/core/theme/app_spacing.dart';
import 'package:best_flutter_ui_templates/core/theme/app_theme_extensions.dart';
import 'package:best_flutter_ui_templates/core/ui/app_ui.dart';
import 'package:flutter/material.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  late Future<_WalletData> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<_WalletData> _load() async {
    final services = AppServices.instance;
    final balance = await services.walletRepository.getBalance();
    final ledger = await services.walletRepository.getLedger();
    return _WalletData(balance: balance, ledger: ledger);
  }

  Future<void> _reload() async {
    setState(() {
      _future = _load();
    });
    await _future;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<_WalletData>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const AppPageLoader();
        }
        if (snapshot.hasError) {
          return AppEmptyState(
            title: 'Unable to load wallet',
            message: 'Please refresh and try again.',
            icon: Icons.account_balance_wallet_outlined,
            actionLabel: 'Refresh',
            onAction: _reload,
          );
        }

        final data = snapshot.data;
        if (data == null) {
          return AppEmptyState(
            title: 'Unable to load wallet',
            message: 'Please refresh and try again.',
            icon: Icons.account_balance_wallet_outlined,
            actionLabel: 'Refresh',
            onAction: _reload,
          );
        }

        return RefreshIndicator(
          onRefresh: _reload,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(AppSpacing.md),
            children: [
              AppCard(
                gradient: context.surfaceStyles.walletGradient,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Wallet balance',
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: Colors.white70),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      '${data.balance.toStringAsFixed(0)} credits',
                      style: Theme.of(
                        context,
                      ).textTheme.displaySmall?.copyWith(color: Colors.white),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'Credits are earned via profile downloads and verified profile quality.',
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: Colors.white70),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    OutlinedButton.icon(
                      onPressed: () =>
                          Navigator.of(context).pushNamed(AppRoutes.payouts),
                      icon: const Icon(Icons.account_balance_outlined),
                      label: const Text('Request payout'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const AppSectionHeader(
                      title: 'Ledger',
                      subtitle: 'Credit inflow and payout deductions',
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    if (data.ledger.isEmpty)
                      const AppEmptyState(
                        title: 'No transactions yet',
                        message: 'You will see credits and deductions here.',
                        icon: Icons.receipt_long_outlined,
                      )
                    else
                      ...data.ledger.map((entry) {
                        final tone = entry.isCredit
                            ? AppStatusTone.success
                            : AppStatusTone.warning;
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Icon(
                            entry.isCredit
                                ? Icons.call_received_rounded
                                : Icons.call_made_rounded,
                          ),
                          title: Text(entry.title),
                          subtitle: Text(_dateLabel(entry.createdAt)),
                          trailing: AppStatusChip(
                            label:
                                '${entry.isCredit ? '+' : '-'}${entry.amount.toStringAsFixed(0)}',
                            tone: tone,
                          ),
                        );
                      }),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _dateLabel(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '$day-$month-${date.year}';
  }
}

class _WalletData {
  const _WalletData({required this.balance, required this.ledger});

  final double balance;
  final List<WalletLedgerEntry> ledger;
}
