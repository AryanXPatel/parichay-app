import 'package:parichay_candidate/core/models/domain_models.dart';
import 'package:parichay_candidate/core/services/app_services.dart';
import 'package:parichay_candidate/core/theme/app_colors.dart';
import 'package:parichay_candidate/core/theme/app_spacing.dart';
import 'package:parichay_candidate/core/theme/app_theme_extensions.dart';
import 'package:parichay_candidate/core/ui/app_ui.dart';
import 'package:flutter/material.dart';

class PayoutsScreen extends StatefulWidget {
  const PayoutsScreen({super.key});

  @override
  State<PayoutsScreen> createState() => _PayoutsScreenState();
}

class _PayoutsScreenState extends State<PayoutsScreen> {
  final _amountController = TextEditingController();
  final _accountController = TextEditingController(text: 'anvi@upi');
  String _channel = 'UPI';
  bool _submitting = false;
  String? _message;

  late Future<_PayoutViewData> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
    _amountController.addListener(_clearTransientMessage);
    _accountController.addListener(_clearTransientMessage);
  }

  @override
  void dispose() {
    _amountController.removeListener(_clearTransientMessage);
    _accountController.removeListener(_clearTransientMessage);
    _amountController.dispose();
    _accountController.dispose();
    super.dispose();
  }

  void _clearTransientMessage() {
    if (_message == null) {
      return;
    }
    setState(() {
      _message = null;
    });
  }

  Future<_PayoutViewData> _load() async {
    final services = AppServices.instance;
    final balance = await services.walletRepository.getBalance();
    final requests = await services.walletRepository.listPayoutRequests();
    return _PayoutViewData(balance: balance, requests: requests);
  }

  Future<void> _refresh() async {
    setState(() {
      _future = _load();
    });
    await _future;
  }

  String? _validateInput(double availableBalance) {
    final amount = double.tryParse(_amountController.text.trim());
    if (amount == null || amount <= 0) {
      return 'Enter a payout amount greater than 0.';
    }
    if (amount > availableBalance) {
      return 'Payout amount exceeds available credits.';
    }
    if (_accountController.text.trim().isEmpty) {
      return _channel == 'UPI'
          ? 'Enter a valid UPI ID.'
          : 'Enter bank account reference.';
    }
    return null;
  }

  Future<void> _requestPayout(double availableBalance) async {
    final validationError = _validateInput(availableBalance);
    if (validationError != null) {
      setState(() {
        _message = validationError;
      });
      return;
    }

    final amount = double.tryParse(_amountController.text.trim()) ?? 0;
    setState(() {
      _submitting = true;
      _message = null;
    });

    final ok = await AppServices.instance.walletRepository.requestPayout(
      amount: amount,
      channel: _channel,
      accountRef: _accountController.text.trim(),
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _submitting = false;
      _message = ok
          ? 'Payout request submitted successfully.'
          : 'Unable to request payout. Check amount/balance/details.';
    });
    if (ok) {
      _amountController.clear();
      await _refresh();
    }
  }

  bool get _messageIsSuccess =>
      _message != null && _message!.startsWith('Payout request');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Payouts')),
      body: FutureBuilder<_PayoutViewData>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const AppPageLoader();
          }
          if (snapshot.hasError) {
            return AppEmptyState(
              title: 'Unable to load payouts',
              message: 'Please refresh and try again.',
              icon: AppIcons.bank,
              actionLabel: 'Refresh',
              onAction: _refresh,
            );
          }

          final data = snapshot.data;
          if (data == null) {
            return AppEmptyState(
              title: 'Unable to load payouts',
              message: 'Please refresh and try again.',
              icon: AppIcons.bank,
              actionLabel: 'Refresh',
              onAction: _refresh,
            );
          }

          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: const EdgeInsets.all(AppSpacing.md),
              children: [
                AppCard(
                  tone: AppCardTone.muted,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const AppSectionHeader(
                        title: 'Request payout',
                        subtitle:
                            'Redeem wallet credits to cash transfer through UPI or bank account.',
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      AppStatusChip(
                        label:
                            'Available: ${data.balance.toStringAsFixed(0)} credits',
                        tone: AppStatusTone.info,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      SegmentedButton<String>(
                        showSelectedIcon: false,
                        segments: const [
                          ButtonSegment<String>(
                            value: 'UPI',
                            icon: Icon(AppIcons.wallet),
                            label: Text('UPI'),
                          ),
                          ButtonSegment<String>(
                            value: 'Bank Transfer',
                            icon: Icon(AppIcons.bank),
                            label: Text('Bank transfer'),
                          ),
                        ],
                        selected: {_channel},
                        onSelectionChanged: (values) {
                          if (values.isEmpty) {
                            return;
                          }
                          setState(() {
                            _channel = values.first;
                            _message = null;
                          });
                        },
                      ),
                      const SizedBox(height: AppSpacing.md),
                      TextField(
                        controller: _amountController,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          labelText: 'Amount (credits)',
                          hintText: 'Enter payout amount',
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      TextField(
                        controller: _accountController,
                        textInputAction: TextInputAction.done,
                        onChanged: (_) => _clearTransientMessage(),
                        decoration: InputDecoration(
                          labelText: _channel == 'UPI'
                              ? 'UPI ID'
                              : 'Bank account reference',
                          hintText: _channel == 'UPI'
                              ? 'example@bank'
                              : 'Account or beneficiary reference',
                        ),
                      ),
                      if (_message != null) ...[
                        const SizedBox(height: AppSpacing.sm),
                        _InlineMessage(
                          message: _message!,
                          tone: _messageIsSuccess
                              ? AppStatusTone.success
                              : AppStatusTone.danger,
                        ),
                      ],
                      const SizedBox(height: AppSpacing.sm),
                      AppPrimaryButton(
                        label: 'Submit payout request',
                        icon: AppIcons.send,
                        isLoading: _submitting,
                        onPressed: _submitting
                            ? null
                            : () => _requestPayout(data.balance),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                AppCard(
                  tone: AppCardTone.surface,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const AppSectionHeader(
                        title: 'Payout history',
                        subtitle: 'Track request status and payout channel.',
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      if (data.requests.isEmpty)
                        const AppEmptyState(
                          title: 'No payout requests',
                          message:
                              'Your submitted payout requests will show here.',
                          icon: AppIcons.wallet,
                        )
                      else
                        ...data.requests.asMap().entries.map((item) {
                          final request = item.value;
                          final (label, tone) = switch (request.status) {
                            PayoutStatus.requested => (
                              'Requested',
                              AppStatusTone.info,
                            ),
                            PayoutStatus.processing => (
                              'Processing',
                              AppStatusTone.warning,
                            ),
                            PayoutStatus.settled => (
                              'Settled',
                              AppStatusTone.success,
                            ),
                            PayoutStatus.failed => (
                              'Failed',
                              AppStatusTone.danger,
                            ),
                          };
                          return Column(
                            children: [
                              _PayoutHistoryRow(
                                request: request,
                                statusLabel: label,
                                statusTone: tone,
                                dateLabel: _dateLabel(request.createdAt),
                              ),
                              if (item.key != data.requests.length - 1)
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
      ),
    );
  }

  String _dateLabel(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '$day-$month-${date.year}';
  }
}

class _PayoutViewData {
  const _PayoutViewData({required this.balance, required this.requests});

  final double balance;
  final List<PayoutRequest> requests;
}

class _InlineMessage extends StatelessWidget {
  const _InlineMessage({required this.message, required this.tone});

  final String message;
  final AppStatusTone tone;

  @override
  Widget build(BuildContext context) {
    final status = context.statusStyles;
    final (fg, bg, icon) = switch (tone) {
      AppStatusTone.success => (
        status.success,
        status.successSubtle,
        AppIcons.check,
      ),
      AppStatusTone.danger => (
        status.danger,
        status.dangerSubtle,
        AppIcons.alerts,
      ),
      _ => (status.info, status.infoSubtle, AppIcons.alerts),
    };

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: fg.withValues(alpha: 0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: fg),
          const SizedBox(width: AppSpacing.xs),
          Expanded(
            child: Text(
              message,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: fg,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PayoutHistoryRow extends StatelessWidget {
  const _PayoutHistoryRow({
    required this.request,
    required this.statusLabel,
    required this.statusTone,
    required this.dateLabel,
  });

  final PayoutRequest request;
  final String statusLabel;
  final AppStatusTone statusTone;
  final String dateLabel;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: AppColors.brand100,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(AppIcons.bank, size: 18, color: AppColors.brand700),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${request.amount.toStringAsFixed(0)} credits • ${request.channel}',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 2),
              Text(dateLabel, style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ),
        AppStatusChip(label: statusLabel, tone: statusTone),
      ],
    );
  }
}
