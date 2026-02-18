# Repository Guidelines

## Project Structure & Module Organization
- App entrypoint: `lib/main.dart`.
- Shared platform-independent code lives in `lib/core/`:
  - `router/`, `services/`, `repositories/`, `theme/`, `ui/`.
- Product features live in `lib/features/<feature>/presentation/`.
- Localization files are in `lib/l10n/`.
- Tests mirror runtime structure:
  - `test/core/...`
  - `test/features/...`
  - `test/widget_test.dart`
- Platform runners are in `android/`, `ios/`, `web/`, and `windows/`.

## Build, Test, and Development Commands
- `flutter pub get`  
  Installs dependencies and refreshes `pubspec.lock`.
- `flutter run`  
  Runs the app on the selected emulator/device.
- `flutter analyze --fatal-infos`  
  Full strict lint + static analysis pass (CI-friendly).
- `flutter analyze lib/main.dart lib/core lib/features --fatal-infos`  
  Focused strict analysis for core product code.
- `flutter test`  
  Runs unit and widget tests.

## Coding Style & Naming Conventions
- Lint rules come from `analysis_options.yaml` (`flutter_lints`).
- Use standard Dart formatting and 2-space indentation.
- Naming:
  - Files: `lower_snake_case.dart`
  - Classes/widgets: `UpperCamelCase`
  - Methods/fields/variables: `lowerCamelCase`
- Prefer package imports: `package:parichay_candidate/...`.
- Keep reusable UI primitives in `lib/core/ui/`; use centralized icons in `AppIcons`.

## Testing Guidelines
- Framework: `flutter_test`.
- Place tests in the matching domain folder (`core` vs `features`).
- Test names should describe behavior (example: `"successful OTP verification routes to welcome"`).
- For UI/routing changes, add or update widget tests under `test/features/...`.

## Commit & Pull Request Guidelines
- Follow concise, typed commit subjects seen in history:
  - `refactor: ...`, `chore: ...`, `ci: ...`
- Keep commits scoped and atomic; avoid mixing unrelated concerns.
- PRs should include:
  - What changed and why
  - Affected paths/modules
  - Validation evidence (`flutter analyze --fatal-infos`, `flutter test`)
  - Screenshots/video for user-visible UI changes

## Configuration Notes
- Final production platform IDs should be updated before release (see `todo.md`).
- Do not commit local scratch artifacts such as `output.txt`.

## Serena & Tooling Workflow
- If a task matches an installed skill, use that skill first (`SKILL.md` workflow), then implement.
- Use Serena as the default code-navigation layer:
  - Start with `list_dir` / `get_symbols_overview`.
  - Use `find_symbol` and `find_referencing_symbols` for precise edits.
  - Use `search_for_pattern` for targeted lookups; avoid unnecessary full-file reads.
- Prefer MCP/context tools for docs and code intelligence before general web search.
- Use shell commands for verification (`flutter pub get`, `flutter analyze --fatal-infos`, `flutter test`) and summarize results in PRs.
- Prefer `apply_patch` for focused text edits; keep changes atomic.
- Avoid destructive commands (`git reset --hard`, `git checkout --`) unless explicitly requested.
