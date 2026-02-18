import 'package:parichay_candidate/core/theme/app_colors.dart';
import 'package:parichay_candidate/core/theme/app_radius.dart';
import 'package:parichay_candidate/core/theme/app_spacing.dart';
import 'package:parichay_candidate/core/theme/app_theme_extensions.dart';
import 'package:flutter/material.dart';

enum AppCardTone { surface, muted, outlined, elevated }

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
    this.tone = AppCardTone.surface,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final Gradient? gradient;
  final Color? backgroundColor;
  final Color? borderColor;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry margin;
  final AppCardTone tone;

  @override
  Widget build(BuildContext context) {
    final styles = context.surfaceStyles;
    final (resolvedColor, resolvedBorder, resolvedShadow) = switch (tone) {
      AppCardTone.muted => (
        backgroundColor ?? styles.mutedBackground,
        borderColor ?? styles.cardBorder,
        const <BoxShadow>[],
      ),
      AppCardTone.outlined => (
        backgroundColor ?? Colors.transparent,
        borderColor ?? styles.cardBorder,
        const <BoxShadow>[],
      ),
      AppCardTone.elevated => (
        backgroundColor ?? AppColors.surface,
        borderColor ?? styles.cardBorder,
        styles.cardShadow,
      ),
      AppCardTone.surface => (
        backgroundColor ?? AppColors.surface,
        borderColor ?? styles.cardBorder,
        const <BoxShadow>[],
      ),
    };

    final decoration = BoxDecoration(
      color: gradient == null ? resolvedColor : null,
      gradient: gradient,
      borderRadius: AppRadius.lgRadius,
      border: Border.all(color: resolvedBorder),
      boxShadow: gradient == null ? resolvedShadow : styles.cardShadow,
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
          borderRadius: AppRadius.lgRadius,
          onTap: onTap,
          child: cardChild,
        ),
      ),
    );
  }
}
