import 'package:parichay_candidate/core/repositories/repositories.dart';
import 'package:parichay_candidate/core/services/app_session_store.dart';
import 'package:flutter/widgets.dart';

class AppServices {
  AppServices._();

  static final AppServices instance = AppServices._();

  final AppSessionStore appSessionStore = AppSessionStore();
  final ValueNotifier<Locale?> localeNotifier = ValueNotifier<Locale?>(null);
  late final AuthRepository authRepository = MockAuthRepository(
    sessionStore: appSessionStore,
  );
  final ProfileRepository profileRepository = MockProfileRepository();
  final DocumentRepository documentRepository = MockDocumentRepository();
  final WalletRepository walletRepository = MockWalletRepository();
  final NotificationRepository notificationRepository =
      MockNotificationRepository();

  Future<void> loadInitialLocale() async {
    localeNotifier.value = await appSessionStore.getPreferredLocale();
  }

  Future<void> setLocale(Locale locale) async {
    await appSessionStore.setPreferredLocale(locale);
    localeNotifier.value = locale;
  }
}
