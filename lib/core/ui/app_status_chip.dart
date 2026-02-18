import 'package:parichay_candidate/core/theme/app_radius.dart';
import 'package:parichay_candidate/core/theme/app_spacing.dart';
import 'package:parichay_candidate/core/theme/app_theme_extensions.dart';
import 'package:flutter/material.dart';

enum AppStatusTone { neutral, info, success, warning, danger }

class AppStatusChip extends StatelessWidget {
  const AppStatusChip({
    super.key,
    required this.label,
    this.tone = AppStatusTone.neutral,
  });

  final String label;
  final AppStatusTone tone;

  @override
  Widget build(BuildContext context) {
    final status = context.statusStyles;
    final (fg, bg) = switch (tone) {
      AppStatusTone.info => (status.info, status.infoSubtle),
      AppStatusTone.success => (status.success, status.successSubtle),
      AppStatusTone.warning => (status.warning, status.warningSubtle),
      AppStatusTone.danger => (status.danger, status.dangerSubtle),
      AppStatusTone.neutral => (
          Theme.of(context).colorScheme.onSurfaceVariant,
          Theme.of(context).colorScheme.surfaceContainerHighest,
        ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: AppRadius.pillRadius,
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: fg,
              fontWeight: FontWeight.w700,
            ),
      ),
    );
  }
}
