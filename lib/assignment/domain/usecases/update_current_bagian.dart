import 'package:aconsia_app/assignment/domain/repository/assignment_repository.dart';
import 'package:aconsia_app/core/utils/usecase/usecase.dart';
import 'package:dartz/dartz.dart';

class UpdateCurrentBagian
    implements UseCase<String, UpdateCurrentBagianParams> {
  final AssignmentRepository repository;

  UpdateCurrentBagian({required this.repository});

  @override
  Future<Either<String, String>> call(params) {
    return repository.updateCurrentBagian(
        assignmentId: params.assignmentId, bagianNumber: params.bagianNumber);
  }
}

class UpdateCurrentBagianParams {
  final String assignmentId;
  final int bagianNumber;

  UpdateCurrentBagianParams(
      {required this.assignmentId, required this.bagianNumber});
}
