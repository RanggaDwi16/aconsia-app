import 'package:aconsia_app/assignment/domain/repository/assignment_repository.dart';
import 'package:aconsia_app/core/utils/usecase/usecase.dart';
import 'package:aconsia_app/core/main/data/models/konten_assignment_model.dart';
import 'package:dartz/dartz.dart';

class GetAssignmentById
    implements UseCase<KontenAssignmentModel, GetAssignmentByIdParams> {
  final AssignmentRepository repository;

  GetAssignmentById({required this.repository});

  @override
  Future<Either<String, KontenAssignmentModel>> call(
      GetAssignmentByIdParams params) {
    return repository.getAssignmentById(assignmentId: params.assignmentId);
  }
}

class GetAssignmentByIdParams {
  final String assignmentId;

  GetAssignmentByIdParams({required this.assignmentId});
}
