// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Parichay Candidate';

  @override
  String get brandName => 'Parichay';

  @override
  String get brandTagline => 'Real Jobs. Real People.';

  @override
  String get commonRefresh => 'Refresh';

  @override
  String get commonSettings => 'Settings';

  @override
  String get commonPending => 'Pending';

  @override
  String get commonVerified => 'Verified';

  @override
  String get commonRejected => 'Rejected';

  @override
  String get languageTitle => 'Choose your language';

  @override
  String get languageSubtitle => 'Select the app language for onboarding and candidate dashboard.';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageHindi => 'Hindi';

  @override
  String get languageContinue => 'Continue';

  @override
  String get signInTitle => 'Welcome to Parichay';

  @override
  String get signInSubtitle => 'Sign in with phone/email and OTP to continue your candidate journey.';

  @override
  String get signInIdentifierLabel => 'Phone or Email';

  @override
  String get signInIdentifierHint => '+91 98XXXXXX10 or you@email.com';

  @override
  String get signInOtpLabel => 'OTP';

  @override
  String get signInOtpHint => 'Enter 6-digit OTP';

  @override
  String get signInRequestOtp => 'Request OTP';

  @override
  String get signInVerifyOtp => 'Verify OTP';

  @override
  String get signInErrorIdentifierRequired => 'Enter phone number or email.';

  @override
  String get signInErrorEmailInvalid => 'Enter a valid email address.';

  @override
  String get signInErrorPhoneInvalid => 'Enter a valid phone number.';

  @override
  String get signInErrorIdentifierInvalid => 'Enter a valid phone number or email.';

  @override
  String get signInErrorOtpLength => 'Enter a valid 6-digit OTP.';

  @override
  String get signInErrorOtpInvalid => 'Invalid OTP. Please try again.';

  @override
  String get signInDebugOtp => 'Debug OTP: 123456';

  @override
  String welcomeHeading(Object name) {
    return 'Welcome, $name';
  }

  @override
  String get welcomeMessage => 'Your profile workspace is ready. Start exploring jobs and profile insights.';

  @override
  String get welcomeContinue => 'Continue to app';

  @override
  String get welcomeProfile => 'Open profile';

  @override
  String get tabHome => 'Home';

  @override
  String get tabProfile => 'Profile';

  @override
  String get tabDocuments => 'Documents';

  @override
  String get tabWallet => 'Wallet';

  @override
  String get tabSettings => 'Settings';

  @override
  String get tooltipNotifications => 'Notifications';

  @override
  String get tooltipMoreActions => 'More actions';

  @override
  String get menuVerification => 'Verification center';

  @override
  String get menuPayouts => 'Payouts';

  @override
  String get menuPrivacy => 'Privacy controls';

  @override
  String get menuSettings => 'Settings';

  @override
  String get dashboardLoadErrorTitle => 'Unable to load dashboard';

  @override
  String get dashboardLoadErrorMessage => 'Try refreshing to fetch your latest candidate metrics.';

  @override
  String dashboardHello(Object name) {
    return 'Hello $name';
  }

  @override
  String dashboardWalletCredits(Object credits) {
    return '$credits credits in wallet';
  }

  @override
  String dashboardYearDownloads(Object count) {
    return 'Your profile was downloaded $count times this year.';
  }

  @override
  String dashboardProfileCompleteChip(Object percent) {
    return '$percent% complete';
  }

  @override
  String dashboardDocsVerifiedChip(Object count) {
    return '$count docs verified';
  }

  @override
  String get dashboardCompletenessTitle => 'Profile completeness';

  @override
  String get dashboardCompletenessSubtitle => 'Complete missing fields to increase recruiter conversion.';

  @override
  String get dashboardImproveButton => 'Improve profile views';

  @override
  String get dashboardWeeklyViews => 'Weekly views';

  @override
  String get dashboardMonthlyViews => 'Monthly views';

  @override
  String get dashboardWeeklyDownloads => 'Weekly downloads';

  @override
  String get dashboardMonthlyDownloads => 'Monthly downloads';

  @override
  String get dashboardYearlyDownloads => 'Yearly downloads';

  @override
  String get dashboardUnreadAlerts => 'Unread alerts';

  @override
  String get dashboardActionNeeded => 'Action needed';

  @override
  String get dashboardAllClear => 'All clear';

  @override
  String get dashboardRecentTitle => 'Recent activity';

  @override
  String get dashboardRecentSubtitle => 'Latest profile events and verification updates.';

  @override
  String get dashboardViewAll => 'View all';

  @override
  String get dashboardVerification => 'Verification';

  @override
  String get dashboardPayouts => 'Payouts';

  @override
  String get profilePhotoTitle => 'Profile photo';

  @override
  String get profilePhotoSubtitle => 'Use a clear face photo to improve trust with recruiters.';

  @override
  String get profilePhotoPlaceholder => 'No photo selected';

  @override
  String get profilePhotoAttached => 'Photo attached';

  @override
  String get profilePhotoActionAdd => 'Add mock photo';

  @override
  String get profilePhotoActionRemove => 'Remove photo';

  @override
  String get profileBasicTitle => 'Basic profile';

  @override
  String get profileBasicSubtitle => 'Information used in recruiter search and profile ranking.';

  @override
  String get profileProfessionalTitle => 'Professional details';

  @override
  String get profileProfessionalSubtitle => 'These directly affect profile score and recruiter relevance.';

  @override
  String get profileFieldFirstName => 'First name';

  @override
  String get profileFieldLastName => 'Last name';

  @override
  String get profileFieldPhone => 'Phone';

  @override
  String get profileFieldEmail => 'Email';

  @override
  String get profileFieldLocation => 'Location';

  @override
  String get profileFieldHeadline => 'Headline';

  @override
  String get profileFieldSkills => 'Skills (comma-separated)';

  @override
  String get profileFieldEducation => 'Education';

  @override
  String get profileFieldExperience => 'Experience (years)';

  @override
  String get profileFieldRole => 'Preferred role';

  @override
  String get profileFieldSalary => 'Expected salary (LPA)';

  @override
  String get profileFieldNotice => 'Notice period (days)';

  @override
  String get profileResumeUploaded => 'Resume uploaded';

  @override
  String get profileResumeSubtitle => 'Turn this on only when latest CV is uploaded.';

  @override
  String get profileSaveButton => 'Save profile';

  @override
  String get profileSaveBusy => 'Saving...';

  @override
  String get profileSaveSuccess => 'Profile updated successfully.';

  @override
  String get profileSaveError => 'Unable to save profile. Please retry.';

  @override
  String get profileValidationName => 'Enter first name and last name.';

  @override
  String get profileValidationPhone => 'Enter a valid phone number.';

  @override
  String get profileValidationEmail => 'Enter a valid email address.';

  @override
  String get profileValidationSkills => 'Add at least one skill.';

  @override
  String profileValidationNumeric(Object label) {
    return '$label must be a valid non-negative number.';
  }

  @override
  String get documentsLoadErrorTitle => 'Unable to load documents';

  @override
  String get documentsLoadErrorMessage => 'Please refresh and try again.';

  @override
  String get documentsHeaderTitle => 'Upload and verify documents';

  @override
  String get documentsHeaderSubtitle => 'Resume + supporting documents increase ranking and recruiter trust.';

  @override
  String get documentsUploadButton => 'Upload mock document';

  @override
  String get documentsUploadingButton => 'Uploading document...';

  @override
  String get documentsUploadSuccess => 'Document uploaded and queued for verification.';

  @override
  String get documentsUploadError => 'Unable to upload document. Please try again.';

  @override
  String get documentsOpenVerification => 'Open verification center';

  @override
  String get documentsEmptyTitle => 'No documents yet';

  @override
  String get documentsEmptyMessage => 'Upload resume, education, and ID documents to begin verification.';

  @override
  String get walletLoadErrorTitle => 'Unable to load wallet';

  @override
  String get walletLoadErrorMessage => 'Please refresh and try again.';

  @override
  String get walletBalanceLabel => 'Wallet balance';

  @override
  String walletBalanceCredits(Object credits) {
    return '$credits credits';
  }

  @override
  String get walletBalanceDescription => 'Credits are earned via profile downloads and verified profile quality.';

  @override
  String get walletRequestPayout => 'Request payout';

  @override
  String get walletLedgerTitle => 'Ledger';

  @override
  String get walletLedgerSubtitle => 'Credit inflow and payout deductions';

  @override
  String get walletLedgerEmptyTitle => 'No transactions yet';

  @override
  String get walletLedgerEmptyMessage => 'You will see credits and deductions here.';

  @override
  String get settingsPrimaryTitle => 'Account settings';

  @override
  String get settingsPrimarySubtitle => 'Manage account access, privacy, and support.';

  @override
  String get settingsAccountTitle => 'Account';

  @override
  String get settingsAccountSubtitle => 'Manage personal details and identity.';

  @override
  String get settingsPayoutTitle => 'Payout methods';

  @override
  String get settingsPayoutSubtitle => 'Configure bank account / UPI details.';

  @override
  String get settingsPrivacyTitle => 'Privacy controls';

  @override
  String get settingsPrivacySubtitle => 'Choose what recruiters can view in profile preview.';

  @override
  String get settingsHelpTitle => 'Help & support';

  @override
  String get settingsHelpSubtitle => 'Raise verification and payout queries.';

  @override
  String get settingsExtrasTitle => 'More actions';

  @override
  String get settingsSignOut => 'Sign out';
}
