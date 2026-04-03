String normalizeRole(String? role) {
  final raw = (role ?? '').trim().toLowerCase();

  if (raw == 'dokter' || raw == 'doctor') return 'dokter';
  if (raw == 'pasien' || raw == 'patient') return 'pasien';
  if (raw == 'admin') return 'admin';

  return raw;
}

