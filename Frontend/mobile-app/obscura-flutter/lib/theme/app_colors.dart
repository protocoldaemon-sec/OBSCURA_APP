import 'package:flutter/material.dart';

/// Obscura Vault Design System
/// Color palette: #000000, #52057B, #892CDC, #BC6FF1
class AppColors {
  AppColors._();

  // Nested structure
  static const background = _BackgroundColors();
  static const brand = _BrandColors();
  static const text = _TextColors();
  static const status = _StatusColors();
  static const border = _BorderColors();

  // Flat const values (for const contexts)
  static const textPrimary = Color(0xFFFFFFFF);
  static const textSecondary = Color(0xFFA1A1AA);
  static const textMuted = Color(0xFF71717A);
  static const brandPrimary = Color(0xFF892CDC);
  static const brandSecondary = Color(0xFF52057B);
  static const brandAccent = Color(0xFFBC6FF1);
  static const statusSuccess = Color(0xFF10B981);
  static const statusWarning = Color(0xFFF59E0B);
  static const statusError = Color(0xFFEF4444);
  static const backgroundPrimary = Color(0xFF000000);
  static const backgroundSecondary = Color(0xFF0A0A0F);
  static const backgroundTertiary = Color(0xFF121218);
  static const backgroundCard = Color(0xFF0D0D12);
  static const borderDefault = Color(0xFF1A1A24);
}

class _BackgroundColors {
  const _BackgroundColors();

  final Color primary = const Color(0xFF000000);
  final Color secondary = const Color(0xFF0A0A0F);
  final Color tertiary = const Color(0xFF121218);
  final Color card = const Color(0xFF0D0D12);
}

class _BrandColors {
  const _BrandColors();

  final Color primary = const Color(0xFF892CDC); // Main Purple
  final Color secondary = const Color(0xFF52057B); // Dark Purple
  final Color accent = const Color(0xFFBC6FF1); // Light Purple/Pink
  final Color dark = const Color(0xFF52057B);
}

class _TextColors {
  const _TextColors();

  final Color primary = const Color(0xFFFFFFFF);
  final Color secondary = const Color(0xFFA1A1AA);
  final Color muted = const Color(0xFF71717A);
  final Color accent = const Color(0xFFBC6FF1);
}

class _StatusColors {
  const _StatusColors();

  final Color success = const Color(0xFF10B981);
  final Color warning = const Color(0xFFF59E0B);
  final Color error = const Color(0xFFEF4444);
  final Color info = const Color(0xFF892CDC);
}

class _BorderColors {
  const _BorderColors();

  final Color default_ = const Color(0xFF1A1A24);
  final Color focus = const Color(0xFF892CDC);
}

