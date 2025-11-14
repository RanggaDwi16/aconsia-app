import 'package:aconsia_app/assignment/controllers/mark_as_completed/mark_as_completed_provider.dart';
import 'package:aconsia_app/assignment/domain/usecases/mark_as_completed.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'post_mark_as_completed_provider.g.dart';

@Riverpod(keepAlive: true)
class PostMarkAsCompleted extends _$PostMarkAsCompleted {
  @override
  FutureOr<String?> build() {
    return null;
  }

  Future<void> postMarkAsCompleted({
    required String assignmentId,
  }) async {
    state = const AsyncLoading();

    MarkAsCompleted markAsCompletedUseCase = ref.read(markAsCompletedProvider);

    final result = await markAsCompletedUseCase(
        MarkAsCompletedParams(assignmentId: assignmentId));

    result.fold(
      (error) {
        state = AsyncError(error, StackTrace.current);
        return null;
      },
      (data) {
        state = AsyncData(data);
        return data;
      },
    );
  }
}
