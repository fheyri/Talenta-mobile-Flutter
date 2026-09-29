import 'package:flutter/material.dart';

import '../../../core/app_theme.dart';

class AlumniMentoringScreen extends StatelessWidget {
  const AlumniMentoringScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mentoring Alumni'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Permintaan Mentoring Masuk', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          _buildRequestCard(
            context,
            siswaName: 'Budi Santoso',
            jurusan: 'Kelas XII - RPL',
            topic: 'Persiapan portofolio & tips interview magang',
          ),
          const SizedBox(height: 20),
          const Text('Sesi Mentoring Aktif', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Card(
            child: ListTile(
              leading: CircleAvatar(child: Icon(Icons.chat, color: AppColors.primary)),
              title: Text('Sesi dengan Siti Aminah'),
              subtitle: Text('Jadwal: Besok, 16:00 WIB (Online)'),
              trailing: Icon(Icons.chevron_right),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRequestCard(BuildContext context, {required String siswaName, required String jurusan, required String topic}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(backgroundColor: Colors.blue.shade50, child: const Icon(Icons.school, color: AppColors.primary)),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(siswaName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    Text(jurusan, style: const TextStyle(color: Colors.grey, fontSize: 13)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text('Topik: "$topic"', style: const TextStyle(fontStyle: FontStyle.italic)),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    child: const Text('Tolak', style: TextStyle(color: Colors.red)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
                    child: const Text('Terima'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
