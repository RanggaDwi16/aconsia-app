import 'package:aconsia_app/assignment/controllers/assignment_impl_provider.dart';
import 'package:aconsia_app/assignment/controllers/delete_assignment/delete_assignment_provider.dart';
import 'package:aconsia_app/assignment/domain/usecases/delete_assignment.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'put_assignment_provider.g.dart';

@Riverpod(keepAlive: true)
class PutAssignment extends _$PutAssignment {
  @override
  FutureOr<String?> build() {
    return null;
  }

  Future<void> deleteAssignment({
    required String assignmentId,
    required Function(String data) onSuccess,
    required Function(String error) onError,
  }) async {
    state = const AsyncLoading();

    DeleteAssignment deleteAssignmentUseCase = ref.watch(deleteAssignmentProvider);

    final result = await deleteAssignmentUseCase
        .call(DeleteAssignmentParams(assignmentId: assignmentId));
    result.fold(
      (error) {
        state = AsyncError(error, StackTrace.current);
        onError(error);
      },
      (data) {
        state = AsyncData(data);
        onSuccess(data);
      },
    );
  }
}
