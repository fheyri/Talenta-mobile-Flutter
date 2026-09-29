import 'package:flutter/material.dart';

import '../../../core/app_theme.dart';
import '../lowongan/lowongan_screen.dart';
import '../mentoring/mentoring_screen.dart';
import '../notifikasi/notifikasi_screen.dart';
import '../profil/siswa_profil_screen.dart';
import '../psikotes/psikotes_screen.dart';
import '../riwayat/riwayat_screen.dart';

class SiswaMainScreen extends StatefulWidget {
  const SiswaMainScreen({super.key});

  @override
  State<SiswaMainScreen> createState() => _SiswaMainScreenState();
}

class _SiswaMainScreenState extends State<SiswaMainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    LowonganScreen(),
    PsikotesScreen(),
    MentoringScreen(),
    RiwayatScreen(),
    NotifikasiScreen(),
    SiswaProfilScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.work_outline), activeIcon: Icon(Icons.work), label: 'Lowongan'),
          BottomNavigationBarItem(icon: Icon(Icons.psychology_outlined), activeIcon: Icon(Icons.psychology), label: 'Psikotes'),
          BottomNavigationBarItem(icon: Icon(Icons.supervisor_account_outlined), activeIcon: Icon(Icons.supervisor_account), label: 'Mentoring'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Riwayat'),
          BottomNavigationBarItem(icon: Icon(Icons.notifications_none), activeIcon: Icon(Icons.notifications), label: 'Notifikasi'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }
}
