import 'package:flutter/material.dart';

class AppColors {
  // Warna Utama dari Desain Figma
  static const primary = Color(0xFF315EE8);
  static const primaryGradientStart = Color(0xFF2F5FE6); // Kiri bawah
  static const primaryGradientEnd = Color(0xFF438EF5);   // Kanan atas
  static const navy = Color(0xFF052C66);
  static const border = Color(0xFFD6DFF0);
  static const borderLight = Color(0xFFE5E7EB);
  static const hint = Color(0xFF8A94A6);
  static const greyButton = Color(0xFFDEDEDE);
  static const greyButtonText = Color(0xFF315EE8);
  static const circleIconBg = Color(0xFFDCEBFC);
  static const cardBorderPurple = Color(0xFFE9D5FF); // Border ungu muda untuk Alumni
  static const error = Color(0xFFD64545);
}

ThemeData buildTheme() {
  return ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
    scaffoldBackgroundColor: Colors.white,
  );
}
