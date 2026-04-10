import 'package:aconsia_app/core/main/data/models/konten_assignment_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';

abstract class AssignmentRemoteDataSource {
  Future<Either<String, KontenAssignmentModel>> createAssignment({
    required KontenAssignmentModel assignment,
  });

  Future<Either<String, List<KontenAssignmentModel>>> getAssignmentsByPasien({
    required String pasienId,
  });

  Future<Either<String, List<KontenAssignmentModel>>> getIncompleteAssignments({
    required String pasienId,
  });

  Future<Either<String, String>> updateCurrentBagian({
    required String assignmentId,
    required int bagianNumber,
  });

  Future<Either<String, String>> markAsCompleted({
    required String assignmentId,
  });

  Future<Either<String, bool>> isKontenAssigned({
    required String pasienId,
    required String kontenId,
  });

  Future<Either<String, String>> deleteAssignment({
    required String assignmentId,
  });

  Future<Either<String, KontenAssignmentModel>> getAssignmentById({
    required String assignmentId,
  });

  Future<Either<String, double>> getCompletionPercentage({
    required String pasienId,
  });

  Future<Either<String, List<KontenAssignmentModel>>>
      getAssignmentsByDokterAndKonten({
    required String dokterId,
    required String kontenId,
  });

  Future<Either<String, String>> cancelAssignments({
    required String dokterId,
    required String kontenId,
    required List<String> pasienIds,
  });

  Future<Either<String, String>> cancelAllAssignmentsByKonten({
    required String dokterId,
    required String kontenId,
  });
}

class AssignmentRemoteDataSourceImpl implements AssignmentRemoteDataSource {
  final FirebaseFirestore firestore;
  static const _collection = 'assignments';

  AssignmentRemoteDataSourceImpl({required this.firestore});

  @override
  Future<Either<String, KontenAssignmentModel>> createAssignment(
      {required KontenAssignmentModel assignment}) async {
    try {
      final kontenId = assignment.kontenId.trim();
      if (kontenId.isEmpty) {
        return const Left('Konten tidak valid untuk di-assign.');
      }

      final kontenSnapshot =
          await firestore.collection('konten').doc(kontenId).get();
      if (!kontenSnapshot.exists || kontenSnapshot.data() == null) {
        return const Left('Konten tidak ditemukan.');
      }

      final kontenStatus = (kontenSnapshot.data()!['status'] as String? ?? '')
          .trim()
          .toLowerCase();
      if (kontenStatus != 'published') {
        return const Left(
          'Konten draft belum bisa di-assign. Publish via Admin terlebih dahulu.',
        );
      }

      final docId = '${assignment.kontenId}_${assignment.pasienId}';
      final ref = firestore.collection(_collection).doc(docId);
      final assignmentWithId = assignment.copyWith(id: docId);

      await ref.set({
        ...KontenAssignmentModel.toFirestore(assignmentWithId),
        'dokterId': assignment.assignedBy,
        'status': 'assigned',
      }, SetOptions(merge: true));
      return Right(assignmentWithId);
    } catch (e) {
      return Left('Gagal assign konten: $e');
    }
  }

  @override
  Future<Either<String, String>> deleteAssignment(
      {required String assignmentId}) async {
    try {
      await firestore.collection(_collection).doc(assignmentId).delete();
      return const Right('Assignment berhasil dihapus');
    } catch (e) {
      return Left('Gagal menghapus assignment: $e');
    }
  }

  @override
  Future<Either<String, KontenAssignmentModel>> getAssignmentById(
      {required String assignmentId}) async {
    try {
      final doc =
          await firestore.collection(_collection).doc(assignmentId).get();

      if (!doc.exists) {
        return Left('Assignment tidak ditemukan.');
      }

      return Right(KontenAssignmentModel.fromFirestore(doc));
    } catch (e) {
      return Left('Gagal mengambil assignment: $e');
    }
  }

  @override
  Future<Either<String, List<KontenAssignmentModel>>> getAssignmentsByPasien(
      {required String pasienId}) async {
    try {
      final snapshot = await firestore
          .collection(_collection)
          .where('pasienId', isEqualTo: pasienId)
          .where('status', whereIn: ['assigned', 'active'])
          .orderBy('assignedAt', descending: true)
          .get();

      final assignments = snapshot.docs
          .map((doc) => KontenAssignmentModel.fromFirestore(doc))
          .toList();

      return Right(assignments);
    } catch (e) {
      return Left('Gagal mengambil assignments: $e');
    }
  }

  @override
  Future<Either<String, double>> getCompletionPercentage(
      {required String pasienId}) async {
    try {
      final allAssignments = await firestore
          .collection(_collection)
          .where('pasienId', isEqualTo: pasienId)
          .get();

      if (allAssignments.docs.isEmpty) {
        return const Right(0.0);
      }

      final completedCount = allAssignments.docs
          .where((doc) => doc.data()['isCompleted'] == true)
          .length;

      final percentage = (completedCount / allAssignments.docs.length) * 100;
      return Right(percentage);
    } catch (e) {
      return Left('Gagal mengambil persentase penyelesaian: $e');
    }
  }

