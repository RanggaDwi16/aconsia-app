import 'package:aconsia_app/core/main/data/models/dokter_profile_model.dart';
import 'package:aconsia_app/core/helpers/timestamp/timestamp_convert.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:aconsia_app/core/main/data/models/pasien_profile_model.dart';

abstract class PasienProfileRemoteDataSource {
  /// Get pasien profile by UID
  Future<Either<String, PasienProfileModel>> getPasienProfile(
      {required String uid});

  /// Update pasien profile
  Future<Either<String, String>> updatePasienProfile({
    required PasienProfileModel model,
  });

  /// Update pasien photo URL (Cloudinary)
  Future<Either<String, String>> updatePasienPhotoUrl({
    required String uid,
    required String photoUrl,
  });

  /// Delete pasien profile
  Future<Either<String, String>> deletePasienProfile(String uid);

  /// Stream pasien profile (real-time updates)
  Stream<PasienProfileModel?> streamPasienProfile({required String uid});

  /// Add konten to favorites
  Future<Either<String, String>> addKontenToFavorites({
    required String pasienId,
    required String kontenId,
  });

  /// Remove konten from favorites
  Future<Either<String, String>> removeKontenFromFavorites({
    required String pasienId,
    required String kontenId,
  });

  /// Update AI keywords for recommendations
  Future<Either<String, String>> updateAIKeywords({
    required String pasienId,
    required List<String> keywords,
  });

  /// Check if pasien profile exists
  Future<Either<String, bool>> checkProfileExists({required String uid});
  Future<Either<String, List<DokterProfileModel>>> getAllDokterOptions();
}

