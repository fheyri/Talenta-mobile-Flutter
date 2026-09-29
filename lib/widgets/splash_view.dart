import 'package:flutter/material.dart';

import '../core/app_theme.dart';

/// Tampilan logo. Dipakai saat aplikasi mengecek sesi login.
class SplashView extends StatelessWidget {
  const SplashView({super.key, this.showLoader = true});

  final bool showLoader;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/images/logo.png', width: 110),
            const SizedBox(height: 16),
            Image.asset('assets/images/logo_text.png', width: 132),
            const SizedBox(height: 32),
            if (showLoader)
              const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: AppColors.primary,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
