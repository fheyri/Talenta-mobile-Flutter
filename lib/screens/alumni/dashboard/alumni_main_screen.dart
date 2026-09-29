import 'package:flutter/material.dart';

import '../../../core/app_theme.dart';
import '../../siswa/notifikasi/notifikasi_screen.dart';
import '../career/career_monitoring_screen.dart';
import '../mentoring/alumni_mentoring_screen.dart';
import '../profil/alumni_profil_screen.dart';

class AlumniMainScreen extends StatefulWidget {
  const AlumniMainScreen({super.key});

  @override
  State<AlumniMainScreen> createState() => _AlumniMainScreenState();
}

class _AlumniMainScreenState extends State<AlumniMainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    CareerMonitoringScreen(),
    AlumniMentoringScreen(),
    NotifikasiScreen(),
    AlumniProfilScreen(),
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
          BottomNavigationBarItem(icon: Icon(Icons.trending_up), label: 'Karier'),
          BottomNavigationBarItem(icon: Icon(Icons.people_outline), activeIcon: Icon(Icons.people), label: 'Mentoring'),
          BottomNavigationBarItem(icon: Icon(Icons.notifications_none), activeIcon: Icon(Icons.notifications), label: 'Notifikasi'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }
}
