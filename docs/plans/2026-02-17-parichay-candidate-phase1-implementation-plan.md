# Parichay Candidate Phase 1 Implementation Plan

## Goal
Deliver Phase 1 Candidate app UI/UX with dummy data: splash, language selection (EN/HI), OTP login, welcome screen, and 5-tab shell.

## Scope
- Candidate app only.
- Preserve non-scope routes (notifications, payouts, verification, privacy).
- Persist language/session/onboarding markers.
- Full localization for phase-1 candidate surfaces.

## Implemented Workstreams
1. Added localization + persistence dependencies and enabled l10n generation.
2. Added `AppSessionStore` for persisted locale/session/welcome flags.
3. Added language selection screen and route.
4. Updated splash bootstrap routing for locale/session state.
5. Added welcome screen and post-login flow.
6. Converted app shell to 5 tabs: Home, Profile, Documents, Wallet, Settings.
7. Updated settings IA with primary + extra sections while retaining compatibility routes.
8. Extended profile model/UI with mock photo support.
9. Added English/Hindi ARB files and localized phase-1 screens.
10. Added/updated widget and unit tests for onboarding/auth/navigation/profile/session storage.

## Verification Commands
```bash
flutter pub get
flutter analyze
flutter test
```

## Acceptance Checklist
- [ ] Flow: Splash -> Language -> OTP -> Welcome -> App shell
- [ ] 5-tab navigation order matches scope
- [ ] Sign out clears session and returns to sign-in
- [ ] Language persists across restart
- [ ] Non-scope routes remain accessible
- [ ] Analyze and tests pass
