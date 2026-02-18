import 'package:parichay_candidate/core/services/app_session_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('store persists locale and session flags', () async {
    final store = AppSessionStore();

    expect(await store.getPreferredLocale(), isNull);
    expect(await store.getSignedIn(), isFalse);
    expect(await store.getHasSeenWelcome(), isFalse);

    await store.setPreferredLocale(const Locale('hi'));
    await store.setSignedIn(true);
    await store.setHasSeenWelcome(true);

    expect((await store.getPreferredLocale())?.languageCode, 'hi');
    expect(await store.getSignedIn(), isTrue);
    expect(await store.getHasSeenWelcome(), isTrue);
  });

  test('clearSession keeps locale but resets auth flags', () async {
    final store = AppSessionStore();

    await store.setPreferredLocale(const Locale('en'));
    await store.setSignedIn(true);
    await store.setHasSeenWelcome(true);
    await store.clearSession();

    expect((await store.getPreferredLocale())?.languageCode, 'en');
    expect(await store.getSignedIn(), isFalse);
    expect(await store.getHasSeenWelcome(), isFalse);
  });
}
