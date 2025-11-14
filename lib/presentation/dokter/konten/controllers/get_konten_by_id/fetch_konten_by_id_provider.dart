import 'package:aconsia_app/core/main/data/models/konten_model.dart';
import 'package:aconsia_app/presentation/dokter/konten/controllers/get_konten_by_id/get_konten_by_id_provider.dart';
import 'package:aconsia_app/presentation/dokter/konten/domain/usecases/get_konten_by_id.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'fetch_konten_by_id_provider.g.dart';

@riverpod
class FetchKontenById extends _$FetchKontenById {
  @override
  FutureOr<KontenModel?> build({required String kontenId}) async {
    state = const AsyncLoading();

    GetKontenById getKontenById = ref.read(getKontenByIdProvider);

    final result = await getKontenById(
      GetKontenByIdParams(kontenId: kontenId),
    );

    return result.fold(
      (failure) {
        state = AsyncError(failure, StackTrace.current);
        return null;
      },
      (konten) {
        state = AsyncData(konten);
        return konten;
      },
    );
  }
}
