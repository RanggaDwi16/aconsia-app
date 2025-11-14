import 'package:aconsia_app/assignment/domain/repository/assignment_repository.dart';
import 'package:aconsia_app/core/utils/usecase/usecase.dart';
import 'package:aconsia_app/core/main/data/models/konten_assignment_model.dart';
import 'package:dartz/dartz.dart';

class GetAssignmentsByPasien
    implements
        UseCase<List<KontenAssignmentModel>, GetAssignmentsByPasienParams> {
  final AssignmentRepository repository;
  GetAssignmentsByPasien({required this.repository});

  @override
  Future<Either<String, List<KontenAssignmentModel>>> call(params) {
    return repository.getAssignmentsByPasien(pasienId: params.pasienId);
  }
}

class GetAssignmentsByPasienParams {
  final String pasienId;
  GetAssignmentsByPasienParams({required this.pasienId});
}
