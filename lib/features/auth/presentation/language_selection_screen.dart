import 'package:parichay_candidate/core/router/app_routes.dart';
import 'package:parichay_candidate/core/services/app_services.dart';
import 'package:parichay_candidate/core/theme/app_spacing.dart';
import 'package:parichay_candidate/core/ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:parichay_candidate/features/auth/presentation/auth_shell.dart';
import 'package:parichay_candidate/l10n/app_localizations.dart';

class LanguageSelectionScreen extends StatefulWidget {
  const LanguageSelectionScreen({super.key});

  @override
  State<LanguageSelectionScreen> createState() =>
      _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  Locale? _selected;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _selected = AppServices.instance.localeNotifier.value;
  }

  Future<void> _continue() async {
    if (_selected == null || _busy) {
      return;
    }
    setState(() {
      _busy = true;
    });

    await AppServices.instance.setLocale(_selected!);

    if (!mounted) {
      return;
    }
    Navigator.of(context).pushReplacementNamed(AppRoutes.signIn);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AuthShell(
      maxWidth: 440,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppSectionHeader(
            title: l10n.languageTitle,
            subtitle: l10n.languageSubtitle,
          ),
          const SizedBox(height: AppSpacing.md),
          _LanguageTile(
            title: l10n.languageEnglish,
            selected: _selected?.languageCode == 'en',
            onTap: () => setState(() => _selected = const Locale('en')),
          ),
          const SizedBox(height: AppSpacing.sm),
          _LanguageTile(
            title: l10n.languageHindi,
            selected: _selected?.languageCode == 'hi',
            onTap: () => setState(() => _selected = const Locale('hi')),
          ),
          const SizedBox(height: AppSpacing.md),
          AppPrimaryButton(
            label: l10n.languageContinue,
            icon: AppIcons.arrowRight,
            isLoading: _busy,
            onPressed: _selected == null ? null : _continue,
          ),
        ],
      ),
    );
  }
}

class _LanguageTile extends StatelessWidget {
  const _LanguageTile({
    required this.title,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: selected
              ? Theme.of(context).colorScheme.primaryContainer
              : Theme.of(context).colorScheme.surface,
          border: Border.all(
            color: selected
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).dividerColor,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            Icon(
              selected ? AppIcons.check : AppIcons.circle,
              color: selected
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).disabledColor,
            ),
          ],
        ),
      ),
    );
  }
}
