import 'package:parichay_candidate/core/theme/app_colors.dart';
import 'package:parichay_candidate/core/theme/app_radius.dart';
import 'package:parichay_candidate/core/theme/app_spacing.dart';
import 'package:parichay_candidate/core/theme/app_theme_extensions.dart';
import 'package:flutter/material.dart';

class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.md),
    this.gradient,
    this.backgroundColor,
    this.borderColor,
    this.onTap,
    this.margin = EdgeInsets.zero,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final Gradient? gradient;
  final Color? backgroundColor;
  final Color? borderColor;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry margin;

  @override
  Widget build(BuildContext context) {
    final styles = context.surfaceStyles;
    final decoration = BoxDecoration(
      color: gradient == null ? (backgroundColor ?? AppColors.surface) : null,
      gradient: gradient,
      borderRadius: AppRadius.mdRadius,
      border: Border.all(color: borderColor ?? styles.cardBorder),
      boxShadow: styles.cardShadow,
    );

    final cardChild = Container(
      decoration: decoration,
      padding: padding,
      child: child,
    );

    if (onTap == null) {
      return Padding(padding: margin, child: cardChild);
    }

    return Padding(
      padding: margin,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: AppRadius.mdRadius,
          onTap: onTap,
          child: cardChild,
        ),
      ),
    );
  }
}
