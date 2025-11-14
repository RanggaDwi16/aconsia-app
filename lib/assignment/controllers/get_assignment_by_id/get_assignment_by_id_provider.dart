import 'package:aconsia_app/assignment/controllers/assignment_impl_provider.dart';
import 'package:aconsia_app/assignment/domain/usecases/get_assignment_by_id.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'get_assignment_by_id_provider.g.dart';

@riverpod
GetAssignmentById getAssignmentById (GetAssignmentByIdRef ref) {
  return GetAssignmentById( repository: 
    ref.read(assignmentRepositoryProvider),
  );
}