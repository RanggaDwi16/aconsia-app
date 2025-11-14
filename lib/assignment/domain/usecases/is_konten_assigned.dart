import 'package:aconsia_app/assignment/domain/repository/assignment_repository.dart';
import 'package:aconsia_app/core/utils/usecase/usecase.dart';
import 'package:dartz/dartz.dart';

class IsKontenAssigned implements UseCase<bool, IsKontenAssignedParams> {
  final AssignmentRepository repository;

  IsKontenAssigned({required this.repository});

  @override
  Future<Either<String, bool>> call(params) {
    return repository.isKontenAssigned(
        pasienId: params.pasienId, kontenId: params.kontenId);
  }
}

class IsKontenAssignedParams {
  final String pasienId;
  final String kontenId;

  IsKontenAssignedParams({required this.pasienId, required this.kontenId});
}
