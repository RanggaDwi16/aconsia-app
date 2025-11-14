import 'package:aconsia_app/assignment/controllers/assignment_impl_provider.dart';
import 'package:aconsia_app/assignment/domain/usecases/create_assignment.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'create_assignment_provider.g.dart';

@riverpod
CreateAssignment createAssignment(CreateAssignmentRef ref) {
  return CreateAssignment(
    repository: ref.read(assignmentRepositoryProvider),
  );
}
