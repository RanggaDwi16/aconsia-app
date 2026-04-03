import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:aconsia_app/core/main/data/models/dokter_profile_model.dart';

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

  DokterProfileModel _toDokterProfileModel(
      String uid, Map<String, dynamic> data) {
    String readString(List<String> keys) {
      for (final key in keys) {
        final value = data[key];
        if (value != null && value.toString().trim().isNotEmpty) {
          return value.toString();
        }
      }
      return '';
    }

    String readDateString(List<String> keys) {
      for (final key in keys) {
        final value = data[key];
        if (value is Timestamp) {
          return value.toDate().toIso8601String();
        }
        if (value != null && value.toString().trim().isNotEmpty) {
          return value.toString();
        }
      }
      return '';
    }

    return DokterProfileModel(
      uid: uid,
      namaLengkap:
          readString(['namaLengkap', 'fullName', 'nama', 'name', 'displayName']),
      nomorStr: readString(['nomorSTR', 'nomorStr', 'strNumber']),
      nomorSip: readString(['nomorSIP', 'nomorSip', 'sipNumber']),
      spesialisasi: readString(['spesialisasi', 'specialization']),
      tanggalGabung:
          readDateString(['tanggalGabung', 'joinedAtLabel', 'createdAt']),
      tempatLahir: readString(['tempatLahir']),
      tanggalLahir: readDateString(['tanggalLahir', 'dateOfBirth']),
      jenisKelamin: readString(['jenisKelamin', 'gender']),
      email: readString(['email']),
      nomorTelepon:
          readString(['nomorTelepon', 'phoneNumber', 'noTelepon', 'phone']),
      fotoProfilUrl: readString(['fotoProfilUrl', 'photoUrl', 'avatarUrl']),
      createdAt: readDateString(['createdAt']),
      updatedAt: readDateString(['updatedAt']),
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
      final userDoc = await firestore.collection('users').doc(uid).get();

      if (!profileDoc.exists && !userDoc.exists) {
        return const Left('Profil dokter tidak ditemukan.');
      }

      final merged = <String, dynamic>{};
      if (userDoc.exists) merged.addAll(userDoc.data()!);
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

      final fullName =
          (profile.namaLengkap ?? existingProfile['fullName'] ?? existingUser['name'] ?? '')
              .toString()
              .trim();
      final email =
          (profile.email ?? existingUser['email'] ?? '').toString().trim().toLowerCase();
      final phone = (profile.nomorTelepon ??
              existingProfile['phoneNumber'] ??
              existingUser['phone'] ??
              '')
          .toString()
          .trim();
      final sip = (profile.nomorSip ??
              existingProfile['sipNumber'] ??
              existingUser['sipNumber'] ??
              '')
          .toString()
          .trim();
      final str = (profile.nomorStr ??
              existingProfile['strNumber'] ??
              existingUser['strNumber'] ??
              '')
          .toString()
          .trim();
      final fotoProfilUrl =
          (profile.fotoProfilUrl ?? existingProfile['fotoProfilUrl'] ?? '')
              .toString()
              .trim();
      final existingHospital = (existingProfile['hospitalName'] ??
              existingProfile['namaRumahSakit'] ??
              existingUser['hospital'] ??
              'RS Aconsia')
          .toString()
          .trim();
      const specialization = 'Anestesiologi';

      final phoneRegex = RegExp(r'^(\+62|62|0)[0-9]{9,12}$');
      if (!phoneRegex.hasMatch(phone)) {
        return const Left(
            'Nomor telepon dokter harus format Indonesia (contoh: 0812xxxxxxx).');
      }
      if (fullName.length < 3 ||
          email.length < 6 ||
          sip.isEmpty ||
          str.isEmpty ||
          existingHospital.length < 3) {
        return const Left(
            'Data dokter belum lengkap untuk disimpan. Lengkapi nama, email, SIP, STR, telepon, dan rumah sakit.');
      }

      await Future.wait([
        firestore.collection('dokter_profiles').doc(uid).set({
          'uid': uid,
          'email': email,
          'fullName': fullName,
          'nama': fullName,
          'phoneNumber': phone,
          'noTelepon': phone,
          'specialization': specialization,
          'sipNumber': sip,
          'strNumber': str,
          if (fotoProfilUrl.isNotEmpty) 'fotoProfilUrl': fotoProfilUrl,
          'hospitalName': existingHospital,
          'namaRumahSakit': existingHospital,
          'status': 'active',
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
          'status': 'active',
          'hospital': existingHospital,
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
