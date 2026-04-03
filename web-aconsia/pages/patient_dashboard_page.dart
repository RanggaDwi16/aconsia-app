import 'package:flutter/material.dart';
import '../models/patient.dart';
import '../services/storage_service.dart';

class PatientDashboardPage extends StatelessWidget {
  const PatientDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Patient? patient = StorageService.getCurrentPatient();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Pasien'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await StorageService.logout();
              if (context.mounted) {
                Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: patient == null
            ? const Center(child: Text('Data pasien tidak ditemukan.'))
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Nama: ${patient.namaLengkap}'),
                  const SizedBox(height: 8),
                  Text('MRN: ${patient.mrn}'),
                  const SizedBox(height: 8),
                  Text('Status: ${patient.status}'),
                  const SizedBox(height: 8),
                  Text('Skor Pemahaman: ${patient.comprehensionScore}%'),
                ],
              ),
      ),
    );
  }
}
