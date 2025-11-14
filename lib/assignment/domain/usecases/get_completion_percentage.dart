import 'package:aconsia_app/assignment/domain/repository/assignment_repository.dart';
import 'package:aconsia_app/core/utils/usecase/usecase.dart';
import 'package:dartz/dartz.dart';

class GetCompletionPercentage
    implements UseCase<double, GetCompletionPercentageParams> {
  final AssignmentRepository repository;

  GetCompletionPercentage({required this.repository});

  @override
  Future<Either<String, double>> call(params) {
    return repository.getCompletionPercentage(pasienId: params.pasienId);
  }
}

class GetCompletionPercentageParams {
  final String pasienId;

  GetCompletionPercentageParams({required this.pasienId});
}
