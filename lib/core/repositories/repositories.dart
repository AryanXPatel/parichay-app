import 'package:parichay_candidate/core/models/domain_models.dart';
import 'package:parichay_candidate/core/services/app_session_store.dart';

abstract class AuthRepository {
  Future<bool> requestOtp(String identifier);

  Future<bool> verifyOtp(String identifier, String otp);

  Future<void> signOut();

  Future<bool> isSignedIn();
}

abstract class ProfileRepository {
  Future<CandidateProfile> getProfile();

  Future<void> saveProfile(CandidateProfile profile);

  Future<ProfileCompleteness> getCompleteness();

  Future<CandidateActivityMetrics> getActivityMetrics();

  Future<Map<String, bool>> getPrivacySettings();

  Future<void> updatePrivacySetting(String key, bool visible);

  Future<List<String>> getImprovementSuggestions();
}

abstract class DocumentRepository {
  Future<List<CandidateDocument>> listDocuments();

  Future<void> uploadDocument(String title, String type);

  Future<List<VerificationChecklistItem>> getVerificationChecklist();

  Future<List<VerificationMessage>> listVerificationMessages();

  Future<void> sendVerificationMessage(String message);
}

abstract class WalletRepository {
  Future<double> getBalance();

  Future<List<WalletLedgerEntry>> getLedger();

  Future<List<PayoutRequest>> listPayoutRequests();

  Future<bool> requestPayout({
    required double amount,
    required String channel,
    required String accountRef,
  });
}

abstract class NotificationRepository {
  Future<List<AppNotificationItem>> listNotifications();

  Future<void> markAllRead();
}

class MockAuthRepository implements AuthRepository {
  MockAuthRepository({required this.sessionStore});

  final AppSessionStore sessionStore;

  @override
  Future<bool> isSignedIn() async => sessionStore.getSignedIn();

  @override
  Future<bool> requestOtp(String identifier) async {
    return identifier.trim().isNotEmpty;
  }

  @override
  Future<bool> verifyOtp(String identifier, String otp) async {
    final valid = identifier.trim().isNotEmpty && otp.trim() == '123456';
    await sessionStore.setSignedIn(valid);
    return valid;
  }

  @override
  Future<void> signOut() async {
    await sessionStore.clearSession();
  }
}

class MockProfileRepository implements ProfileRepository {
  CandidateProfile _profile = CandidateProfile(
    firstName: 'Anvi',
    lastName: 'Singh',
    phone: '+91 98XXXXXX10',
    email: 'anvi.singh@example.com',
    photoPath: null,
    location: 'Bhubaneswar',
    headline: 'SDET',
    skills: const ['TypeScript', 'Angular', 'Flask'],
    education: 'M.E. - Delhi University',
    experienceYears: 2,
    preferredRole: 'QA Engineer',
    salaryExpectedLpa: 14,
    noticePeriodDays: 15,
    resumeUploaded: true,
  );

  final CandidateActivityMetrics _metrics = const CandidateActivityMetrics(
    weeklyViews: 18,
    monthlyViews: 92,
    yearlyViews: 414,
    weeklyDownloads: 3,
    monthlyDownloads: 9,
    yearlyDownloads: 21,
  );

  final Map<String, bool> _privacySettings = {
    'phone': false,
    'email': false,
    'currentSalary': true,
    'documents': true,
    'location': true,
  };

  @override
  Future<CandidateActivityMetrics> getActivityMetrics() async => _metrics;

