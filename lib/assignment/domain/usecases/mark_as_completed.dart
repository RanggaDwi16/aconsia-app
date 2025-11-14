import 'package:aconsia_app/assignment/domain/repository/assignment_repository.dart';
import 'package:aconsia_app/core/utils/usecase/usecase.dart';
import 'package:dartz/dartz.dart';

class MarkAsCompleted implements UseCase<String, MarkAsCompletedParams> {
  final AssignmentRepository repository;

  MarkAsCompleted({required this.repository});

  @override
  Future<Either<String, String>> call(params) {
    return repository.markAsCompleted(assignmentId: params.assignmentId);
  }
}

class MarkAsCompletedParams {
  final String assignmentId;

  MarkAsCompletedParams({required this.assignmentId});
}
