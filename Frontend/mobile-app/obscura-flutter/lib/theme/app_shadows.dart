import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppShadows {
  AppShadows._();

  static const sm = BoxShadow(
    color: Color(0x0A000000),
    offset: Offset(0, 1),
    blurRadius: 2,
  );

  static const md = BoxShadow(
    color: Color(0x0A000000),
    offset: Offset(0, 4),
    blurRadius: 6,
  );

  static const lg = BoxShadow(
    color: Color(0x0F000000),
    offset: Offset(0, 10),
    blurRadius: 15,
  );

  static const glow = BoxShadow(
    color: AppColors.brandPrimary,
    offset: Offset(0, 0),
    blurRadius: 20,
    spreadRadius: -5,
  );

  // Note: Flutter BoxShadow doesn't support inset shadows natively
  // For inner shadow effect, consider using a Container with custom painting
  static const inner = BoxShadow(
    color: Color(0x05000000),
    offset: Offset(0, 1),
    blurRadius: 2,
  );
}
