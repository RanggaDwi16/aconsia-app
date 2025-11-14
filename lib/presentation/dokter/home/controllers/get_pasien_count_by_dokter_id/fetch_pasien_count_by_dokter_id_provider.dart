import 'package:aconsia_app/presentation/dokter/home/controllers/get_pasien_count_by_dokter_id/get_pasien_count_by_dokter_id_provider.dart';
import 'package:aconsia_app/presentation/dokter/home/domain/usecases/get_pasien_count_by_dokter_id.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'fetch_pasien_count_by_dokter_id_provider.g.dart';

@riverpod
class FetchPasienCountByDokterId extends _$FetchPasienCountByDokterId {
  @override
  FutureOr<int?> build({required String dokterId}) async {
    state = const AsyncLoading();

    final getPasienCountByDokterId = ref.read(getPasienCountByDokterIdProvider);

    final result = await getPasienCountByDokterId(
      GetPasienCountByDokterIdParams(dokterId: dokterId),
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
