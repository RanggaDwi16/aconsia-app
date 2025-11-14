import 'package:aconsia_app/assignment/domain/repository/assignment_repository.dart';
import 'package:aconsia_app/core/utils/usecase/usecase.dart';
import 'package:dartz/dartz.dart';

class DeleteAssignment implements UseCase<String, DeleteAssignmentParams> {
  final AssignmentRepository repository;

  DeleteAssignment({required this.repository});

  @override
  Future<Either<String, String>> call(DeleteAssignmentParams params) {
    return repository.deleteAssignment(assignmentId: params.assignmentId);
  }
}

class DeleteAssignmentParams {
  final String assignmentId;

  DeleteAssignmentParams({required this.assignmentId});
}