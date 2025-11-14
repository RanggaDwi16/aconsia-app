import 'package:aconsia_app/presentation/dokter/konten/controllers/get_konten_count_by_dokter_id/get_konten_count_by_dokter_id_provider.dart';
import 'package:aconsia_app/presentation/dokter/konten/domain/usecases/get_konten_count_by_dokter_id.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'fetch_konten_count_by_dokter_id_provider.g.dart';

@riverpod
class FetchKontenCountByDokterId extends _$FetchKontenCountByDokterId {
  @override
  FutureOr<int?> build({required String dokterId}) async {
    state = const AsyncLoading();

    GetKontenCountByDokterId getKontenCountByDokterId =
        ref.read(getKontenCountByDokterIdProvider);
    final result = await getKontenCountByDokterId(
      GetKontenCountByDokterIdParams(dokterId: dokterId),
    );
    return result.fold(
      (failure) {
        state = AsyncError(failure, StackTrace.current);
        return null;
      },
      (count) {
        state = AsyncData(count);
        return count;
      },
    );
  }
}
