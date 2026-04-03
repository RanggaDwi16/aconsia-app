import 'package:flutter/material.dart';
import '../models/doctor.dart';
import '../models/patient.dart';
import '../services/storage_service.dart';

class DoctorDashboardPage extends StatefulWidget {
  const DoctorDashboardPage({super.key});

  @override
  State<DoctorDashboardPage> createState() => _DoctorDashboardPageState();
}

class _DoctorDashboardPageState extends State<DoctorDashboardPage> {
  List<Patient> _patients = [];
  Doctor? _doctor;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final patients = await StorageService.getPatients();
    setState(() {
      _doctor = StorageService.getCurrentDoctor();
      _patients = patients;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            'Dashboard Dokter${_doctor != null ? ' - ${_doctor!.namaLengkap}' : ''}'),
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
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _patients.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          final p = _patients[index];
          return ListTile(
            tileColor: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            title: Text(p.namaLengkap),
            subtitle: Text('MRN: ${p.mrn} • Status: ${p.status}'),
            trailing: Text('${p.comprehensionScore}%'),
          );
        },
      ),
    );
  }
}
