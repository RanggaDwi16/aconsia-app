import 'package:aconsia_app/assignment/controllers/is_konten_assigned/is_konten_assigned_provider.dart';
import 'package:aconsia_app/assignment/domain/usecases/is_konten_assigned.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'fetch_is_konten_assigned_provider.g.dart';

@riverpod
class FetchIsKontenAssigned extends _$FetchIsKontenAssigned {
  @override
  FutureOr<bool?> build(
      {required String pasienId, required String kontenId}) async {
    state = const AsyncLoading();

    IsKontenAssigned isKontenAssignedUseCase =
        ref.watch(isKontenAssignedProvider);

    final result = await isKontenAssignedUseCase.call(
      IsKontenAssignedParams(pasienId: pasienId, kontenId: kontenId),
    );

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
