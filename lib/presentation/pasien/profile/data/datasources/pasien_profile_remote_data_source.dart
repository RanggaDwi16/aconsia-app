import 'package:aconsia_app/core/main/data/models/dokter_profile_model.dart';
import 'package:aconsia_app/core/helpers/timestamp/timestamp_convert.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:aconsia_app/core/main/data/models/pasien_profile_model.dart';
import 'package:flutter/foundation.dart';

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

  Future<Either<String, String>> submitPreOperativeAssessment({
    required String uid,
    required String asaStatusSnapshot,
    required Map<String, dynamic> assessmentData,
  });
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

    bool readBool(List<String> keys, {bool defaultValue = false}) {
      final value = readValue(keys);
      if (value is bool) return value;
      if (value is num) return value != 0;
      if (value is String) {
        return value.toLowerCase() == 'true' || value == '1';
      }
      return defaultValue;
    }

    Map<String, dynamic>? readMap(List<String> keys) {
      final value = readValue(keys);
      if (value is Map<String, dynamic>) return value;
      if (value is Map) return value.cast<String, dynamic>();
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
      agama: readString(['agama', 'religion']),
      statusPernikahan: readString(['statusPernikahan', 'maritalStatus']),
      pendidikanTerakhir: readString(['pendidikanTerakhir', 'lastEducation']),
      pekerjaan: readString(['pekerjaan', 'occupation']),
      alamatLengkap: readString(['alamatLengkap', 'fullAddress']),
      rt: readString(['rt']),
      rw: readString(['rw']),
      kelurahanDesa: readString(['kelurahanDesa', 'village']),
      kecamatan: readString(['kecamatan', 'district']),
      kotaKabupaten: readString(['kotaKabupaten', 'city']),
      provinsi: readString(['provinsi', 'province']),
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
      assessmentCompleted: readBool(
        ['assessmentCompleted'],
        defaultValue: false,
      ),
      preOperativeAssessment:
          readMap(['preOperativeAssessment', 'pre_operative_assessment']),
      preOperativeAssessmentUpdatedAt: readTimestamp(
        ['preOperativeAssessmentUpdatedAt'],
      ),
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
      final safeUid = uid.trim();
      if (safeUid.isEmpty) {
        return const Left('[invalidArgument] UID pasien tidak valid.');
      }

      final profileDoc =
          await firestore.collection('pasien_profiles').doc(safeUid).get();
      final userDoc = await firestore.collection('users').doc(safeUid).get();

      if (!profileDoc.exists && !userDoc.exists) {
        return const Left('[notFound] Profil pasien tidak ditemukan.');
      }

      final merged = <String, dynamic>{};
      if (userDoc.exists) merged.addAll(userDoc.data()!);
      if (profileDoc.exists) merged.addAll(profileDoc.data()!);
      final profile = _toPasienProfileModel(safeUid, merged);
      return Right(profile);
    } on FirebaseException catch (e) {
      if (e.code == 'permission-denied') {
        return const Left(
          '[permissionDenied] Anda tidak memiliki akses ke data pasien ini.',
        );
      }
      if (e.code == 'not-found') {
        return const Left('[notFound] Profil pasien tidak ditemukan.');
      }
      return Left(
          '[unknown] Gagal mengambil profil pasien: ${e.message ?? e.code}');
    } catch (e) {
      return Left('[unknown] Failed to get pasien profile: $e');
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
        'fotoProfilUrl': photoUrl,
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
    final uid = model.uid ?? '';
    try {
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
          'nomorTelepon': phone,
          'email': email,
          'fotoProfilUrl': model.fotoProfilUrl,
          'noRekamMedis': mrn,
          'nik': model.nik,
          'tanggalLahir': model.tanggalLahir,
          'jenisKelamin': model.jenisKelamin,
          'agama': model.agama,
          'statusPernikahan': model.statusPernikahan,
          'pendidikanTerakhir': model.pendidikanTerakhir,
          'pekerjaan': model.pekerjaan,
          'alamatLengkap': model.alamatLengkap,
          'rt': model.rt,
          'rw': model.rw,
          'kelurahanDesa': model.kelurahanDesa,
          'kecamatan': model.kecamatan,
          'kotaKabupaten': model.kotaKabupaten,
          'provinsi': model.provinsi,
          'jenisOperasi': diagnosis,
          'jenisAnestesi': anesthesia,
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
    } on FirebaseException catch (e) {
      debugPrint(
        '[PasienProfileDS] update failed uid=$uid path=pasien_profiles/$uid code=${e.code} message=${e.message}',
      );
      return Left(
        'Gagal update profil: [${e.code}] ${e.message ?? e.toString()}',
      );
    } catch (e) {
      return Left('Gagal update profil: $e');
    }
  }

  @override
  Future<Either<String, List<DokterProfileModel>>> getAllDokterOptions() async {
    try {
      final publicSnapshot = await firestore
          .collection('public_dokter_options')
          .where('status', isEqualTo: 'active')
          .get();

      if (publicSnapshot.docs.isNotEmpty) {
        final dokterList = publicSnapshot.docs
            .map((doc) => _toDokterProfileModel(doc.id, doc.data()))
            .toList();
        return Right(dokterList);
      }

      if (FirebaseAuth.instance.currentUser == null) {
        return const Right(<DokterProfileModel>[]);
      }

      final querySnapshot = await firestore
          .collection('dokter_profiles')
          .where('status', isEqualTo: 'active')
          .get();

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
      namaLengkap: readString(
          ['namaLengkap', 'fullName', 'nama', 'name', 'displayName']),
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
      status: readString(['status']),
      fotoProfilUrl: readString(['fotoProfilUrl', 'photoUrl', 'avatarUrl']),
      createdAt: readString(['createdAt']),
      updatedAt: readString(['updatedAt']),
    );
  }

  @override
  Future<Either<String, String>> submitPreOperativeAssessment({
    required String uid,
    required String asaStatusSnapshot,
    required Map<String, dynamic> assessmentData,
  }) async {
    try {
      await firestore.collection('pasien_profiles').doc(uid).set({
        'assessmentCompleted': true,
        'preOperativeAssessment': {
          'version': 1,
          'completed': true,
          'completedAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
          'asaStatusSnapshot': asaStatusSnapshot,
          'data': assessmentData,
        },
        'preOperativeAssessmentUpdatedAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      return const Right('Asesmen pra-operasi berhasil disimpan.');
    } catch (e) {
      return Left('Gagal menyimpan asesmen pra-operasi: $e');
    }
  }
}
