import 'package:best_flutter_ui_templates/core/repositories/repositories.dart';

class AppServices {
  AppServices._();

  static final AppServices instance = AppServices._();

  final AuthRepository authRepository = MockAuthRepository();
  final ProfileRepository profileRepository = MockProfileRepository();
  final DocumentRepository documentRepository = MockDocumentRepository();
  final WalletRepository walletRepository = MockWalletRepository();
  final NotificationRepository notificationRepository = MockNotificationRepository();
}
