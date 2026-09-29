import 'package:flutter/material.dart';

import '../../../core/app_theme.dart';

class CareerMonitoringScreen extends StatelessWidget {
  const CareerMonitoringScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Career Monitoring'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            color: Colors.indigo.shade50,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Tracer Study & Jejak Karier', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  SizedBox(height: 6),
                  Text('Data kariermu membantu sekolah dan adik tingkat memetakan kebutuhan industri.'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text('Riwayat Pekerjaan & Karier', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Card(
            child: ListTile(
              leading: CircleAvatar(child: Icon(Icons.work)),
              title: Text('Software Engineer - PT Unicorn'),
              subtitle: Text('2022 - Sekarang (Fulltime)'),
            ),
          ),
        ],
      ),
    );
  }
}
