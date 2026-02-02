import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppGradients {
  AppGradients._();

  static const primary = LinearGradient(
    colors: [
      AppColors.brandSecondary,
      AppColors.brandPrimary,
    ],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const secondary = LinearGradient(
    colors: [
      AppColors.brandPrimary,
      AppColors.brandAccent,
    ],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const accent = LinearGradient(
    colors: [
      AppColors.brandSecondary,
      AppColors.brandPrimary,
      AppColors.brandAccent,
    ],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const purpleToBlue = LinearGradient(
    colors: [
      Color(0xFF8B5CF6),
      Color(0xFF6366F1),
    ],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const blueToLightBlue = LinearGradient(
    colors: [
      Color(0xFF6366F1),
      Color(0xFF3B82F6),
    ],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const cardGradient = LinearGradient(
    colors: [
      Color(0x228B5CF6), // rgba(139, 92, 246, 0.2)
      Color(0x116366F1), // rgba(99, 102, 241, 0.1)
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
