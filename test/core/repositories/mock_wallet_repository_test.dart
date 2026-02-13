import 'package:best_flutter_ui_templates/core/repositories/repositories.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('payout request succeeds when balance is sufficient', () async {
    final repo = MockWalletRepository();

    final ok = await repo.requestPayout(
      amount: 5,
      channel: 'UPI',
      accountRef: 'candidate@upi',
    );

    expect(ok, isTrue);

    final payouts = await repo.listPayoutRequests();
    expect(payouts, isNotEmpty);
    expect(payouts.first.amount, 5);
  });

  test('payout request fails for invalid amount', () async {
    final repo = MockWalletRepository();

    final ok = await repo.requestPayout(
      amount: 0,
      channel: 'UPI',
      accountRef: 'candidate@upi',
    );

    expect(ok, isFalse);
  });
}
