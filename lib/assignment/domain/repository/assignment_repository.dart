import 'package:aconsia_app/core/main/data/models/konten_assignment_model.dart';
import 'package:dartz/dartz.dart';

abstract class AssignmentRepository {
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
