import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:aconsia_app/core/main/data/models/dokter_profile_model.dart';
import 'package:intl/intl.dart';

/// Remote DataSource untuk Dokter Profile
abstract class DokterProfileRemoteDataSource {
  Future<Either<String, DokterProfileModel>> getDokterProfile(
      {required String uid});

  Stream<DokterProfileModel?> streamDokterProfile({required String uid});

  Future<Either<String, String>> updateDokterProfile(
      {required DokterProfileModel profile});

  Future<Either<String, String>> updateDokterPhotoUrl(
      {required String uid, required String photoUrl});

  Future<Either<String, String>> deleteDokterProfile({required String uid});
  Future<Either<String, bool>> checkProfileExists({
    required String uid,
  });
}

class DokterProfileRemoteDataSourceImpl
    implements DokterProfileRemoteDataSource {
  final FirebaseFirestore firestore;

  DokterProfileRemoteDataSourceImpl({required this.firestore});

  String _readString(Map<String, dynamic> data, List<String> keys) {
    for (final key in keys) {
      final value = data[key];
      if (value != null && value.toString().trim().isNotEmpty) {
        return value.toString().trim();
      }
    }
    return '';
  }

  String _readDisplayDate(Map<String, dynamic> data, List<String> keys) {
    for (final key in keys) {
      final value = data[key];
      if (value == null) continue;
      if (value is Timestamp) {
        return DateFormat('dd/MM/yyyy').format(value.toDate());
      }
      final text = value.toString().trim();
      if (text.isEmpty) continue;
      final parsed = DateTime.tryParse(text);
      if (parsed != null) {
        return DateFormat('dd/MM/yyyy').format(parsed);
      }
      return text;
    }
    return '';
  }

  DokterProfileModel _toDokterProfileModel(
      String uid, Map<String, dynamic> data) {
    return DokterProfileModel(
      uid: uid,
      namaLengkap:
          _readString(data, ['fullName', 'namaLengkap', 'nama', 'name', 'displayName']),
      nomorStr: _readString(data, ['strNumber', 'nomorSTR', 'nomorStr']),
      nomorSip: _readString(data, ['sipNumber', 'nomorSIP', 'nomorSip']),
      spesialisasi: _readString(data, ['specialization', 'spesialisasi']),
      hospitalName:
          _readString(data, ['hospitalName', 'namaRumahSakit', 'hospital']),
      status: _readString(data, ['status']),
      tanggalGabung:
          _readDisplayDate(data, ['createdAt', 'tanggalGabung', 'joinedAtLabel']),
      tempatLahir: _readString(data, ['tempatLahir']),
      tanggalLahir: _readDisplayDate(data, ['tanggalLahir', 'dateOfBirth']),
      jenisKelamin: _readString(data, ['jenisKelamin', 'gender']),
      email: _readString(data, ['email']),
      nomorTelepon:
          _readString(data, ['phoneNumber', 'nomorTelepon', 'noTelepon', 'phone']),
      fotoProfilUrl: _readString(data, ['fotoProfilUrl', 'photoUrl', 'avatarUrl']),
      createdAt: _readDisplayDate(data, ['createdAt']),
      updatedAt: _readDisplayDate(data, ['updatedAt']),
    );
  }

  @override
  Future<Either<String, bool>> checkProfileExists({required String uid}) async {
    try {
      final doc = await firestore.collection('dokter_profiles').doc(uid).get();
      return Right(doc.exists);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, String>> deleteDokterProfile(
      {required String uid}) async {
    try {
      await firestore.collection('dokter_profiles').doc(uid).delete();
      return const Right('Profil dokter berhasil dihapus.');
    } catch (e) {
      return Left('Gagal menghapus profil dokter: $e');
    }
  }

  @override
  Future<Either<String, DokterProfileModel>> getDokterProfile(
      {required String uid}) async {
    try {
      final profileDoc =
          await firestore.collection('dokter_profiles').doc(uid).get();

      // Public-safe mode: pasien mungkin tidak diizinkan membaca users/{uid}.
      // Jadi users doc hanya dipakai sebagai optional enrichment ketika bisa diakses.
      Map<String, dynamic>? userData;
      try {
        final userDoc = await firestore.collection('users').doc(uid).get();
        if (userDoc.exists) {
          userData = userDoc.data();
        }
      } on FirebaseException catch (e) {
        if (e.code != 'permission-denied') {
          rethrow;
        }
      }

      if (!profileDoc.exists && (userData == null || userData.isEmpty)) {
        return const Left('Profil dokter tidak ditemukan.');
      }

      final merged = <String, dynamic>{};
      if (userData != null) merged.addAll(userData);
      if (profileDoc.exists) merged.addAll(profileDoc.data()!);

      return Right(_toDokterProfileModel(uid, merged));
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Stream<DokterProfileModel?> streamDokterProfile({required String uid}) {
    try {
      return firestore
          .collection('dokter_profiles')
          .doc(uid)
          .snapshots()
          .map((doc) {
        if (!doc.exists) return null;
        return _toDokterProfileModel(uid, doc.data()!);
      });
    } catch (e) {
      throw Exception('Gagal melakukan streaming profil dokter: $e');
    }
  }

  @override
  Future<Either<String, String>> updateDokterPhotoUrl(
      {required String uid, required String photoUrl}) async {
    try {
      await firestore.collection('dokter_profiles').doc(uid).set({
        'uid': uid,
        'fotoProfilUrl': photoUrl,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      return const Right('Foto profil dokter berhasil diperbarui.');
    } catch (e) {
      return Left('Gagal update foto profil dokter: $e');
    }
  }

  @override
  Future<Either<String, String>> updateDokterProfile(
      {required DokterProfileModel profile}) async {
    try {
      final uid = profile.uid ?? '';
      if (uid.isEmpty) {
        return const Left('UID dokter tidak valid.');
      }

      final existingUserDoc = await firestore.collection('users').doc(uid).get();
      final existingProfileDoc =
          await firestore.collection('dokter_profiles').doc(uid).get();
      final existingUser = existingUserDoc.data() ?? <String, dynamic>{};
      final existingProfile = existingProfileDoc.data() ?? <String, dynamic>{};

      final fullName = (profile.namaLengkap?.trim().isNotEmpty == true
              ? profile.namaLengkap
              : existingProfile['fullName'] ?? existingUser['name'] ?? '')
          .toString()
          .trim();
      final email = (profile.email?.trim().isNotEmpty == true
              ? profile.email
              : existingUser['email'] ?? '')
          .toString()
          .trim()
          .toLowerCase();
      final phone = (profile.nomorTelepon?.trim().isNotEmpty == true
              ? profile.nomorTelepon
              : existingProfile['phoneNumber'] ?? existingUser['phone'] ?? '')
          .toString()
          .trim();
      final sip = (profile.nomorSip?.trim().isNotEmpty == true
              ? profile.nomorSip
              : existingProfile['sipNumber'] ?? existingUser['sipNumber'] ?? '')
          .toString()
          .trim();
      final str = (profile.nomorStr?.trim().isNotEmpty == true
              ? profile.nomorStr
              : existingProfile['strNumber'] ?? existingUser['strNumber'] ?? '')
          .toString()
          .trim();
      final fotoProfilUrl = (profile.fotoProfilUrl?.trim().isNotEmpty == true
              ? profile.fotoProfilUrl
              : existingProfile['fotoProfilUrl'] ?? '')
          .toString()
          .trim();
      final hospitalName = (profile.hospitalName?.trim().isNotEmpty == true
              ? profile.hospitalName
              : existingProfile['hospitalName'] ??
                  existingProfile['namaRumahSakit'] ??
                  existingUser['hospital'] ??
                  '')
          .toString()
          .trim();
      final specialization = (profile.spesialisasi?.trim().isNotEmpty == true
              ? profile.spesialisasi
              : existingProfile['specialization'] ??
                  existingProfile['spesialisasi'] ??
                  existingUser['specialization'] ??
                  '')
          .toString()
          .trim();
      final status = (profile.status?.trim().isNotEmpty == true
              ? profile.status
              : existingProfile['status'] ?? existingUser['status'] ?? 'active')
          .toString()
          .trim();

      final phoneRegex = RegExp(r'^(\+62|62|0)[0-9]{9,12}$');
      if (!phoneRegex.hasMatch(phone)) {
        return const Left(
            'Nomor telepon dokter harus format Indonesia (contoh: 0812xxxxxxx).');
      }
      if (fullName.length < 3 ||
          email.length < 6 ||
          sip.isEmpty ||
          str.isEmpty ||
          specialization.length < 3 ||
          hospitalName.length < 3) {
        return const Left(
            'Data dokter belum lengkap untuk disimpan. Lengkapi nama, email, SIP, STR, telepon, dan rumah sakit.');
      }

      await Future.wait([
        firestore.collection('dokter_profiles').doc(uid).set({
          'uid': uid,
          'email': email,
          'fullName': fullName,
          'phoneNumber': phone,
          'specialization': specialization,
          'sipNumber': sip,
          'strNumber': str,
          'hospitalName': hospitalName,
          'status': status,
          if (fotoProfilUrl.isNotEmpty) 'fotoProfilUrl': fotoProfilUrl,
          'createdAt':
              existingProfile['createdAt'] ?? FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true)),
        firestore.collection('users').doc(uid).set({
          'uid': uid,
          'email': email,
          'name': fullName,
          'displayName': fullName,
          'phone': phone,
          'specialization': specialization,
          'sipNumber': sip,
          'strNumber': str,
          'role': 'dokter',
          'status': status,
          'hospital': hospitalName,
          'isProfileCompleted': true,
          'createdAt':
              existingUser['createdAt'] ?? FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true)),
      ]);

      return const Right('Profil dokter berhasil diperbarui.');
    } catch (e) {
      return Left('Gagal update profil: $e');
    }
  }
}
