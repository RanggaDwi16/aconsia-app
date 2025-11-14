import 'package:aconsia_app/assignment/controllers/assignment_impl_provider.dart';
import 'package:aconsia_app/assignment/domain/usecases/get_incomplete_assignments.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'get_incomplete_assignments_provider.g.dart';

@riverpod
GetIncompleteAssignments getIncompleteAssignments (GetIncompleteAssignmentsRef ref) {
  return GetIncompleteAssignments(
    repository: ref.read(assignmentRepositoryProvider),
  );
}