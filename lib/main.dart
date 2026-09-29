import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/app_theme.dart';
import 'providers/auth_provider.dart';
import 'screens/alumni/dashboard/alumni_main_screen.dart';
import 'screens/login_screen.dart';
import 'screens/offline_screen.dart';
import 'screens/siswa/dashboard/siswa_main_screen.dart';
import 'services/auth_service.dart';
import 'services/token_storage.dart';
import 'widgets/splash_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const TalentaApp());
}

class TalentaApp extends StatelessWidget {
  const TalentaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthProvider(AuthService(), TokenStorage())..bootstrap(),
      child: MaterialApp(
        title: 'TALENTA',
        debugShowCheckedModeBanner: false,
        theme: buildTheme(),
        home: const AuthGate(),
      ),
    );
  }
}

/// Menentukan halaman awal berdasarkan status login dan role pengguna.
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final status = auth.status;
    final user = auth.user;

    switch (status) {
      case AuthStatus.unknown:
        return const SplashView();
      case AuthStatus.authenticated:
        if (user?.role == 'alumni') {
          return const AlumniMainScreen();
        }
        return const SiswaMainScreen();
      case AuthStatus.offline:
        return const OfflineScreen();
      case AuthStatus.unauthenticated:
        return const LoginScreen();
    }
  }
}
