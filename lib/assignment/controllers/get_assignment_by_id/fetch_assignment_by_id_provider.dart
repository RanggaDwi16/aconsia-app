import 'package:aconsia_app/assignment/controllers/assignment_impl_provider.dart';
import 'package:aconsia_app/assignment/controllers/get_assignment_by_id/get_assignment_by_id_provider.dart';
import 'package:aconsia_app/assignment/domain/usecases/get_assignment_by_id.dart';
import 'package:aconsia_app/core/main/data/models/konten_assignment_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'fetch_assignment_by_id_provider.g.dart';

@riverpod
class FetchAssignmentById extends _$FetchAssignmentById {
  @override
  FutureOr<KontenAssignmentModel?> build({required String assignmentId}) async {
    state = const AsyncLoading();

    GetAssignmentById getAssignmentByIdUseCase = ref.watch(getAssignmentByIdProvider);

    final result = await getAssignmentByIdUseCase
        .call(GetAssignmentByIdParams(assignmentId: assignmentId));

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
