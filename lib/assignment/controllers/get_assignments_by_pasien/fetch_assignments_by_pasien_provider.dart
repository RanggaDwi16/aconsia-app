import 'package:aconsia_app/assignment/controllers/assignment_impl_provider.dart';
import 'package:aconsia_app/assignment/controllers/get_assignments_by_pasien/get_assignments_by_pasien_provider.dart';
import 'package:aconsia_app/assignment/domain/usecases/get_assignments_by_pasien.dart';
import 'package:aconsia_app/core/main/data/models/konten_assignment_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'fetch_assignments_by_pasien_provider.g.dart';

@riverpod
class FetchAssignmentsByPasien extends _$FetchAssignmentsByPasien {
  @override
  FutureOr<List<KontenAssignmentModel>?> build(
      {required String pasienId}) async {
    state = const AsyncLoading();

    GetAssignmentsByPasien getAssignmentsByPasienUseCase = ref.watch(getAssignmentsByPasienProvider);

    final result = await getAssignmentsByPasienUseCase
        .call(GetAssignmentsByPasienParams(pasienId: pasienId));

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
