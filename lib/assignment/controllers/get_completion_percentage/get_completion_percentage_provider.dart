import 'package:aconsia_app/assignment/controllers/assignment_impl_provider.dart';
import 'package:aconsia_app/assignment/domain/usecases/get_completion_percentage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'get_completion_percentage_provider.g.dart';

@riverpod
GetCompletionPercentage getCompletionPercentage (GetCompletionPercentageRef ref) {
  return GetCompletionPercentage(
    repository: ref.read(assignmentRepositoryProvider),
  );
}