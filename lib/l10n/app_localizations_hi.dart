// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appTitle => 'परिचय कैंडिडेट';

  @override
  String get brandName => 'परिचय';

  @override
  String get brandTagline => 'असली नौकरियां। असली लोग।';

  @override
  String get commonRefresh => 'रीफ्रेश';

  @override
  String get commonSettings => 'सेटिंग्स';

  @override
  String get commonPending => 'लंबित';

  @override
  String get commonVerified => 'सत्यापित';

  @override
  String get commonRejected => 'अस्वीकृत';

  @override
  String get languageTitle => 'अपनी भाषा चुनें';

  @override
  String get languageSubtitle => 'ऑनबोर्डिंग और कैंडिडेट डैशबोर्ड के लिए ऐप भाषा चुनें।';

  @override
  String get languageEnglish => 'अंग्रेजी';

  @override
  String get languageHindi => 'हिंदी';

  @override
  String get languageContinue => 'जारी रखें';

  @override
  String get signInTitle => 'परिचय में आपका स्वागत है';

  @override
  String get signInSubtitle => 'अपनी कैंडिडेट यात्रा जारी रखने के लिए फोन/ईमेल और OTP से साइन इन करें।';

  @override
  String get signInIdentifierLabel => 'फोन या ईमेल';

  @override
  String get signInIdentifierHint => '+91 98XXXXXX10 या you@email.com';

  @override
  String get signInOtpLabel => 'OTP';

  @override
  String get signInOtpHint => '6 अंकों का OTP दर्ज करें';

  @override
  String get signInRequestOtp => 'OTP भेजें';

  @override
  String get signInVerifyOtp => 'OTP सत्यापित करें';

  @override
  String get signInErrorIdentifierRequired => 'फोन नंबर या ईमेल दर्ज करें।';

  @override
  String get signInErrorEmailInvalid => 'मान्य ईमेल पता दर्ज करें।';

  @override
  String get signInErrorPhoneInvalid => 'मान्य फोन नंबर दर्ज करें।';

  @override
  String get signInErrorIdentifierInvalid => 'मान्य फोन नंबर या ईमेल दर्ज करें।';

  @override
  String get signInErrorOtpLength => 'मान्य 6 अंकों का OTP दर्ज करें।';

  @override
  String get signInErrorOtpInvalid => 'अमान्य OTP। कृपया दोबारा प्रयास करें।';

  @override
  String get signInDebugOtp => 'डीबग OTP: 123456';

  @override
  String welcomeHeading(Object name) {
    return 'स्वागत है, $name';
  }

  @override
  String get welcomeMessage => 'आपका प्रोफाइल कार्यक्षेत्र तैयार है। अब नौकरियां और प्रोफाइल इनसाइट्स देखें।';

  @override
  String get welcomeContinue => 'ऐप में जाएं';

  @override
  String get welcomeProfile => 'प्रोफाइल खोलें';

  @override
  String get tabHome => 'होम';

  @override
  String get tabProfile => 'प्रोफाइल';

  @override
  String get tabDocuments => 'दस्तावेज़';

  @override
  String get tabWallet => 'वॉलेट';

  @override
  String get tabSettings => 'सेटिंग्स';

  @override
  String get tooltipNotifications => 'नोटिफिकेशन';

  @override
  String get tooltipMoreActions => 'अधिक विकल्प';

  @override
  String get menuVerification => 'वेरिफिकेशन सेंटर';

  @override
  String get menuPayouts => 'पेआउट्स';

  @override
  String get menuPrivacy => 'प्राइवेसी कंट्रोल्स';

  @override
  String get menuSettings => 'सेटिंग्स';

  @override
  String get dashboardLoadErrorTitle => 'डैशबोर्ड लोड नहीं हो सका';

  @override
  String get dashboardLoadErrorMessage => 'नवीनतम कैंडिडेट मीट्रिक्स पाने के लिए रीफ्रेश करें।';

  @override
  String dashboardHello(Object name) {
    return 'नमस्ते $name';
  }

  @override
  String dashboardWalletCredits(Object credits) {
    return 'वॉलेट में $credits क्रेडिट';
  }

  @override
  String dashboardYearDownloads(Object count) {
    return 'इस वर्ष आपका प्रोफाइल $count बार डाउनलोड हुआ।';
  }

  @override
  String dashboardProfileCompleteChip(Object percent) {
    return '$percent% पूर्ण';
  }

  @override
  String dashboardDocsVerifiedChip(Object count) {
    return '$count दस्तावेज़ सत्यापित';
  }

  @override
  String get dashboardCompletenessTitle => 'प्रोफाइल पूर्णता';

  @override
  String get dashboardCompletenessSubtitle => 'रिक्रूटर कन्वर्ज़न बढ़ाने के लिए छूटी जानकारी पूरी करें।';

  @override
  String get dashboardImproveButton => 'प्रोफाइल व्यू बढ़ाएं';

  @override
  String get dashboardWeeklyViews => 'साप्ताहिक व्यू';

  @override
  String get dashboardMonthlyViews => 'मासिक व्यू';

  @override
  String get dashboardWeeklyDownloads => 'साप्ताहिक डाउनलोड';

  @override
  String get dashboardMonthlyDownloads => 'मासिक डाउनलोड';

  @override
  String get dashboardYearlyDownloads => 'वार्षिक डाउनलोड';

  @override
  String get dashboardUnreadAlerts => 'अनपढ़े अलर्ट';

  @override
  String get dashboardActionNeeded => 'कार्रवाई आवश्यक';

  @override
  String get dashboardAllClear => 'सब ठीक है';

  @override
  String get dashboardRecentTitle => 'हाल की गतिविधि';

  @override
  String get dashboardRecentSubtitle => 'नवीनतम प्रोफाइल इवेंट और वेरिफिकेशन अपडेट।';

  @override
  String get dashboardViewAll => 'सभी देखें';

  @override
  String get dashboardVerification => 'वेरिफिकेशन';

  @override
  String get dashboardPayouts => 'पेआउट्स';

  @override
  String get profilePhotoTitle => 'प्रोफाइल फोटो';

  @override
  String get profilePhotoSubtitle => 'रिक्रूटर्स के भरोसे के लिए स्पष्ट चेहरा फोटो लगाएं।';

  @override
  String get profilePhotoPlaceholder => 'कोई फोटो चयनित नहीं';

  @override
  String get profilePhotoAttached => 'फोटो जुड़ी हुई है';

  @override
  String get profilePhotoActionAdd => 'मॉक फोटो जोड़ें';

  @override
  String get profilePhotoActionRemove => 'फोटो हटाएं';

  @override
  String get profileBasicTitle => 'बेसिक प्रोफाइल';

  @override
  String get profileBasicSubtitle => 'यह जानकारी रिक्रूटर सर्च और प्रोफाइल रैंकिंग में उपयोग होती है।';

  @override
  String get profileProfessionalTitle => 'प्रोफेशनल विवरण';

  @override
  String get profileProfessionalSubtitle => 'यह सीधे प्रोफाइल स्कोर और रिक्रूटर प्रासंगिकता को प्रभावित करते हैं।';

  @override
  String get profileFieldFirstName => 'पहला नाम';

  @override
  String get profileFieldLastName => 'अंतिम नाम';

  @override
  String get profileFieldPhone => 'फोन';

  @override
  String get profileFieldEmail => 'ईमेल';

  @override
  String get profileFieldLocation => 'लोकेशन';

  @override
  String get profileFieldHeadline => 'हेडलाइन';

  @override
  String get profileFieldSkills => 'स्किल्स (कॉमा से अलग)';

  @override
  String get profileFieldEducation => 'शिक्षा';

  @override
  String get profileFieldExperience => 'अनुभव (वर्ष)';

  @override
  String get profileFieldRole => 'पसंदीदा भूमिका';

  @override
  String get profileFieldSalary => 'अपेक्षित वेतन (LPA)';

  @override
  String get profileFieldNotice => 'नोटिस पीरियड (दिन)';

  @override
  String get profileResumeUploaded => 'रिज्यूमे अपलोड किया गया';

  @override
  String get profileResumeSubtitle => 'केवल तभी चालू करें जब नवीनतम CV अपलोड हो।';

  @override
  String get profileSaveButton => 'प्रोफाइल सेव करें';

  @override
  String get profileSaveBusy => 'सेव हो रहा है...';

  @override
  String get profileSaveSuccess => 'प्रोफाइल सफलतापूर्वक अपडेट हुई।';

  @override
  String get profileSaveError => 'प्रोफाइल सेव नहीं हो सकी। कृपया पुनः प्रयास करें।';

  @override
  String get profileValidationName => 'पहला और अंतिम नाम दर्ज करें।';

  @override
  String get profileValidationPhone => 'मान्य फोन नंबर दर्ज करें।';

  @override
  String get profileValidationEmail => 'मान्य ईमेल पता दर्ज करें।';

  @override
  String get profileValidationSkills => 'कम से कम एक स्किल जोड़ें।';

  @override
  String profileValidationNumeric(Object label) {
    return '$label मान्य गैर-ऋणात्मक संख्या होनी चाहिए।';
  }

  @override
  String get documentsLoadErrorTitle => 'दस्तावेज़ लोड नहीं हो सके';

  @override
  String get documentsLoadErrorMessage => 'कृपया रीफ्रेश करके फिर प्रयास करें।';

  @override
  String get documentsHeaderTitle => 'दस्तावेज़ अपलोड और सत्यापित करें';

  @override
  String get documentsHeaderSubtitle => 'रिज्यूमे और सहायक दस्तावेज़ रैंकिंग और भरोसा बढ़ाते हैं।';

  @override
  String get documentsUploadButton => 'मॉक दस्तावेज़ अपलोड करें';

  @override
  String get documentsUploadingButton => 'दस्तावेज़ अपलोड हो रहा है...';

  @override
  String get documentsUploadSuccess => 'दस्तावेज़ अपलोड हुआ और वेरिफिकेशन के लिए भेजा गया।';

  @override
  String get documentsUploadError => 'दस्तावेज़ अपलोड नहीं हो सका। कृपया फिर प्रयास करें।';

  @override
  String get documentsOpenVerification => 'वेरिफिकेशन सेंटर खोलें';

  @override
  String get documentsEmptyTitle => 'अभी कोई दस्तावेज़ नहीं';

  @override
  String get documentsEmptyMessage => 'वेरिफिकेशन शुरू करने के लिए रिज्यूमे, शिक्षा और ID दस्तावेज़ अपलोड करें।';

  @override
  String get walletLoadErrorTitle => 'वॉलेट लोड नहीं हो सका';

  @override
  String get walletLoadErrorMessage => 'कृपया रीफ्रेश करके फिर प्रयास करें।';

  @override
  String get walletBalanceLabel => 'वॉलेट बैलेंस';

  @override
  String walletBalanceCredits(Object credits) {
    return '$credits क्रेडिट';
  }

  @override
  String get walletBalanceDescription => 'क्रेडिट प्रोफाइल डाउनलोड और वेरिफाइड प्रोफाइल गुणवत्ता से मिलते हैं।';

  @override
  String get walletRequestPayout => 'पेआउट अनुरोध करें';

  @override
  String get walletLedgerTitle => 'लेजर';

  @override
  String get walletLedgerSubtitle => 'क्रेडिट जोड़ और पेआउट कटौती';

  @override
  String get walletLedgerEmptyTitle => 'अभी कोई ट्रांजैक्शन नहीं';

  @override
  String get walletLedgerEmptyMessage => 'यहां आपको क्रेडिट और कटौतियां दिखेंगी।';

  @override
  String get settingsPrimaryTitle => 'अकाउंट सेटिंग्स';

  @override
  String get settingsPrimarySubtitle => 'अकाउंट एक्सेस, प्राइवेसी और सपोर्ट प्रबंधित करें।';

  @override
  String get settingsAccountTitle => 'अकाउंट';

  @override
  String get settingsAccountSubtitle => 'व्यक्तिगत विवरण और पहचान प्रबंधित करें।';

  @override
  String get settingsPayoutTitle => 'पेआउट मेथड्स';

  @override
  String get settingsPayoutSubtitle => 'बैंक अकाउंट / UPI विवरण सेट करें।';

  @override
  String get settingsPrivacyTitle => 'प्राइवेसी कंट्रोल्स';

  @override
  String get settingsPrivacySubtitle => 'चुनें कि रिक्रूटर्स प्रोफाइल प्रीव्यू में क्या देख सकते हैं।';

  @override
  String get settingsHelpTitle => 'हेल्प और सपोर्ट';

  @override
  String get settingsHelpSubtitle => 'वेरिफिकेशन और पेआउट से जुड़े सवाल पूछें।';

  @override
  String get settingsExtrasTitle => 'अन्य विकल्प';

  @override
  String get settingsSignOut => 'साइन आउट';
}
