import 'package:best_flutter_ui_templates/core/theme/app_colors.dart';
import 'package:best_flutter_ui_templates/core/theme/app_spacing.dart';
import 'package:best_flutter_ui_templates/core/ui/app_card.dart';
import 'package:best_flutter_ui_templates/core/ui/app_status_chip.dart';
import 'package:flutter/material.dart';

class AppMetricCard extends StatelessWidget {
  const AppMetricCard({
    super.key,
    required this.label,
    required this.value,
    this.hint,
    this.icon,
    this.tone = AppStatusTone.neutral,
  });

  final String label;
  final String value;
  final String? hint;
  final IconData? icon;
  final AppStatusTone tone;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) ...[
            Container(
              padding: const EdgeInsets.all(AppSpacing.xs),
              decoration: BoxDecoration(
                color: AppColors.brand50,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 18, color: AppColors.brand700),
            ),
            const SizedBox(height: AppSpacing.sm),
          ],
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          if (hint != null) ...[
            const SizedBox(height: AppSpacing.sm),
            AppStatusChip(
              label: hint!,
              tone: tone,
            ),
          ],
        ],
      ),
    );
  }
}
