# Parichay Mobile (Flutter)

Candidate-facing Flutter application for the Parichay MVP.

## Features

- OTP sign-in flow
- Dashboard with profile metrics and recent activity
- Documents and verification center
- Wallet and payouts
- Privacy controls
- Settings and notifications
- Profile update with validation

## Tech Stack

- Flutter (Dart 3)
- Material UI
- `google_fonts`, `intl`, `shared_preferences`, `phosphor_flutter`

## Project Structure

- `lib/` app source code (features, routing, theme, shared UI)
- `android/`, `ios/`, `web/`, `windows/` platform runners
- `test/` unit/widget tests

## Getting Started

```bash
flutter pub get
flutter run
```

## Quality Checks

```bash
flutter analyze lib/main.dart lib/core lib/features --fatal-infos
flutter test
```

## Notes

- Repository is cleaned to keep only the Parichay candidate app surface.
