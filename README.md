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
- `google_fonts`, `animations`, `intl`, `font_awesome_flutter`

## Project Structure

- `lib/` app source code (features, routing, theme, shared UI)
- `assets/` images and fonts used by the app
- `android/`, `ios/`, `web/`, `windows/` platform runners
- `test/` unit/widget tests

## Getting Started

```bash
flutter pub get
flutter run
```

## Quality Checks

```bash
flutter analyze
flutter test
```

## Notes

- Repository was cleaned to keep only the Flutter app (legacy template artifacts removed).
