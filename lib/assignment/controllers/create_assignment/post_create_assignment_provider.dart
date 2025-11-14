import 'package:aconsia_app/assignment/controllers/assignment_impl_provider.dart';
import 'package:aconsia_app/assignment/controllers/create_assignment/create_assignment_provider.dart';
import 'package:aconsia_app/assignment/domain/usecases/create_assignment.dart';
import 'package:aconsia_app/core/main/data/models/konten_assignment_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'post_create_assignment_provider.g.dart';

@Riverpod(keepAlive: true)
class PostCreateAssignment extends _$PostCreateAssignment {
  @override
  FutureOr<KontenAssignmentModel?> build() {
    return null;
  }

  Future<void> postCreateAssignmen({
    required KontenAssignmentModel assignment,
    required Function(KontenAssignmentModel data) onSuccess,
    required Function(String error) onError,
  }) async {
    state = const AsyncLoading();

    CreateAssignment createAssignmentUseCase =
        ref.watch(createAssignmentProvider);

    final result = await createAssignmentUseCase
        .call(CreateAssignmentParams(assignment: assignment));
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
