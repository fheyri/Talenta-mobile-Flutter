import 'package:flutter/material.dart';

class AppColors {
  static const primary = Color(0xFF2F63E8);
  static const primaryLight = Color(0xFF4A86F0);
  static const navy = Color(0xFF0F2A55);
  static const border = Color(0xFFD6DFF0);
  static const hint = Color(0xFF8A94A6);
  static const greyButton = Color(0xFFE3E5E8);
  static const error = Color(0xFFD64545);
}

ThemeData buildTheme() {
  return ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
    scaffoldBackgroundColor: Colors.white,
  );
}
