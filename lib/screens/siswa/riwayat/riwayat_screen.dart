import 'package:flutter/material.dart';

import '../../../core/app_theme.dart';

class RiwayatScreen extends StatelessWidget {
  const RiwayatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Riwayat Aktivitas'),
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          bottom: const TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.white,
            tabs: [
              Tab(text: 'Psikotes'),
              Tab(text: 'Lowongan'),
              Tab(text: 'Mentoring'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Riwayat Psikotes
            ListView(
              padding: const EdgeInsets.all(16),
              children: const [
                ListTile(
                  leading: CircleAvatar(child: Icon(Icons.check, color: Colors.green)),
                  title: Text('Tes Kepribadian RIASEC'),
                  subtitle: Text('Selesai pada 20 Sep 2026 - Skor: 85'),
                  trailing: Icon(Icons.chevron_right),
                ),
              ],
            ),
            // Riwayat Lowongan
            ListView(
              padding: const EdgeInsets.all(16),
              children: const [
                ListTile(
                  leading: CircleAvatar(child: Icon(Icons.work)),
                  title: Text('Junior Flutter Developer'),
                  subtitle: Text('Status: Dilamar pada 18 Sep 2026'),
                ),
              ],
            ),
            // Riwayat Mentoring
            ListView(
              padding: const EdgeInsets.all(16),
              children: const [
                ListTile(
                  leading: CircleAvatar(child: Icon(Icons.forum)),
                  title: Text('Sesi dengan Rian Pratama'),
                  subtitle: Text('Status: Selesai'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
