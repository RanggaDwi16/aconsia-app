import 'package:aconsia_app/core/main/data/models/konten_model.dart';
import 'package:aconsia_app/presentation/dokter/konten/controllers/get_konten_by_dokter_id/get_konten_by_dokter_id_provider.dart';
import 'package:aconsia_app/presentation/dokter/konten/domain/usecases/get_konten_by_dokter_id.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'fetch_konten_by_dokter_id_provider.g.dart';

@riverpod
class FetchKontenByDokterId extends _$FetchKontenByDokterId {
  @override
  FutureOr<List<KontenModel>?> build({required String dokterId}) async {
    state = const AsyncLoading();

    GetKontenByDokterId getKontenByDokterId =
        ref.read(getKontenByDokterIdProvider);
    final result = await getKontenByDokterId(
      GetKontenByDokterIdParams(dokterId: dokterId),
    );
    return result.fold(
      (failure) {
        state = AsyncError(failure, StackTrace.current);
        return null;
      },
      (kontenList) {
        state = AsyncData(kontenList);
        return kontenList;
      },
    );
  }
}
