import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSessionStore {
  static const String _localeKey = 'preferred_locale';
  static const String _signedInKey = 'signed_in';
  static const String _hasSeenWelcomeKey = 'has_seen_welcome';

  Future<SharedPreferences> get _prefs async => SharedPreferences.getInstance();

  Future<Locale?> getPreferredLocale() async {
    final prefs = await _prefs;
    final code = prefs.getString(_localeKey);
    if (code == null || code.isEmpty) {
      return null;
    }
    return Locale(code);
  }

  Future<void> setPreferredLocale(Locale locale) async {
    final prefs = await _prefs;
    await prefs.setString(_localeKey, locale.languageCode);
  }

  Future<bool> getSignedIn() async {
    final prefs = await _prefs;
    return prefs.getBool(_signedInKey) ?? false;
  }

  Future<void> setSignedIn(bool value) async {
    final prefs = await _prefs;
    await prefs.setBool(_signedInKey, value);
  }

  Future<bool> getHasSeenWelcome() async {
    final prefs = await _prefs;
    return prefs.getBool(_hasSeenWelcomeKey) ?? false;
  }

  Future<void> setHasSeenWelcome(bool value) async {
    final prefs = await _prefs;
    await prefs.setBool(_hasSeenWelcomeKey, value);
  }

  Future<void> clearSession() async {
    final prefs = await _prefs;
    await prefs.setBool(_signedInKey, false);
    await prefs.setBool(_hasSeenWelcomeKey, false);
  }
}
