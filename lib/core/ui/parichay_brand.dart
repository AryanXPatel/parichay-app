import 'package:parichay_candidate/core/theme/app_colors.dart';
import 'package:parichay_candidate/core/theme/app_radius.dart';
import 'package:parichay_candidate/core/theme/app_spacing.dart';
import 'package:parichay_candidate/core/ui/app_icons.dart';
import 'package:flutter/material.dart';

class ParichayBrandMark extends StatelessWidget {
  const ParichayBrandMark({
    super.key,
    this.compact = false,
    this.iconSize = 20,
    this.inverse = false,
  });

  final bool compact;
  final double iconSize;
  final bool inverse;

  @override
  Widget build(BuildContext context) {
    final titleColor = inverse ? AppColors.slate50 : AppColors.textPrimary;
    final subtitleColor = inverse ? AppColors.brand200 : AppColors.textMuted;
    final tileColor = inverse ? AppColors.brand300 : AppColors.brand600;

    final brand = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: iconSize + 12,
          height: iconSize + 12,
          decoration: BoxDecoration(
            color: tileColor,
            borderRadius: AppRadius.smRadius,
          ),
          child: Icon(
            AppIcons.brand,
            size: iconSize,
            color: AppColors.textOnBrand,
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
                color: titleColor,
              ),
            ),
            if (!compact)
              Text(
                'Real Jobs. Real People.',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: subtitleColor),
              ),
          ],
        ),
      ],
    );

    return Semantics(label: 'Parichay brand mark', child: brand);
  }
}
