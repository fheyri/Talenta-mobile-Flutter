import 'package:flutter/material.dart';

import '../../../core/app_theme.dart';

class NotifikasiScreen extends StatelessWidget {
  const NotifikasiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifikasi & Pengumuman'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          Card(
            child: ListTile(
              leading: CircleAvatar(child: Icon(Icons.notifications_active, color: AppColors.primary)),
              title: Text('Lowongan Baru Cocok untuk Jurusanmu'),
              subtitle: Text('PT Talenta Digital membuka posisi Junior Developer.'),
              trailing: Text('Baru', style: TextStyle(color: Colors.blue, fontSize: 12)),
            ),
          ),
          Card(
            child: ListTile(
              leading: CircleAvatar(child: Icon(Icons.event, color: Colors.orange)),
              title: Text('Jadwal Tes Psikotes Kesiapan Kerja'),
              subtitle: Text('Batas tes tahap 1 berakhir dalam 3 hari.'),
              trailing: Text('Kemarin', style: TextStyle(color: Colors.grey, fontSize: 12)),
            ),
          ),
        ],
      ),
    );
  }
}
