import 'package:aconsia_app/presentation/dokter/konten/controllers/delete_konten/delete_konten_provider.dart';
import 'package:aconsia_app/presentation/dokter/konten/domain/usecases/delete_konten.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'put_konten_provider.g.dart';

@Riverpod(keepAlive: true)
class PutKonten extends _$PutKonten {
  @override
  FutureOr<String?> build() {
    return null;
  }

  Future<void> putKonten({
    required String kontenId,
    required Function(String message) onSuccess,
    required Function(String error) onError,
  }) async {
    state = const AsyncLoading();

    DeleteKonten deleteKonten = ref.read(deleteKontenProvider);
    final result = await deleteKonten(DeleteKontenParams(kontenId: kontenId));

    return result.fold(
      (failure) {
        state = AsyncError(failure, StackTrace.current);
        onError(failure);
      },
      (message) {
        state = AsyncData(message);
        onSuccess(message);
      },
    );
  }
}
