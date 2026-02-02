import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  static const String fontFamily = 'Inter';

  static const h1 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    height: 40 / 32,
    color: AppColors.textPrimary,
    fontFamily: fontFamily,
  );

  static const h2 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 32 / 24,
    color: AppColors.textPrimary,
    fontFamily: fontFamily,
  );

  static const h3 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 28 / 20,
    color: AppColors.textPrimary,
    fontFamily: fontFamily,
  );

  static const body = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 24 / 16,
    color: AppColors.textPrimary,
    fontFamily: fontFamily,
  );

  static const caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 16 / 12,
    color: AppColors.textMuted,
    fontFamily: fontFamily,
  );

  static const label = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 20 / 14,
    color: AppColors.textSecondary,
    fontFamily: fontFamily,
  );

  static const button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 24 / 16,
    fontFamily: fontFamily,
  );

  static const monospace = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 20 / 14,
    color: AppColors.textPrimary,
    fontFamily: 'Courier',
  );
}

