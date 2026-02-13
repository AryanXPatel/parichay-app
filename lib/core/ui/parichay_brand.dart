import 'package:best_flutter_ui_templates/core/theme/app_colors.dart';
import 'package:best_flutter_ui_templates/core/theme/app_radius.dart';
import 'package:best_flutter_ui_templates/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';

class ParichayBrandMark extends StatelessWidget {
  const ParichayBrandMark({
    super.key,
    this.compact = false,
    this.iconSize = 20,
  });

  final bool compact;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    final brand = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: iconSize + 12,
          height: iconSize + 12,
          decoration: const BoxDecoration(
            color: AppColors.brand600,
            borderRadius: AppRadius.smRadius,
          ),
          child: Icon(
            Icons.person_search_rounded,
            size: iconSize,
            color: Colors.white,
          ),
        ),
        const SizedBox(width: AppSpacing.xs),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Parichay',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            if (!compact)
              Text(
                'Real Jobs. Real People.',
                style: Theme.of(context).textTheme.bodySmall,
              ),
          ],
        ),
      ],
    );

    return Semantics(
      label: 'Parichay brand mark',
      child: brand,
    );
  }
}
