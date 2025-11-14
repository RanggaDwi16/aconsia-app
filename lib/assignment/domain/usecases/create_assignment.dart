import 'package:aconsia_app/assignment/domain/repository/assignment_repository.dart';
import 'package:aconsia_app/core/utils/usecase/usecase.dart';
import 'package:aconsia_app/core/main/data/models/konten_assignment_model.dart';
import 'package:dartz/dartz.dart';

class CreateAssignment implements UseCase<KontenAssignmentModel, CreateAssignmentParams> {
  final AssignmentRepository repository;

  CreateAssignment({required this.repository});

  @override
  Future<Either<String, KontenAssignmentModel>> call(
      CreateAssignmentParams params) {
    return repository.createAssignment(assignment: params.assignment);
  }
}

class CreateAssignmentParams {
  final KontenAssignmentModel assignment;

  CreateAssignmentParams({required this.assignment});
}