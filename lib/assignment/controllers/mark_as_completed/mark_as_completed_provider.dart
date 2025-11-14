import 'package:aconsia_app/assignment/controllers/assignment_impl_provider.dart';
import 'package:aconsia_app/assignment/domain/usecases/mark_as_completed.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'mark_as_completed_provider.g.dart';

@riverpod
MarkAsCompleted markAsCompleted (MarkAsCompletedRef ref) {
  return MarkAsCompleted(
    repository: ref.read(assignmentRepositoryProvider),
  );
}