import 'package:aconsia_app/assignment/controllers/assignment_impl_provider.dart';
import 'package:aconsia_app/assignment/controllers/get_incomplete_assignments/get_incomplete_assignments_provider.dart';
import 'package:aconsia_app/assignment/domain/usecases/get_incomplete_assignments.dart';
import 'package:aconsia_app/core/main/data/models/konten_assignment_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'fetch_incomplete_assignments_provider.g.dart';

@riverpod
class FetchIncompleteAssignments extends _$FetchIncompleteAssignments {
  @override
  FutureOr<List<KontenAssignmentModel>?> build(
      {required String pasienId}) async {
    state = const AsyncLoading();

    GetIncompleteAssignments getIncompleteAssignmentsUseCase =
        ref.watch(getIncompleteAssignmentsProvider);
    final result = await getIncompleteAssignmentsUseCase
        .call(GetIncompleteAssignmentsParams(pasienId: pasienId));

    return result.fold(
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
