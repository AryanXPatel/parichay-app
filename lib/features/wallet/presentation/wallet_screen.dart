import 'package:parichay_candidate/core/models/domain_models.dart';
import 'package:parichay_candidate/core/router/app_routes.dart';
import 'package:parichay_candidate/core/services/app_services.dart';
import 'package:parichay_candidate/core/theme/app_colors.dart';
import 'package:parichay_candidate/core/theme/app_spacing.dart';
import 'package:parichay_candidate/core/theme/app_theme_extensions.dart';
import 'package:parichay_candidate/core/ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:parichay_candidate/l10n/app_localizations.dart';

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
    final l10n = AppLocalizations.of(context)!;

    return FutureBuilder<_WalletData>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const AppPageLoader();
        }
        if (snapshot.hasError) {
          return AppEmptyState(
            title: l10n.walletLoadErrorTitle,
            message: l10n.walletLoadErrorMessage,
            icon: AppIcons.wallet,
            actionLabel: l10n.commonRefresh,
            onAction: _reload,
          );
        }

        final data = snapshot.data;
        if (data == null) {
          return AppEmptyState(
            title: l10n.walletLoadErrorTitle,
            message: l10n.walletLoadErrorMessage,
            icon: AppIcons.wallet,
            actionLabel: l10n.commonRefresh,
            onAction: _reload,
          );
        }

        final totalInflow = data.ledger
            .where((entry) => entry.isCredit)
            .fold<double>(0, (sum, entry) => sum + entry.amount);
        final totalOutflow = data.ledger
            .where((entry) => !entry.isCredit)
            .fold<double>(0, (sum, entry) => sum + entry.amount);
        final net = totalInflow - totalOutflow;

        return RefreshIndicator(
          onRefresh: _reload,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(AppSpacing.md),
            children: [
              AppCard(
                tone: AppCardTone.elevated,
                gradient: context.surfaceStyles.walletGradient,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.walletBalanceLabel,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.brand100,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      l10n.walletBalanceCredits(
                        data.balance.toStringAsFixed(0),
                      ),
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        color: AppColors.textOnBrand,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      l10n.walletBalanceDescription,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.brand100,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Wrap(
                      spacing: AppSpacing.xs,
                      runSpacing: AppSpacing.xs,
                      children: [
                        AppStatusChip(
                          label: 'Inflow +${totalInflow.toStringAsFixed(0)}',
                          tone: AppStatusTone.success,
                        ),
                        AppStatusChip(
                          label: 'Outflow -${totalOutflow.toStringAsFixed(0)}',
                          tone: AppStatusTone.warning,
                        ),
                        AppStatusChip(
                          label:
                              '${net >= 0 ? 'Net +' : 'Net -'}${net.abs().toStringAsFixed(0)}',
                          tone: net >= 0
                              ? AppStatusTone.info
                              : AppStatusTone.danger,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    AppPrimaryButton(
                      label: l10n.walletRequestPayout,
                      icon: AppIcons.bank,
                      onPressed: () =>
                          Navigator.of(context).pushNamed(AppRoutes.payouts),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              AppCard(
                tone: AppCardTone.muted,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppSectionHeader(
                      title: l10n.walletLedgerTitle,
                      subtitle: l10n.walletLedgerSubtitle,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    if (data.ledger.isEmpty)
                      AppEmptyState(
                        title: l10n.walletLedgerEmptyTitle,
                        message: l10n.walletLedgerEmptyMessage,
                        icon: AppIcons.receipt,
                      )
                    else
                      ...data.ledger.asMap().entries.map((item) {
                        final entry = item.value;
                        return Column(
                          children: [
                            _LedgerRow(
                              entry: entry,
                              dateLabel: _dateLabel(entry.createdAt),
                            ),
                            if (item.key != data.ledger.length - 1)
                              const Divider(height: AppSpacing.lg),
                          ],
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

class _LedgerRow extends StatelessWidget {
  const _LedgerRow({required this.entry, required this.dateLabel});

  final WalletLedgerEntry entry;
  final String dateLabel;

  @override
  Widget build(BuildContext context) {
    final statusTone = entry.isCredit
        ? AppStatusTone.success
        : AppStatusTone.warning;
    final valueColor = entry.isCredit ? AppColors.success : AppColors.warning;

    return Row(
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: entry.isCredit
                ? AppColors.successSubtle
                : AppColors.warningSubtle,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            entry.isCredit ? AppIcons.incoming : AppIcons.outgoing,
            size: 18,
            color: valueColor,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(entry.title, style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 2),
              Text(dateLabel, style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ),
        AppStatusChip(
          label:
              '${entry.isCredit ? '+' : '-'}${entry.amount.toStringAsFixed(0)}',
          tone: statusTone,
        ),
      ],
    );
  }
}
