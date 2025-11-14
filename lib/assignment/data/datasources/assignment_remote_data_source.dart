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
}

class AssignmentRemoteDataSourceImpl implements AssignmentRemoteDataSource {
  final FirebaseFirestore firestore;

  AssignmentRemoteDataSourceImpl({required this.firestore});
  
  @override
  Future<Either<String, KontenAssignmentModel>> createAssignment({required KontenAssignmentModel assignment}) async {
     try {
      final ref = firestore.collection('konten_assignments').doc();
      final assignmentWithId = assignment.copyWith(id: ref.id);

      await ref.set(KontenAssignmentModel.toFirestore(assignmentWithId));
      return Right(assignmentWithId);
    } catch (e) {
      return Left('Gagal assign konten: $e');
    }
  }
  
  @override
  Future<Either<String, String>> deleteAssignment({required String assignmentId})  async{
     try {
      await firestore
          .collection('konten_assignments')
          .doc(assignmentId)
          .delete();
      return const Right('Assignment berhasil dihapus');
    } catch (e) {
      return Left('Gagal menghapus assignment: $e');
    }
  }
  
  @override
  Future<Either<String, KontenAssignmentModel>> getAssignmentById({required String assignmentId}) async {
     try {
      final doc = await firestore
          .collection('konten_assignments')
          .doc(assignmentId)
          .get();

      if (!doc.exists) {
        return Left('Assignment tidak ditemukan.');
      }

      return Right(KontenAssignmentModel.fromFirestore(doc));
    } catch (e) {
      return Left('Gagal mengambil assignment: $e');
    }
  }
  
  @override
  Future<Either<String, List<KontenAssignmentModel>>> getAssignmentsByPasien({required String pasienId}) async {
     try {
      final snapshot = await firestore
          .collection('konten_assignments')
          .where('pasienId', isEqualTo: pasienId)
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
  Future<Either<String, double>> getCompletionPercentage({required String pasienId}) async {
    try {
      final allAssignments = await firestore
          .collection('konten_assignments')
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
  Future<Either<String, List<KontenAssignmentModel>>> getIncompleteAssignments({required String pasienId})  async{
      try {
      final snapshot = await firestore
          .collection('konten_assignments')
          .where('pasienId', isEqualTo: pasienId)
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
  Future<Either<String, bool>> isKontenAssigned({required String pasienId, required String kontenId})  async{
    try {
      final snapshot = await firestore
          .collection('konten_assignments')
          .where('pasienId', isEqualTo: pasienId)
          .where('kontenId', isEqualTo: kontenId)
          .limit(1)
          .get();

      return Right(snapshot.docs.isNotEmpty);
    } catch (e) {
      return Left('Gagal memeriksa assignment: $e');
    }
  }
  
  @override
  Future<Either<String, String>> markAsCompleted({required String assignmentId}) async{
    try {
      await firestore
          .collection('konten_assignments')
          .doc(assignmentId)
          .update({
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
  Future<Either<String, String>> updateCurrentBagian({required String assignmentId, required int bagianNumber})  async{
    try {
      await firestore
          .collection('konten_assignments')
          .doc(assignmentId)
          .update({
        'currentBagian': bagianNumber,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      return const Right('Progress berhasil diupdate');
    } catch (e) {
      return Left('Gagal update progress: $e');
    }
  }
}
