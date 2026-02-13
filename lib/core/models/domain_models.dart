enum VerificationStatus { pending, verified, rejected }

enum TimeWindow { weekly, monthly, yearly }

enum PayoutStatus { requested, processing, settled, failed }

class CandidateDocument {
  CandidateDocument({
    required this.id,
    required this.title,
    required this.type,
    required this.status,
    required this.uploadedAt,
    this.note,
  });

  final String id;
  final String title;
  final String type;
  final VerificationStatus status;
  final DateTime uploadedAt;
  final String? note;

  CandidateDocument copyWith({
    String? id,
    String? title,
    String? type,
    VerificationStatus? status,
    DateTime? uploadedAt,
    String? note,
  }) {
    return CandidateDocument(
      id: id ?? this.id,
      title: title ?? this.title,
      type: type ?? this.type,
      status: status ?? this.status,
      uploadedAt: uploadedAt ?? this.uploadedAt,
      note: note ?? this.note,
    );
  }
}

class CandidateProfile {
  CandidateProfile({
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.email,
    required this.location,
    required this.headline,
    required this.skills,
    required this.education,
    required this.experienceYears,
    required this.preferredRole,
    required this.salaryExpectedLpa,
    required this.noticePeriodDays,
    required this.resumeUploaded,
  });

  final String firstName;
  final String lastName;
  final String phone;
  final String email;
  final String location;
  final String headline;
  final List<String> skills;
  final String education;
  final int experienceYears;
  final String preferredRole;
  final int salaryExpectedLpa;
  final int noticePeriodDays;
  final bool resumeUploaded;

  CandidateProfile copyWith({
    String? firstName,
    String? lastName,
    String? phone,
    String? email,
    String? location,
    String? headline,
    List<String>? skills,
    String? education,
    int? experienceYears,
    String? preferredRole,
    int? salaryExpectedLpa,
    int? noticePeriodDays,
    bool? resumeUploaded,
  }) {
    return CandidateProfile(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      location: location ?? this.location,
      headline: headline ?? this.headline,
      skills: skills ?? this.skills,
      education: education ?? this.education,
      experienceYears: experienceYears ?? this.experienceYears,
      preferredRole: preferredRole ?? this.preferredRole,
      salaryExpectedLpa: salaryExpectedLpa ?? this.salaryExpectedLpa,
      noticePeriodDays: noticePeriodDays ?? this.noticePeriodDays,
      resumeUploaded: resumeUploaded ?? this.resumeUploaded,
    );
  }
}

class ProfileCompleteness {
  const ProfileCompleteness({
    required this.percentage,
    required this.missingFields,
  });

  final int percentage;
  final List<String> missingFields;
}

class WalletLedgerEntry {
  const WalletLedgerEntry({
    required this.id,
    required this.title,
    required this.amount,
    required this.isCredit,
    required this.createdAt,
    this.reference,
  });

  final String id;
  final String title;
  final double amount;
  final bool isCredit;
  final DateTime createdAt;
  final String? reference;
}

class CandidateActivityMetrics {
  const CandidateActivityMetrics({
    required this.weeklyViews,
    required this.monthlyViews,
    required this.yearlyViews,
    required this.weeklyDownloads,
    required this.monthlyDownloads,
    required this.yearlyDownloads,
  });

  final int weeklyViews;
  final int monthlyViews;
  final int yearlyViews;
  final int weeklyDownloads;
  final int monthlyDownloads;
  final int yearlyDownloads;

  // Backward compatibility alias used by older screens.
  int get downloads => yearlyDownloads;
}

class VerificationChecklistItem {
  const VerificationChecklistItem({
    required this.id,
    required this.label,
    required this.isVerified,
    this.note,
  });

  final String id;
  final String label;
  final bool isVerified;
  final String? note;
}

class VerificationMessage {
  const VerificationMessage({
    required this.id,
    required this.message,
    required this.fromAdmin,
    required this.createdAt,
  });

  final String id;
  final String message;
  final bool fromAdmin;
  final DateTime createdAt;
}

class PayoutRequest {
  const PayoutRequest({
    required this.id,
    required this.amount,
    required this.channel,
    required this.accountRef,
    required this.createdAt,
    required this.status,
  });

  final String id;
  final double amount;
  final String channel;
  final String accountRef;
  final DateTime createdAt;
  final PayoutStatus status;
}

class AppNotificationItem {
  const AppNotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.createdAt,
    required this.isRead,
  });

  final String id;
  final String title;
  final String message;
  final DateTime createdAt;
  final bool isRead;

  AppNotificationItem copyWith({
    String? id,
    String? title,
    String? message,
    DateTime? createdAt,
    bool? isRead,
  }) {
    return AppNotificationItem(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      createdAt: createdAt ?? this.createdAt,
      isRead: isRead ?? this.isRead,
    );
  }
}
