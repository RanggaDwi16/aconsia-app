import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/patient.dart';
import 'models/doctor.dart';

class StorageService {
  static SharedPreferences? _prefs;

  // Initialize
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    await _initDemoData();
  }

  // Initialize demo data
  static Future<void> _initDemoData() async {
    final initialized = _prefs?.getBool('demoInitialized') ?? false;

    if (!initialized) {
      // Create demo doctor
      final demoDoctor = Doctor(
        id: 'DOC001',
        namaLengkap: 'Ahmad Fauzi',
        email: 'dokter@aconsia.com',
        password: 'dokter123',
        nomorSTR: 'STR123456789',
        spesialisasi: 'Anestesiologi',
        rumahSakit: 'RS Umum Pusat',
        createdAt: DateTime.now().toIso8601String(),
      );

      // Create demo patient
      final demoPatient = Patient(
        mrn: 'MRN001',
        namaLengkap: 'Budi Santoso',
        nomorTelepon: '081234567890',
        email: 'budi@email.com',
        status: 'pending',
        createdAt: DateTime.now().toIso8601String(),
      );

      await saveDoctors([demoDoctor]);
      await savePatients([demoPatient]);
      await _prefs?.setBool('demoInitialized', true);

      print('✅ Demo data initialized!');
      print('📧 Doctor: dokter@aconsia.com / dokter123');
      print('🏥 Patient: MRN001');
    }
  }

  // ========== DOCTORS ==========

  // Get all doctors
  static Future<List<Doctor>> getDoctors() async {
    final jsonString = _prefs?.getString('doctors') ?? '[]';
    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.map((json) => Doctor.fromJson(json)).toList();
  }

  // Save doctors
  static Future<void> saveDoctors(List<Doctor> doctors) async {
    final jsonString = json.encode(doctors.map((d) => d.toJson()).toList());
    await _prefs?.setString('doctors', jsonString);
  }

  // Add doctor
  static Future<void> addDoctor(Doctor doctor) async {
    final doctors = await getDoctors();
    doctors.add(doctor);
    await saveDoctors(doctors);
  }

  // Find doctor by email
  static Future<Doctor?> findDoctorByEmail(
      String email, String password) async {
    final doctors = await getDoctors();
    try {
      return doctors.firstWhere(
        (d) => d.email == email && d.password == password,
      );
    } catch (e) {
      return null;
    }
  }

  // ========== PATIENTS ==========

  // Get all patients
  static Future<List<Patient>> getPatients() async {
    final jsonString = _prefs?.getString('patients') ?? '[]';
    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.map((json) => Patient.fromJson(json)).toList();
  }

  // Save patients
  static Future<void> savePatients(List<Patient> patients) async {
    final jsonString = json.encode(patients.map((p) => p.toJson()).toList());
    await _prefs?.setString('patients', jsonString);
  }

  // Add patient
  static Future<void> addPatient(Patient patient) async {
    final patients = await getPatients();
    patients.add(patient);
    await savePatients(patients);
  }

  // Find patient by MRN
  static Future<Patient?> findPatientByMRN(String mrn) async {
    final patients = await getPatients();
    try {
      return patients.firstWhere((p) => p.mrn == mrn);
    } catch (e) {
      return null;
    }
  }

  // Update patient
  static Future<void> updatePatient(String mrn, Patient updatedPatient) async {
    final patients = await getPatients();
    final index = patients.indexWhere((p) => p.mrn == mrn);

    if (index != -1) {
      patients[index] = updatedPatient;
      await savePatients(patients);
    }
  }

  // Get patients by status
  static Future<List<Patient>> getPatientsByStatus(String status) async {
    final patients = await getPatients();
    return patients.where((p) => p.status == status).toList();
  }

  // ========== USER SESSION ==========

  // Save current user role
  static Future<void> saveUserRole(String role) async {
    await _prefs?.setString('userRole', role);
  }

  // Get current user role
  static String? getUserRole() {
    return _prefs?.getString('userRole');
  }

  // Save current patient
  static Future<void> saveCurrentPatient(Patient patient) async {
    final jsonString = json.encode(patient.toJson());
    await _prefs?.setString('currentPatient', jsonString);
  }

  // Get current patient
  static Patient? getCurrentPatient() {
    final jsonString = _prefs?.getString('currentPatient');
    if (jsonString != null) {
      return Patient.fromJson(json.decode(jsonString));
    }
    return null;
  }

  // Save current doctor
  static Future<void> saveCurrentDoctor(Doctor doctor) async {
    final jsonString = json.encode(doctor.toJson());
    await _prefs?.setString('currentDoctor', jsonString);
  }

  // Get current doctor
  static Doctor? getCurrentDoctor() {
    final jsonString = _prefs?.getString('currentDoctor');
    if (jsonString != null) {
      return Doctor.fromJson(json.decode(jsonString));
    }
    return null;
  }

  // Logout
  static Future<void> logout() async {
    await _prefs?.remove('userRole');
    await _prefs?.remove('currentPatient');
    await _prefs?.remove('currentDoctor');
  }

  // Clear all data (for testing)
  static Future<void> clearAll() async {
    await _prefs?.clear();
    await _initDemoData();
  }
}
