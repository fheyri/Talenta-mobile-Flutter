import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/app_theme.dart';
import '../providers/auth_provider.dart';

/// Halaman sementara setelah login berhasil.
/// Ganti dengan dashboard siswa/alumni yang sebenarnya.
class HomePlaceholder extends StatelessWidget {
  const HomePlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = auth.user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('TALENTA'),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.navy,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Halo, ${user?.name ?? '-'}',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: AppColors.navy,
              ),
            ),
            const SizedBox(height: 8),
            Text('Peran: ${user?.role ?? '-'}'),
            Text('E-mail: ${user?.email ?? '-'}'),
            Text('Saldo token: ${user?.tokenBalance ?? 0}'),
            const SizedBox(height: 24),
            const Text('Login berhasil. Halaman ini hanya placeholder.'),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 46,
              child: OutlinedButton(
                onPressed: () => context.read<AuthProvider>().logout(),
                child: const Text('Keluar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
