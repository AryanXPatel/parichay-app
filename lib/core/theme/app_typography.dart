import 'package:best_flutter_ui_templates/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTypography {
  const AppTypography._();

  // Keep Sora as requested while standardizing the scale.
  static TextTheme textTheme(TextTheme base) {
    final soraBase = GoogleFonts.soraTextTheme(base);
    return soraBase.copyWith(
      displaySmall: GoogleFonts.sora(
        fontSize: 30,
        fontWeight: FontWeight.w700,
        height: 1.15,
        color: AppColors.textPrimary,
      ),
      titleLarge: GoogleFonts.sora(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        height: 1.2,
        color: AppColors.textPrimary,
      ),
      titleMedium: GoogleFonts.sora(
        fontSize: 17,
        fontWeight: FontWeight.w600,
        height: 1.25,
        color: AppColors.textPrimary,
      ),
      bodyLarge: GoogleFonts.sora(
        fontSize: 15,
        fontWeight: FontWeight.w500,
        height: 1.4,
        color: AppColors.textSecondary,
      ),
      bodyMedium: GoogleFonts.sora(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        height: 1.35,
        color: AppColors.textSecondary,
      ),
      bodySmall: GoogleFonts.sora(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        height: 1.35,
        color: AppColors.textMuted,
      ),
      labelLarge: GoogleFonts.sora(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        height: 1.2,
        color: AppColors.textPrimary,
      ),
    );
  }
}