  @override
  Future<ProfileCompleteness> getCompleteness() async {
    final checks = <String, bool>{
      'First name': _profile.firstName.trim().isNotEmpty,
      'Last name': _profile.lastName.trim().isNotEmpty,
      'Phone': _profile.phone.trim().isNotEmpty,
      'Email': _profile.email.trim().isNotEmpty,
      'Photo': (_profile.photoPath ?? '').trim().isNotEmpty,
      'Location': _profile.location.trim().isNotEmpty,
      'Headline': _profile.headline.trim().isNotEmpty,
      'Skills': _profile.skills.isNotEmpty,
      'Education': _profile.education.trim().isNotEmpty,
      'Preferred role': _profile.preferredRole.trim().isNotEmpty,
      'Resume': _profile.resumeUploaded,
    };

    final completed = checks.values.where((v) => v).length;
    final percentage = ((completed / checks.length) * 100).round();
    final missing = checks.entries
        .where((entry) => !entry.value)
        .map((entry) => entry.key)
        .toList();

    return ProfileCompleteness(percentage: percentage, missingFields: missing);
  }

  @override
  Future<CandidateProfile> getProfile() async => _profile;

  @override
  Future<Map<String, bool>> getPrivacySettings() async =>
      Map.of(_privacySettings);

  @override
  Future<void> saveProfile(CandidateProfile profile) async {
    _profile = profile;
  }

  @override
  Future<void> updatePrivacySetting(String key, bool visible) async {
    _privacySettings[key] = visible;
  }

  @override
  Future<List<String>> getImprovementSuggestions() async {
    final completeness = await getCompleteness();
    if (completeness.missingFields.isEmpty) {
      return const [
        'Add fresh projects and certifications every month.',
        'Turn on phone visibility when actively searching.',
      ];
    }
    return completeness.missingFields
        .map((field) => 'Complete "$field" to improve recruiter conversion.')
        .toList(growable: false);
  }
}

class MockDocumentRepository implements DocumentRepository {
  final List<CandidateDocument> _docs = [
    CandidateDocument(
      id: 'doc-1',
      title: 'Resume',
      type: 'CV',
      status: VerificationStatus.verified,
      uploadedAt: DateTime(2026, 1, 12),
    ),
    CandidateDocument(
      id: 'doc-2',
      title: 'B.Tech Certificate',
      type: 'Education',
      status: VerificationStatus.pending,
      uploadedAt: DateTime(2026, 1, 18),
    ),
    CandidateDocument(
      id: 'doc-3',
      title: 'Aadhaar',
      type: 'Government ID',
      status: VerificationStatus.verified,
      uploadedAt: DateTime(2026, 1, 20),
    ),
  ];

  final List<VerificationMessage> _messages = [
    VerificationMessage(
      id: 'q-1',
      message: 'Please upload a clearer Aadhaar image for final check.',
      fromAdmin: true,
      createdAt: DateTime(2026, 1, 22),
    ),
    VerificationMessage(
      id: 'q-2',
      message: 'Uploaded high-resolution copy today. Please review.',
      fromAdmin: false,
      createdAt: DateTime(2026, 1, 23),
    ),
  ];

  @override
  Future<List<CandidateDocument>> listDocuments() async => List.of(_docs);

  @override
  Future<void> uploadDocument(String title, String type) async {
    _docs.insert(
      0,
      CandidateDocument(
        id: 'doc-${DateTime.now().microsecondsSinceEpoch}',
        title: title,
        type: type,
        status: VerificationStatus.pending,
        uploadedAt: DateTime.now(),
      ),
    );
  }

  @override
  Future<List<VerificationChecklistItem>> getVerificationChecklist() async {
    final resume = _docs.any(
      (d) => d.type == 'CV' && d.status == VerificationStatus.verified,
    );
    final education = _docs.any(
      (d) => d.type == 'Education' && d.status == VerificationStatus.verified,
    );
    final governmentId = _docs.any(
      (d) =>
          d.type == 'Government ID' && d.status == VerificationStatus.verified,
    );
    return [
      VerificationChecklistItem(
        id: 'check-resume',
        label: 'Resume verified',
        isVerified: resume,
      ),
      VerificationChecklistItem(
        id: 'check-education',
        label: 'Education certificate verified',
        isVerified: education,
      ),
      VerificationChecklistItem(
        id: 'check-id',
        label: 'Government ID verified',
        isVerified: governmentId,
      ),
    ];
  }

  @override
  Future<List<VerificationMessage>> listVerificationMessages() async {
    return List.of(_messages);
  }

