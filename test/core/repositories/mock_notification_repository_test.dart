import 'package:flutter_test/flutter_test.dart';
import 'package:parichay_candidate/core/repositories/repositories.dart';

void main() {
  test('markRead updates one notification only', () async {
    final repo = MockNotificationRepository();
    final initial = await repo.listNotifications();
    final target = initial.firstWhere((item) => !item.isRead);

    await repo.markRead(target.id);

    final updated = await repo.listNotifications();
    final targetAfter = updated.firstWhere((item) => item.id == target.id);
    expect(targetAfter.isRead, isTrue);

    final other = updated.firstWhere((item) => item.id != target.id);
    final matchingInitial = initial.firstWhere((item) => item.id == other.id);
    expect(other.isRead, matchingInitial.isRead);
  });

  test('markAllRead updates every notification', () async {
    final repo = MockNotificationRepository();
    await repo.markAllRead();
    final updated = await repo.listNotifications();
    expect(updated.every((item) => item.isRead), isTrue);
  });
}
