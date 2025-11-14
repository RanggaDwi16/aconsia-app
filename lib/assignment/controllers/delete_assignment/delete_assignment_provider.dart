import 'package:aconsia_app/assignment/controllers/assignment_impl_provider.dart';
import 'package:aconsia_app/assignment/domain/usecases/delete_assignment.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'delete_assignment_provider.g.dart';

@riverpod
DeleteAssignment deleteAssignment(DeleteAssignmentRef ref) {
  return DeleteAssignment(
    repository: ref.read(assignmentRepositoryProvider),
  );
}