  @override
  Future<Either<String, List<KontenAssignmentModel>>> getIncompleteAssignments(
      {required String pasienId}) async {
    try {
      final snapshot = await firestore
          .collection(_collection)
          .where('pasienId', isEqualTo: pasienId)
          .where('status', whereIn: ['assigned', 'active'])
          .where('isCompleted', isEqualTo: false)
          .orderBy('assignedAt', descending: true)
          .get();

      final assignments = snapshot.docs
          .map((doc) => KontenAssignmentModel.fromFirestore(doc))
          .toList();

      return Right(assignments);
    } catch (e) {
      return Left('Gagal mengambil incomplete assignments: $e');
    }
  }

  @override
  Future<Either<String, bool>> isKontenAssigned(
      {required String pasienId, required String kontenId}) async {
    try {
      final snapshot = await firestore
          .collection(_collection)
          .where('pasienId', isEqualTo: pasienId)
          .where('kontenId', isEqualTo: kontenId)
          .where('status', whereIn: ['assigned', 'active'])
          .limit(1)
          .get();

      return Right(snapshot.docs.isNotEmpty);
    } catch (e) {
      return Left('Gagal memeriksa assignment: $e');
    }
  }

  @override
  Future<Either<String, String>> markAsCompleted(
      {required String assignmentId}) async {
    try {
      await firestore.collection(_collection).doc(assignmentId).update({
        'isCompleted': true,
        'completedAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      return const Right('Assignment marked as completed');
    } catch (e) {
      return Left('Gagal menandai sebagai selesai: $e');
    }
  }

  @override
  Future<Either<String, String>> updateCurrentBagian(
      {required String assignmentId, required int bagianNumber}) async {
    try {
      await firestore.collection(_collection).doc(assignmentId).update({
        'currentBagian': bagianNumber,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      return const Right('Progress berhasil diupdate');
    } catch (e) {
      return Left('Gagal update progress: $e');
    }
  }

  @override
  Future<Either<String, List<KontenAssignmentModel>>>
      getAssignmentsByDokterAndKonten({
    required String dokterId,
    required String kontenId,
  }) async {
    try {
      final snapshot = await firestore
          .collection(_collection)
          .where('dokterId', isEqualTo: dokterId)
          .where('kontenId', isEqualTo: kontenId)
          .where('status', whereIn: ['assigned', 'active'])
          .orderBy('assignedAt', descending: true)
          .get();

      final assignments = snapshot.docs
          .map((doc) => KontenAssignmentModel.fromFirestore(doc))
          .toList();
      return Right(assignments);
    } catch (e) {
      return Left('Gagal mengambil assignment dokter: $e');
    }
  }

  @override
  Future<Either<String, String>> cancelAssignments({
    required String dokterId,
    required String kontenId,
    required List<String> pasienIds,
  }) async {
    try {
      final validPasienIds = pasienIds
          .map((item) => item.trim())
          .where((item) => item.isNotEmpty)
          .toSet()
          .toList();
      if (validPasienIds.isEmpty) {
        return const Left('Pilih minimal 1 pasien.');
      }

      final batch = firestore.batch();
      for (final pasienId in validPasienIds) {
        final assignmentId = '${kontenId}_$pasienId';
        final assignmentRef =
            firestore.collection(_collection).doc(assignmentId);
        batch.set(
            assignmentRef,
            {
              'status': 'cancelled',
              'cancelledBy': dokterId,
              'cancelledAt': FieldValue.serverTimestamp(),
              'updatedAt': FieldValue.serverTimestamp(),
            },
            SetOptions(merge: true));
      }
      await batch.commit();
      return Right(
          'Berhasil membatalkan assignment ${validPasienIds.length} pasien.');
    } catch (e) {
      return Left('Gagal membatalkan assignment: $e');
    }
  }

  @override
  Future<Either<String, String>> cancelAllAssignmentsByKonten({
    required String dokterId,
    required String kontenId,
  }) async {
    try {
      final snapshot = await firestore
          .collection(_collection)
          .where('dokterId', isEqualTo: dokterId)
          .where('kontenId', isEqualTo: kontenId)
          .where('status', whereIn: ['assigned', 'active']).get();

      if (snapshot.docs.isEmpty) {
        return const Right('Tidak ada assignment aktif untuk dibatalkan.');
      }

      final batch = firestore.batch();
      for (final doc in snapshot.docs) {
        batch.set(
            doc.reference,
            {
              'status': 'cancelled',
              'cancelledBy': dokterId,
              'cancelledAt': FieldValue.serverTimestamp(),
              'updatedAt': FieldValue.serverTimestamp(),
            },
            SetOptions(merge: true));
      }
      await batch.commit();
      return Right('Berhasil membatalkan semua assignment untuk konten ini.');
    } catch (e) {
      return Left('Gagal membatalkan semua assignment: $e');
    }
  }
}