class PasienProfileRemoteDataSourceImpl
    implements PasienProfileRemoteDataSource {
  final FirebaseFirestore firestore;

  PasienProfileRemoteDataSourceImpl({required this.firestore});

  PasienProfileModel _toPasienProfileModel(
      String uid, Map<String, dynamic> data) {
    dynamic readValue(List<String> keys) {
      for (final key in keys) {
        if (data.containsKey(key) && data[key] != null) {
          return data[key];
        }
      }
      return null;
    }

    String? readString(List<String> keys) {
      final value = readValue(keys);
      if (value == null) return null;
      final text = value.toString().trim();
      return text.isEmpty ? null : text;
    }

    double? readDouble(List<String> keys) {
      final value = readValue(keys);
      if (value == null) return null;
      if (value is num) return value.toDouble();
      return double.tryParse(value.toString());
    }

    List<String>? readStringList(List<String> keys) {
      final value = readValue(keys);
      if (value is List) {
        return value.map((e) => e.toString()).toList();
      }
      return null;
    }

    Timestamp? readTimestamp(List<String> keys) {
      final value = readValue(keys);
      if (value is Timestamp) return value;
      if (value is String && value.trim().isNotEmpty) {
        return timestampFromJson(value) ?? tryParseTanggal(value);
      }
      return null;
    }

    return PasienProfileModel(
      uid: uid,
      dokterId: readString(['dokterId', 'assignedDokterId']),
      namaLengkap: readString(['namaLengkap', 'fullName', 'name']),
      nomorTelepon: readString(['nomorTelepon', 'phoneNumber', 'phone']),
      email: readString(['email']),
      fotoProfilUrl: readString(['fotoProfilUrl', 'photoUrl']),
      noRekamMedis: readString(['noRekamMedis', 'mrn']),
      nik: readString(['nik']),
      tanggalLahir: readTimestamp(['tanggalLahir', 'dateOfBirth']),
      jenisKelamin: readString(['jenisKelamin', 'gender']),
      tempatLahir: readString(['tempatLahir']),
      jenisOperasi: readString(['jenisOperasi', 'surgeryType']),
      jenisAnestesi: readString(['jenisAnestesi', 'anesthesiaType']),
      klasifikasiAsa: readString(['klasifikasiASA', 'asaClassification']),
      tinggiBadan: readDouble(['tinggiBadan', 'height']),
      beratBadan: readDouble(['beratBadan', 'weight']),
      namaWali: readString(['namaWali']),
      hubunganWali: readString(['hubunganWali']),
      nomorHpWali: readString(['nomorHpWali']),
      alamatWali: readString(['alamatWali']),
      kontenFavoritIds: readStringList(['kontenFavoritIds']),
      aiKeywords: readStringList(['aiKeywords']),
      createdAt: readTimestamp(['createdAt']),
      updatedAt: readTimestamp(['updatedAt']),
    );
  }

  @override
  Future<Either<String, String>> addKontenToFavorites(
      {required String pasienId, required String kontenId}) async {
    try {
      await firestore.collection('pasien_profiles').doc(pasienId).update({
        'kontenFavoritIds': FieldValue.arrayUnion([kontenId]),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      return const Right('Tambah favorit berhasil.');
    } catch (e) {
      return Left('Gagal tambah favorit: $e');
    }
  }

  @override
  Future<Either<String, bool>> checkProfileExists({required String uid}) async {
    try {
      final doc = await firestore.collection('pasien_profiles').doc(uid).get();
      return Right(doc.exists);
    } catch (e) {
      return Left('Failed to check profile existence: $e');
    }
  }

  @override
  Future<Either<String, String>> deletePasienProfile(String uid) async {
    try {
      await firestore.collection('pasien_profiles').doc(uid).delete();
      return Right('Pasien profile deleted successfully.');
    } catch (e) {
      return Left('Failed to delete pasien profile: $e');
    }
  }

  @override
  Future<Either<String, PasienProfileModel>> getPasienProfile(
      {required String uid}) async {
    try {
      final profileDoc =
          await firestore.collection('pasien_profiles').doc(uid).get();
      final userDoc = await firestore.collection('users').doc(uid).get();

      if (!profileDoc.exists && !userDoc.exists) {
        return Left('Pasien profile not found.');
      }

      final merged = <String, dynamic>{};
      if (userDoc.exists) merged.addAll(userDoc.data()!);
      if (profileDoc.exists) merged.addAll(profileDoc.data()!);
      final profile = _toPasienProfileModel(uid, merged);
      return Right(profile);
    } catch (e) {
      return Left('Failed to get pasien profile: $e');
    }
  }

  @override
  Future<Either<String, String>> removeKontenFromFavorites(
      {required String pasienId, required String kontenId}) async {
    try {
      await firestore.collection('pasien_profiles').doc(pasienId).update({
        'kontenFavoritIds': FieldValue.arrayRemove([kontenId]),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      return const Right('Hapus favorit berhasil.');
    } catch (e) {
      return Left('Gagal hapus favorit: $e');
    }
  }

  @override
  Stream<PasienProfileModel?> streamPasienProfile({required String uid}) {
    return firestore
        .collection('pasien_profiles')
        .doc(uid)
        .snapshots()
        .map((doc) {
      if (!doc.exists) return null;
      return _toPasienProfileModel(uid, doc.data()!);
    });
  }

  @override
  Future<Either<String, String>> updateAIKeywords(
      {required String pasienId, required List<String> keywords}) async {
    try {
      await firestore.collection('pasien_profiles').doc(pasienId).update({
        'aiKeywords': keywords,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      return const Right('Update keywords berhasil.');
    } catch (e) {
      return Left('Gagal update keywords: $e');
    }
  }

  @override
  Future<Either<String, String>> updatePasienPhotoUrl(
      {required String uid, required String photoUrl}) async {
    try {
      await firestore.collection('pasien_profiles').doc(uid).update({
        'photoUrl': photoUrl,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      return Right('Photo URL updated successfully.');
    } catch (e) {
      return Left('Failed to update photo URL: $e');
    }
  }

  @override
  Future<Either<String, String>> updatePasienProfile(
      {required PasienProfileModel model}) async {
    try {
      final uid = model.uid ?? '';
      if (uid.isEmpty) {
        return const Left('UID pasien tidak valid.');
      }

      final fullName = (model.namaLengkap ?? '').trim();
      final phone = (model.nomorTelepon ?? '').trim();
      final email = (model.email ?? '').trim().toLowerCase();
      final mrn = (model.noRekamMedis ?? '').trim();
      final diagnosis = (model.jenisOperasi ?? '').trim();
      final anesthesia = (model.jenisAnestesi ?? '').trim();
      final assignedDokterId = (model.dokterId ?? '').trim();

      await Future.wait([
        firestore.collection('pasien_profiles').doc(uid).set({
          'uid': uid,
          'dokterId': assignedDokterId,
          'assignedDokterId': assignedDokterId,
          'namaLengkap': fullName,
          'fullName': fullName,
          'nomorTelepon': phone,
          'phoneNumber': phone,
          'email': email,
          'fotoProfilUrl': model.fotoProfilUrl,
          'photoUrl': model.fotoProfilUrl,
          'noRekamMedis': mrn,
          'mrn': mrn,
          'nik': model.nik,
          'tanggalLahir': model.tanggalLahir,
          'jenisKelamin': model.jenisKelamin,
          'jenisOperasi': diagnosis,
          'surgeryType': diagnosis,
          'jenisAnestesi': anesthesia,
          'anesthesiaType': anesthesia,
          'klasifikasiASA': model.klasifikasiAsa,
          'tinggiBadan': model.tinggiBadan,
          'beratBadan': model.beratBadan,
          'namaWali': model.namaWali,
          'hubunganWali': model.hubunganWali,
          'nomorHpWali': model.nomorHpWali,
          'alamatWali': model.alamatWali,
          'kontenFavoritIds': model.kontenFavoritIds ?? [],
          'aiKeywords': model.aiKeywords ?? [],
          'updatedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true)),
        firestore.collection('users').doc(uid).set({
          'uid': uid,
          'email': email,
          'name': fullName,
          'displayName': fullName,
          'phone': phone,
          'role': 'pasien',
          'isProfileCompleted': true,
          'updatedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true)),
      ]);

      return const Right('Profil berhasil diperbarui.');
    } catch (e) {
      return Left('Gagal update profil: $e');
    }
  }

  @override
  Future<Either<String, List<DokterProfileModel>>> getAllDokterOptions() async {
    try {
      final querySnapshot = await firestore.collection('dokter_profiles').get();

      final dokterList = querySnapshot.docs
          .map((doc) => _toDokterProfileModel(doc.id, doc.data()))
          .toList();

      return Right(dokterList);
    } catch (e) {
      return Left('Gagal mengambil daftar dokter: $e');
    }
  }

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

    return DokterProfileModel(
      uid: uid,
      namaLengkap:
          readString(['namaLengkap', 'fullName', 'nama', 'name', 'displayName']),
      nomorStr: readString(['nomorSTR', 'nomorStr', 'strNumber']),
      nomorSip: readString(['nomorSIP', 'nomorSip', 'sipNumber']),
      spesialisasi: readString(['spesialisasi', 'specialization']),
      tanggalGabung: readString(['tanggalGabung', 'joinedAtLabel']),
      tempatLahir: readString(['tempatLahir']),
      tanggalLahir: readString(['tanggalLahir', 'dateOfBirth']),
      jenisKelamin: readString(['jenisKelamin', 'gender']),
      email: readString(['email']),
      nomorTelepon:
          readString(['nomorTelepon', 'phoneNumber', 'noTelepon', 'phone']),
      fotoProfilUrl: readString(['fotoProfilUrl', 'photoUrl', 'avatarUrl']),
      createdAt: readString(['createdAt']),
      updatedAt: readString(['updatedAt']),
    );
  }
}
