import 'package:aconsia_app/core/main/data/models/pasien_profile_model.dart';
import 'package:aconsia_app/presentation/dokter/home/domain/usecases/add_pasien_medic_information.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';

abstract class HomeRemoteDataSource {
  Future<Either<String, int>> getPasienCountByDokterId({
    required String dokterId,
  });
  Future<Either<String, String>> addPasienMedicInformation({
    required String pasienId,
    required PasienProfileModel profile,
    required String diagnosis,
    required DokterApprovalDecision decision,
    String? rejectionReason,
  });

  Future<Either<String, List<PasienProfileModel>>> getPasienListByDokterId({
    required String dokterId,
  });

  Future<Either<String, PasienProfileModel>> getPasienProfileById({
    required String pasienId,
  });
}

class HomeremoteDataSourceImpl implements HomeRemoteDataSource {
  final FirebaseFirestore firestore;

  HomeremoteDataSourceImpl({required this.firestore});

  @override
  Future<Either<String, int>> getPasienCountByDokterId(
      {required String dokterId}) async {
    try {
      final byDokterId = await firestore
          .collection('pasien_profiles')
          .where('dokterId', isEqualTo: dokterId)
          .get();
      final byAssignedDokterId = await firestore
          .collection('pasien_profiles')
          .where('assignedDokterId', isEqualTo: dokterId)
          .get();
      final merged = <String>{
        ...byDokterId.docs.map((e) => e.id),
        ...byAssignedDokterId.docs.map((e) => e.id),
      };
      final count = merged.length;

      return Right(count);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, String>> addPasienMedicInformation(
      {required String pasienId,
      required PasienProfileModel profile,
      required String diagnosis,
      required DokterApprovalDecision decision,
      String? rejectionReason}) async {
    try {
      final pasienRef = firestore.collection('pasien_profiles').doc(pasienId);
      final isApprove = decision == DokterApprovalDecision.approve;
      final diagnosisValue = diagnosis.trim();
      final operasiValue = (profile.jenisOperasi ?? '').trim();
      final anestesiValue = (profile.jenisAnestesi ?? '').trim();
      final asaValue = (profile.klasifikasiAsa ?? '').trim();
      final rejectionValue = (rejectionReason ?? '').trim();

      final reviewStatus = isApprove ? 'approved' : 'rejected';

      final preOp = <String, dynamic>{
        'status': reviewStatus,
        'reviewDecision': reviewStatus,
        'reviewedByRole': 'dokter',
        if (rejectionValue.isNotEmpty) 'rejectionReason': rejectionValue,
        'updatedAt': FieldValue.serverTimestamp(),
      };

      await pasienRef.update({
        'diagnosis': diagnosisValue,
        'jenisOperasi': operasiValue,
        'surgeryType': operasiValue,
        'jenisAnestesi': anestesiValue,
        'anesthesiaType': anestesiValue,
        'klasifikasiASA': asaValue,
        'asaClassification': asaValue,
        'tinggiBadan': profile.tinggiBadan,
        'beratBadan': profile.beratBadan,
        'preOperativeAssessment': preOp,
        'preOperativeAssessmentUpdatedAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      return Right(
        isApprove
            ? 'Pasien berhasil disetujui dan edukasi diaktifkan.'
            : 'Pasien berhasil ditolak.',
      );
    } on FirebaseException catch (e) {
      return Left('Gagal menambahkan informasi medis pasien: ${e.message}');
    } catch (e) {
      return Left('Gagal menambahkan informasi medis pasien: $e');
    }
  }

  @override
  Future<Either<String, List<PasienProfileModel>>> getPasienListByDokterId(
      {required String dokterId}) async {
    try {
      final byDokterId = await firestore
          .collection('pasien_profiles')
          .where('dokterId', isEqualTo: dokterId)
          .get();
      final byAssignedDokterId = await firestore
          .collection('pasien_profiles')
          .where('assignedDokterId', isEqualTo: dokterId)
          .get();
      final merged = <String, Map<String, dynamic>>{};
      for (final doc in [...byDokterId.docs, ...byAssignedDokterId.docs]) {
        merged[doc.id] = doc.data();
      }

      final pasienList = merged.values
          .map((data) => PasienProfileModel.fromJson(data))
          .toList();

      return Right(pasienList);
    } catch (e) {
      return Left('Gagal mengambil daftar pasien: $e');
    }
  }

  @override
  Future<Either<String, PasienProfileModel>> getPasienProfileById(
      {required String pasienId}) async {
    try {
      final docSnapshot =
          await firestore.collection('pasien_profiles').doc(pasienId).get();

      if (docSnapshot.exists) {
        final pasienProfile = PasienProfileModel.fromJson(docSnapshot.data()!);
        return Right(pasienProfile);
      } else {
        return Left('Profil pasien tidak ditemukan.');
      }
    } catch (e) {
      return Left('Gagal mengambil profil pasien: $e');
    }
  }
}
