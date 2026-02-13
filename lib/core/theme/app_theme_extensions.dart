import 'package:best_flutter_ui_templates/core/theme/app_colors.dart';
import 'package:best_flutter_ui_templates/core/theme/app_gradients.dart';
import 'package:best_flutter_ui_templates/core/theme/app_shadows.dart';
import 'package:flutter/material.dart';

class AppSurfaceStyles extends ThemeExtension<AppSurfaceStyles> {
  const AppSurfaceStyles({
    required this.cardBorder,
    required this.mutedBackground,
    required this.heroGradient,
    required this.walletGradient,
    required this.cardShadow,
  });

  final Color cardBorder;
  final Color mutedBackground;
  final Gradient heroGradient;
  final Gradient walletGradient;
  final List<BoxShadow> cardShadow;

  static const AppSurfaceStyles light = AppSurfaceStyles(
    cardBorder: AppColors.border,
    mutedBackground: AppColors.mutedSurface,
    heroGradient: AppGradients.hero,
    walletGradient: AppGradients.wallet,
    cardShadow: AppShadows.card,
  );

  @override
  AppSurfaceStyles copyWith({
    Color? cardBorder,
    Color? mutedBackground,
    Gradient? heroGradient,
    Gradient? walletGradient,
    List<BoxShadow>? cardShadow,
  }) {
    return AppSurfaceStyles(
      cardBorder: cardBorder ?? this.cardBorder,
      mutedBackground: mutedBackground ?? this.mutedBackground,
      heroGradient: heroGradient ?? this.heroGradient,
      walletGradient: walletGradient ?? this.walletGradient,
      cardShadow: cardShadow ?? this.cardShadow,
    );
  }

  @override
  AppSurfaceStyles lerp(ThemeExtension<AppSurfaceStyles>? other, double t) {
    if (other is! AppSurfaceStyles) {
      return this;
    }
    return AppSurfaceStyles(
      cardBorder: Color.lerp(cardBorder, other.cardBorder, t) ?? cardBorder,
      mutedBackground:
          Color.lerp(mutedBackground, other.mutedBackground, t) ?? mutedBackground,
      heroGradient: Gradient.lerp(heroGradient, other.heroGradient, t) ?? heroGradient,
      walletGradient:
          Gradient.lerp(walletGradient, other.walletGradient, t) ?? walletGradient,
      cardShadow: t < 0.5 ? cardShadow : other.cardShadow,
    );
  }
}

class AppStatusStyles extends ThemeExtension<AppStatusStyles> {
  const AppStatusStyles({
    required this.success,
    required this.warning,
    required this.danger,
    required this.info,
    required this.successSubtle,
    required this.warningSubtle,
    required this.dangerSubtle,
    required this.infoSubtle,
  });

  final Color success;
  final Color warning;
  final Color danger;
  final Color info;
  final Color successSubtle;
  final Color warningSubtle;
  final Color dangerSubtle;
  final Color infoSubtle;

  static const AppStatusStyles light = AppStatusStyles(
    success: AppColors.success,
    warning: AppColors.warning,
    danger: AppColors.danger,
    info: AppColors.info,
    successSubtle: AppColors.successSubtle,
    warningSubtle: AppColors.warningSubtle,
    dangerSubtle: AppColors.dangerSubtle,
    infoSubtle: AppColors.infoSubtle,
  );

  @override
  AppStatusStyles copyWith({
    Color? success,
    Color? warning,
    Color? danger,
    Color? info,
    Color? successSubtle,
    Color? warningSubtle,
    Color? dangerSubtle,
    Color? infoSubtle,
  }) {
    return AppStatusStyles(
      success: success ?? this.success,
      warning: warning ?? this.warning,
      danger: danger ?? this.danger,
      info: info ?? this.info,
      successSubtle: successSubtle ?? this.successSubtle,
      warningSubtle: warningSubtle ?? this.warningSubtle,
      dangerSubtle: dangerSubtle ?? this.dangerSubtle,
      infoSubtle: infoSubtle ?? this.infoSubtle,
    );
  }

  @override
  AppStatusStyles lerp(ThemeExtension<AppStatusStyles>? other, double t) {
    if (other is! AppStatusStyles) {
      return this;
    }
    return AppStatusStyles(
      success: Color.lerp(success, other.success, t) ?? success,
      warning: Color.lerp(warning, other.warning, t) ?? warning,
      danger: Color.lerp(danger, other.danger, t) ?? danger,
      info: Color.lerp(info, other.info, t) ?? info,
      successSubtle: Color.lerp(successSubtle, other.successSubtle, t) ?? successSubtle,
      warningSubtle: Color.lerp(warningSubtle, other.warningSubtle, t) ?? warningSubtle,
      dangerSubtle: Color.lerp(dangerSubtle, other.dangerSubtle, t) ?? dangerSubtle,
      infoSubtle: Color.lerp(infoSubtle, other.infoSubtle, t) ?? infoSubtle,
    );
  }
}

extension AppThemeContext on BuildContext {
  AppSurfaceStyles get surfaceStyles =>
      Theme.of(this).extension<AppSurfaceStyles>() ?? AppSurfaceStyles.light;

  AppStatusStyles get statusStyles =>
      Theme.of(this).extension<AppStatusStyles>() ?? AppStatusStyles.light;
}
