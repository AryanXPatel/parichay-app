import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_hi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('hi')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Parichay Candidate'**
  String get appTitle;

  /// No description provided for @brandName.
  ///
  /// In en, this message translates to:
  /// **'Parichay'**
  String get brandName;

  /// No description provided for @brandTagline.
  ///
  /// In en, this message translates to:
  /// **'Real Jobs. Real People.'**
  String get brandTagline;

  /// No description provided for @commonRefresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get commonRefresh;

  /// No description provided for @commonSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get commonSettings;

  /// No description provided for @commonPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get commonPending;

  /// No description provided for @commonVerified.
  ///
  /// In en, this message translates to:
  /// **'Verified'**
  String get commonVerified;

  /// No description provided for @commonRejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get commonRejected;

  /// No description provided for @languageTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose your language'**
  String get languageTitle;

  /// No description provided for @languageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Select the app language for onboarding and candidate dashboard.'**
  String get languageSubtitle;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageHindi.
  ///
  /// In en, this message translates to:
  /// **'Hindi'**
  String get languageHindi;

  /// No description provided for @languageContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get languageContinue;

  /// No description provided for @signInTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Parichay'**
  String get signInTitle;

  /// No description provided for @signInSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in with phone/email and OTP to continue your candidate journey.'**
  String get signInSubtitle;

  /// No description provided for @signInIdentifierLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone or Email'**
  String get signInIdentifierLabel;

  /// No description provided for @signInIdentifierHint.
  ///
  /// In en, this message translates to:
  /// **'+91 98XXXXXX10 or you@email.com'**
  String get signInIdentifierHint;

  /// No description provided for @signInOtpLabel.
  ///
  /// In en, this message translates to:
  /// **'OTP'**
  String get signInOtpLabel;

  /// No description provided for @signInOtpHint.
  ///
  /// In en, this message translates to:
  /// **'Enter 6-digit OTP'**
  String get signInOtpHint;

  /// No description provided for @signInRequestOtp.
  ///
  /// In en, this message translates to:
  /// **'Request OTP'**
  String get signInRequestOtp;

  /// No description provided for @signInVerifyOtp.
  ///
  /// In en, this message translates to:
  /// **'Verify OTP'**
  String get signInVerifyOtp;

  /// No description provided for @signInErrorIdentifierRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter phone number or email.'**
  String get signInErrorIdentifierRequired;

  /// No description provided for @signInErrorEmailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email address.'**
  String get signInErrorEmailInvalid;

  /// No description provided for @signInErrorPhoneInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid phone number.'**
  String get signInErrorPhoneInvalid;

  /// No description provided for @signInErrorIdentifierInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid phone number or email.'**
  String get signInErrorIdentifierInvalid;

  /// No description provided for @signInErrorOtpLength.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid 6-digit OTP.'**
  String get signInErrorOtpLength;

  /// No description provided for @signInErrorOtpInvalid.
  ///
  /// In en, this message translates to:
  /// **'Invalid OTP. Please try again.'**
  String get signInErrorOtpInvalid;

  /// No description provided for @signInDebugOtp.
  ///
  /// In en, this message translates to:
  /// **'Debug OTP: 123456'**
  String get signInDebugOtp;

  /// No description provided for @welcomeHeading.
  ///
  /// In en, this message translates to:
  /// **'Welcome, {name}'**
  String welcomeHeading(Object name);

  /// No description provided for @welcomeMessage.
  ///
  /// In en, this message translates to:
  /// **'Your profile workspace is ready. Start exploring jobs and profile insights.'**
  String get welcomeMessage;

  /// No description provided for @welcomeContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue to app'**
  String get welcomeContinue;

  /// No description provided for @welcomeProfile.
  ///
  /// In en, this message translates to:
  /// **'Open profile'**
  String get welcomeProfile;

  /// No description provided for @tabHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get tabHome;

  /// No description provided for @tabProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get tabProfile;

  /// No description provided for @tabDocuments.
  ///
  /// In en, this message translates to:
  /// **'Documents'**
  String get tabDocuments;

  /// No description provided for @tabWallet.
  ///
  /// In en, this message translates to:
  /// **'Wallet'**
  String get tabWallet;

  /// No description provided for @tabSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get tabSettings;

  /// No description provided for @tooltipNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get tooltipNotifications;

  /// No description provided for @tooltipMoreActions.
  ///
  /// In en, this message translates to:
  /// **'More actions'**
  String get tooltipMoreActions;

  /// No description provided for @menuVerification.
  ///
  /// In en, this message translates to:
  /// **'Verification center'**
  String get menuVerification;

  /// No description provided for @menuPayouts.
  ///
  /// In en, this message translates to:
  /// **'Payouts'**
  String get menuPayouts;

  /// No description provided for @menuPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy controls'**
  String get menuPrivacy;

  /// No description provided for @menuSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get menuSettings;

  /// No description provided for @dashboardLoadErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Unable to load dashboard'**
  String get dashboardLoadErrorTitle;

  /// No description provided for @dashboardLoadErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'Try refreshing to fetch your latest candidate metrics.'**
  String get dashboardLoadErrorMessage;

  /// No description provided for @dashboardHello.
  ///
  /// In en, this message translates to:
  /// **'Hello {name}'**
  String dashboardHello(Object name);

  /// No description provided for @dashboardWalletCredits.
  ///
  /// In en, this message translates to:
  /// **'{credits} credits in wallet'**
  String dashboardWalletCredits(Object credits);

  /// No description provided for @dashboardYearDownloads.
  ///
  /// In en, this message translates to:
  /// **'Your profile was downloaded {count} times this year.'**
  String dashboardYearDownloads(Object count);

  /// No description provided for @dashboardProfileCompleteChip.
  ///
  /// In en, this message translates to:
  /// **'{percent}% complete'**
  String dashboardProfileCompleteChip(Object percent);

  /// No description provided for @dashboardDocsVerifiedChip.
  ///
  /// In en, this message translates to:
  /// **'{count} docs verified'**
  String dashboardDocsVerifiedChip(Object count);

  /// No description provided for @dashboardCompletenessTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile completeness'**
  String get dashboardCompletenessTitle;

  /// No description provided for @dashboardCompletenessSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Complete missing fields to increase recruiter conversion.'**
  String get dashboardCompletenessSubtitle;

  /// No description provided for @dashboardImproveButton.
  ///
  /// In en, this message translates to:
  /// **'Improve profile views'**
  String get dashboardImproveButton;

  /// No description provided for @dashboardWeeklyViews.
  ///
  /// In en, this message translates to:
  /// **'Weekly views'**
  String get dashboardWeeklyViews;

  /// No description provided for @dashboardMonthlyViews.
  ///
  /// In en, this message translates to:
  /// **'Monthly views'**
  String get dashboardMonthlyViews;

  /// No description provided for @dashboardWeeklyDownloads.
  ///
  /// In en, this message translates to:
  /// **'Weekly downloads'**
  String get dashboardWeeklyDownloads;

  /// No description provided for @dashboardMonthlyDownloads.
  ///
  /// In en, this message translates to:
  /// **'Monthly downloads'**
  String get dashboardMonthlyDownloads;

  /// No description provided for @dashboardYearlyDownloads.
  ///
  /// In en, this message translates to:
  /// **'Yearly downloads'**
  String get dashboardYearlyDownloads;

  /// No description provided for @dashboardUnreadAlerts.
  ///
  /// In en, this message translates to:
  /// **'Unread alerts'**
  String get dashboardUnreadAlerts;

  /// No description provided for @dashboardActionNeeded.
  ///
  /// In en, this message translates to:
  /// **'Action needed'**
  String get dashboardActionNeeded;

  /// No description provided for @dashboardAllClear.
  ///
  /// In en, this message translates to:
  /// **'All clear'**
  String get dashboardAllClear;

  /// No description provided for @dashboardRecentTitle.
  ///
  /// In en, this message translates to:
  /// **'Recent activity'**
  String get dashboardRecentTitle;

  /// No description provided for @dashboardRecentSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Latest profile events and verification updates.'**
  String get dashboardRecentSubtitle;

  /// No description provided for @dashboardViewAll.
  ///
  /// In en, this message translates to:
  /// **'View all'**
  String get dashboardViewAll;

  /// No description provided for @dashboardVerification.
  ///
  /// In en, this message translates to:
  /// **'Verification'**
  String get dashboardVerification;

  /// No description provided for @dashboardPayouts.
  ///
  /// In en, this message translates to:
  /// **'Payouts'**
  String get dashboardPayouts;

  /// No description provided for @profilePhotoTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile photo'**
  String get profilePhotoTitle;

  /// No description provided for @profilePhotoSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Use a clear face photo to improve trust with recruiters.'**
  String get profilePhotoSubtitle;

  /// No description provided for @profilePhotoPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'No photo selected'**
  String get profilePhotoPlaceholder;

  /// No description provided for @profilePhotoAttached.
  ///
  /// In en, this message translates to:
  /// **'Photo attached'**
  String get profilePhotoAttached;

  /// No description provided for @profilePhotoActionAdd.
  ///
  /// In en, this message translates to:
  /// **'Add mock photo'**
  String get profilePhotoActionAdd;

  /// No description provided for @profilePhotoActionRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove photo'**
  String get profilePhotoActionRemove;

  /// No description provided for @profileBasicTitle.
  ///
  /// In en, this message translates to:
  /// **'Basic profile'**
  String get profileBasicTitle;

  /// No description provided for @profileBasicSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Information used in recruiter search and profile ranking.'**
  String get profileBasicSubtitle;

  /// No description provided for @profileProfessionalTitle.
  ///
  /// In en, this message translates to:
  /// **'Professional details'**
  String get profileProfessionalTitle;

  /// No description provided for @profileProfessionalSubtitle.
  ///
  /// In en, this message translates to:
  /// **'These directly affect profile score and recruiter relevance.'**
  String get profileProfessionalSubtitle;

  /// No description provided for @profileFieldFirstName.
  ///
  /// In en, this message translates to:
  /// **'First name'**
  String get profileFieldFirstName;

  /// No description provided for @profileFieldLastName.
  ///
  /// In en, this message translates to:
  /// **'Last name'**
  String get profileFieldLastName;

  /// No description provided for @profileFieldPhone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get profileFieldPhone;

  /// No description provided for @profileFieldEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get profileFieldEmail;

  /// No description provided for @profileFieldLocation.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get profileFieldLocation;

  /// No description provided for @profileFieldHeadline.
  ///
  /// In en, this message translates to:
  /// **'Headline'**
  String get profileFieldHeadline;

  /// No description provided for @profileFieldSkills.
  ///
  /// In en, this message translates to:
  /// **'Skills (comma-separated)'**
  String get profileFieldSkills;

  /// No description provided for @profileFieldEducation.
  ///
  /// In en, this message translates to:
  /// **'Education'**
  String get profileFieldEducation;

  /// No description provided for @profileFieldExperience.
  ///
  /// In en, this message translates to:
  /// **'Experience (years)'**
  String get profileFieldExperience;

  /// No description provided for @profileFieldRole.
  ///
  /// In en, this message translates to:
  /// **'Preferred role'**
  String get profileFieldRole;

  /// No description provided for @profileFieldSalary.
  ///
  /// In en, this message translates to:
  /// **'Expected salary (LPA)'**
  String get profileFieldSalary;

  /// No description provided for @profileFieldNotice.
  ///
  /// In en, this message translates to:
  /// **'Notice period (days)'**
  String get profileFieldNotice;

  /// No description provided for @profileResumeUploaded.
  ///
  /// In en, this message translates to:
  /// **'Resume uploaded'**
  String get profileResumeUploaded;

  /// No description provided for @profileResumeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Turn this on only when latest CV is uploaded.'**
  String get profileResumeSubtitle;

  /// No description provided for @profileSaveButton.
  ///
  /// In en, this message translates to:
  /// **'Save profile'**
  String get profileSaveButton;

  /// No description provided for @profileSaveBusy.
  ///
  /// In en, this message translates to:
  /// **'Saving...'**
  String get profileSaveBusy;

  /// No description provided for @profileSaveSuccess.
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully.'**
  String get profileSaveSuccess;

  /// No description provided for @profileSaveError.
  ///
  /// In en, this message translates to:
  /// **'Unable to save profile. Please retry.'**
  String get profileSaveError;

  /// No description provided for @profileValidationName.
  ///
  /// In en, this message translates to:
  /// **'Enter first name and last name.'**
  String get profileValidationName;

  /// No description provided for @profileValidationPhone.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid phone number.'**
  String get profileValidationPhone;

  /// No description provided for @profileValidationEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email address.'**
  String get profileValidationEmail;

  /// No description provided for @profileValidationSkills.
  ///
  /// In en, this message translates to:
  /// **'Add at least one skill.'**
  String get profileValidationSkills;

  /// No description provided for @profileValidationNumeric.
  ///
  /// In en, this message translates to:
  /// **'{label} must be a valid non-negative number.'**
  String profileValidationNumeric(Object label);

  /// No description provided for @documentsLoadErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Unable to load documents'**
  String get documentsLoadErrorTitle;

  /// No description provided for @documentsLoadErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'Please refresh and try again.'**
  String get documentsLoadErrorMessage;

  /// No description provided for @documentsHeaderTitle.
  ///
  /// In en, this message translates to:
  /// **'Upload and verify documents'**
  String get documentsHeaderTitle;

  /// No description provided for @documentsHeaderSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Resume + supporting documents increase ranking and recruiter trust.'**
  String get documentsHeaderSubtitle;

  /// No description provided for @documentsUploadButton.
  ///
  /// In en, this message translates to:
  /// **'Upload mock document'**
  String get documentsUploadButton;

  /// No description provided for @documentsUploadingButton.
  ///
  /// In en, this message translates to:
  /// **'Uploading document...'**
  String get documentsUploadingButton;

  /// No description provided for @documentsUploadSuccess.
  ///
  /// In en, this message translates to:
  /// **'Document uploaded and queued for verification.'**
  String get documentsUploadSuccess;

  /// No description provided for @documentsUploadError.
  ///
  /// In en, this message translates to:
  /// **'Unable to upload document. Please try again.'**
  String get documentsUploadError;

  /// No description provided for @documentsOpenVerification.
  ///
  /// In en, this message translates to:
  /// **'Open verification center'**
  String get documentsOpenVerification;

  /// No description provided for @documentsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No documents yet'**
  String get documentsEmptyTitle;

  /// No description provided for @documentsEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Upload resume, education, and ID documents to begin verification.'**
  String get documentsEmptyMessage;

  /// No description provided for @walletLoadErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Unable to load wallet'**
  String get walletLoadErrorTitle;

  /// No description provided for @walletLoadErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'Please refresh and try again.'**
  String get walletLoadErrorMessage;

  /// No description provided for @walletBalanceLabel.
  ///
  /// In en, this message translates to:
  /// **'Wallet balance'**
  String get walletBalanceLabel;

  /// No description provided for @walletBalanceCredits.
  ///
  /// In en, this message translates to:
  /// **'{credits} credits'**
  String walletBalanceCredits(Object credits);

  /// No description provided for @walletBalanceDescription.
  ///
  /// In en, this message translates to:
  /// **'Credits are earned via profile downloads and verified profile quality.'**
  String get walletBalanceDescription;

  /// No description provided for @walletRequestPayout.
  ///
  /// In en, this message translates to:
  /// **'Request payout'**
  String get walletRequestPayout;

  /// No description provided for @walletLedgerTitle.
  ///
  /// In en, this message translates to:
  /// **'Ledger'**
  String get walletLedgerTitle;

  /// No description provided for @walletLedgerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Credit inflow and payout deductions'**
  String get walletLedgerSubtitle;

  /// No description provided for @walletLedgerEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No transactions yet'**
  String get walletLedgerEmptyTitle;

  /// No description provided for @walletLedgerEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'You will see credits and deductions here.'**
  String get walletLedgerEmptyMessage;

  /// No description provided for @settingsPrimaryTitle.
  ///
  /// In en, this message translates to:
  /// **'Account settings'**
  String get settingsPrimaryTitle;

  /// No description provided for @settingsPrimarySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage account access, privacy, and support.'**
  String get settingsPrimarySubtitle;

  /// No description provided for @settingsAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get settingsAccountTitle;

  /// No description provided for @settingsAccountSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage personal details and identity.'**
  String get settingsAccountSubtitle;

  /// No description provided for @settingsPayoutTitle.
  ///
  /// In en, this message translates to:
  /// **'Payout methods'**
  String get settingsPayoutTitle;

  /// No description provided for @settingsPayoutSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Configure bank account / UPI details.'**
  String get settingsPayoutSubtitle;

  /// No description provided for @settingsPrivacyTitle.
  ///
  /// In en, this message translates to:
  /// **'Privacy controls'**
  String get settingsPrivacyTitle;

  /// No description provided for @settingsPrivacySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose what recruiters can view in profile preview.'**
  String get settingsPrivacySubtitle;

  /// No description provided for @settingsHelpTitle.
  ///
  /// In en, this message translates to:
  /// **'Help & support'**
  String get settingsHelpTitle;

  /// No description provided for @settingsHelpSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Raise verification and payout queries.'**
  String get settingsHelpSubtitle;

  /// No description provided for @settingsExtrasTitle.
  ///
  /// In en, this message translates to:
  /// **'More actions'**
  String get settingsExtrasTitle;

  /// No description provided for @settingsSignOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get settingsSignOut;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'hi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'hi': return AppLocalizationsHi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