  @override
  Future<void> sendVerificationMessage(String message) async {
    if (message.trim().isEmpty) {
      return;
    }
    _messages.add(
      VerificationMessage(
        id: 'q-${DateTime.now().microsecondsSinceEpoch}',
        message: message.trim(),
        fromAdmin: false,
        createdAt: DateTime.now(),
      ),
    );
  }
}

class MockWalletRepository implements WalletRepository {
  final List<WalletLedgerEntry> _ledger = [
    WalletLedgerEntry(
      id: 'w-1',
      title: 'Profile downloaded by Recruiter A',
      amount: 12,
      isCredit: true,
      createdAt: DateTime(2026, 1, 25),
      reference: 'DOWNLOAD-991',
    ),
    WalletLedgerEntry(
      id: 'w-2',
      title: 'Verification bonus',
      amount: 6,
      isCredit: true,
      createdAt: DateTime(2026, 1, 21),
      reference: 'VERIFY-238',
    ),
    WalletLedgerEntry(
      id: 'w-3',
      title: 'Payout requested',
      amount: 10,
      isCredit: false,
      createdAt: DateTime(2026, 1, 18),
      reference: 'PAYOUT-142',
    ),
  ];

  final List<PayoutRequest> _payouts = [
    PayoutRequest(
      id: 'p-1',
      amount: 10,
      channel: 'UPI',
      accountRef: 'anvi@upi',
      createdAt: DateTime(2026, 1, 18),
      status: PayoutStatus.processing,
    ),
  ];

  @override
  Future<double> getBalance() async {
    return _ledger.fold<double>(0.0, (sum, item) {
      final signed = item.isCredit ? item.amount : -item.amount;
      return sum + signed;
    });
  }

  @override
  Future<List<WalletLedgerEntry>> getLedger() async => List.of(_ledger);

  @override
  Future<List<PayoutRequest>> listPayoutRequests() async => List.of(_payouts);

  @override
  Future<bool> requestPayout({
    required double amount,
    required String channel,
    required String accountRef,
  }) async {
    if (amount <= 0 || accountRef.trim().isEmpty || channel.trim().isEmpty) {
      return false;
    }
    final balance = await getBalance();
    if (balance < amount) {
      return false;
    }

    _ledger.insert(
      0,
      WalletLedgerEntry(
        id: 'w-${DateTime.now().microsecondsSinceEpoch}',
        title: 'Payout requested via $channel',
        amount: amount,
        isCredit: false,
        createdAt: DateTime.now(),
        reference: 'PAYOUT-${DateTime.now().millisecondsSinceEpoch}',
      ),
    );
    _payouts.insert(
      0,
      PayoutRequest(
        id: 'p-${DateTime.now().millisecondsSinceEpoch}',
        amount: amount,
        channel: channel,
        accountRef: accountRef,
        createdAt: DateTime.now(),
        status: PayoutStatus.requested,
      ),
    );
    return true;
  }
}

class MockNotificationRepository implements NotificationRepository {
  List<AppNotificationItem> _notifications = [
    AppNotificationItem(
      id: 'n-1',
      title: 'Profile viewed',
      message: 'A recruiter viewed your profile for QA Engineer role.',
      createdAt: DateTime(2026, 1, 26),
      isRead: false,
    ),
    AppNotificationItem(
      id: 'n-2',
      title: 'Document verified',
      message: 'Aadhaar has been verified successfully.',
      createdAt: DateTime(2026, 1, 24),
      isRead: false,
    ),
    AppNotificationItem(
      id: 'n-3',
      title: 'Wallet credited',
      message: '12 credits added from profile download.',
      createdAt: DateTime(2026, 1, 22),
      isRead: true,
    ),
  ];

  @override
  Future<List<AppNotificationItem>> listNotifications() async {
    return List.of(_notifications);
  }

  @override
  Future<void> markAllRead() async {
    _notifications = _notifications
        .map((item) => item.copyWith(isRead: true))
        .toList(growable: false);
  }
}
