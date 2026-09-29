import 'package:flutter/material.dart';

import '../../../core/app_theme.dart';

class PsikotesScreen extends StatelessWidget {
  const PsikotesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Psikotes Kesiapan Kerja'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Banner Info
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.blue.shade100),
            ),
            child: const Row(
              children: [
                Icon(Icons.psychology, size: 40, color: AppColors.primary),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Uji Potensi & Minat Bakat', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      SizedBox(height: 4),
                      Text('3x Percobaan pertama GRATIS. Durasi pengerjaan 120 menit per sesi.', style: TextStyle(fontSize: 12, color: Colors.black87)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text('Daftar Tes Tersedia', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          _buildTestCard(
            context,
            title: 'Tes Kepribadian & Minat Karier (RIASEC)',
            duration: '120 Menit',
            soalCount: '60 Soal',
            category: 'Karier',
          ),
          _buildTestCard(
            context,
            title: 'Tes Kemampuan Logika & Penalaran',
            duration: '90 Menit',
            soalCount: '45 Soal',
            category: 'Kognitif',
          ),
        ],
      ),
    );
  }

  Widget _buildTestCard(
    BuildContext context, {
    required String title,
    required String duration,
    required String soalCount,
    required String category,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Chip(label: Text(category, style: const TextStyle(fontSize: 11)), backgroundColor: Colors.amber.shade50),
            Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.timer_outlined, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(duration, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                const SizedBox(width: 16),
                const Icon(Icons.help_outline, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(soalCount, style: const TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Mulai Tes via API: POST /api/v1/psikotes/{id}/start
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('Mulai Tes Sekarang'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
