import 'package:best_flutter_ui_templates/core/repositories/repositories.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('sendVerificationMessage appends a candidate query', () async {
    final repo = MockDocumentRepository();
    final before = await repo.listVerificationMessages();

    await repo.sendVerificationMessage('Need help verifying payslip');

    final after = await repo.listVerificationMessages();
    expect(after.length, before.length + 1);
    expect(after.last.fromAdmin, isFalse);
    expect(after.last.message, 'Need help verifying payslip');
  });
}
