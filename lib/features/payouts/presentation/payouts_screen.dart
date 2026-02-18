import 'package:parichay_candidate/core/models/domain_models.dart';
import 'package:parichay_candidate/core/services/app_services.dart';
import 'package:parichay_candidate/core/theme/app_spacing.dart';
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
                      DropdownButtonFormField<String>(
                        initialValue: _channel,
                        decoration: const InputDecoration(
                          labelText: 'Payout channel',
                        ),
                        items: const [
                          DropdownMenuItem(value: 'UPI', child: Text('UPI')),
                          DropdownMenuItem(
                            value: 'Bank Transfer',
                            child: Text('Bank Transfer'),
                          ),
                        ],
                        onChanged: (value) {
                          if (value == null) {
                            return;
                          }
                          setState(() => _channel = value);
                        },
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      TextField(
                        controller: _accountController,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                          labelText: _channel == 'UPI'
                              ? 'UPI ID'
                              : 'Bank account reference',
                        ),
                      ),
                      if (_message != null) ...[
                        const SizedBox(height: AppSpacing.sm),
                        AppStatusChip(
                          label: _message!,
                          tone: _message!.startsWith('Payout request')
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
                        ...data.requests.map((request) {
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
                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: const Icon(AppIcons.bank),
                            title: Text(
                              '${request.amount.toStringAsFixed(0)} credits • ${request.channel}',
                            ),
                            subtitle: Text(_dateLabel(request.createdAt)),
                            trailing: AppStatusChip(label: label, tone: tone),
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
