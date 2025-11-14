import 'package:aconsia_app/assignment/domain/repository/assignment_repository.dart';
import 'package:aconsia_app/core/utils/usecase/usecase.dart';
import 'package:aconsia_app/core/main/data/models/konten_assignment_model.dart';
import 'package:dartz/dartz.dart';

class GetIncompleteAssignments implements UseCase<List<KontenAssignmentModel>, GetIncompleteAssignmentsParams> {
  final AssignmentRepository repository;

  GetIncompleteAssignments({required this.repository});

  @override
  Future<Either<String, List<KontenAssignmentModel>>> call(params) {
    return repository.getIncompleteAssignments(pasienId: params.pasienId);
  }
}

class GetIncompleteAssignmentsParams {
  final String pasienId;

  GetIncompleteAssignmentsParams({required this.pasienId});
  
}