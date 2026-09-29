import 'package:flutter/material.dart';

import '../../../core/app_theme.dart';

class MentoringScreen extends StatelessWidget {
  const MentoringScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Career Mentoring'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Temukan Mentor dari Alumni', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          const Text('Konsultasikan persiapan karier, CV, dan dunia kerja.', style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 16),
          _buildMentorCard(
            context,
            name: 'Rian Pratama, S.Kom',
            role: 'Software Engineer di Unicorn Tech',
            alumniTahun: 'Alumni 2021',
            status: 'Tersedia',
          ),
          _buildMentorCard(
            context,
            name: 'Siti Rahmawati',
            role: 'Product Specialist di BUMN',
            alumniTahun: 'Alumni 2020',
            status: 'Tersedia',
          ),
        ],
      ),
    );
  }

  Widget _buildMentorCard(
    BuildContext context, {
    required String name,
    required String role,
    required String alumniTahun,
    required String status,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: AppColors.primary.withOpacity(0.1),
                  child: const Icon(Icons.person, color: AppColors.primary, size: 30),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      Text(role, style: const TextStyle(color: Colors.grey, fontSize: 13)),
                      const SizedBox(height: 4),
                      Text(alumniTahun, style: TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  // Ajukan sesi mentoring
                },
                icon: const Icon(Icons.calendar_today, size: 16),
                label: const Text('Ajukan Sesi Mentoring'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
