import 'package:parichay_candidate/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class AppGradients {
  const AppGradients._();

  static const LinearGradient hero = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppColors.brand500, AppColors.brand800],
  );

  static const LinearGradient wallet = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppColors.brand400, AppColors.brand700],
  );

  static const LinearGradient spotlight = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFF8F5EE), AppColors.background, Color(0xFFEAE5D9)],
  );
}
