import 'package:best_flutter_ui_templates/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class AppGradients {
  const AppGradients._();

  static const LinearGradient hero = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppColors.brand600, AppColors.brand800],
  );

  static const LinearGradient wallet = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppColors.brand500, AppColors.brand700],
  );

  static const LinearGradient spotlight = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [AppColors.brand700, AppColors.brand900],
  );
}
