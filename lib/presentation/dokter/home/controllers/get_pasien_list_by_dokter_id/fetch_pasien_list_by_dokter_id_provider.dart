import 'package:aconsia_app/core/main/data/models/pasien_profile_model.dart';
import 'package:aconsia_app/presentation/dokter/home/controllers/get_pasien_list_by_dokter_id/get_pasien_list_by_dokter_id_provider.dart';
import 'package:aconsia_app/presentation/dokter/home/domain/usecases/get_pasien_list_by_dokter_id.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'fetch_pasien_list_by_dokter_id_provider.g.dart';

@riverpod
class FetchPasienListByDokterId extends _$FetchPasienListByDokterId {
  @override
  FutureOr<List<PasienProfileModel>?> build({required String dokterId}) async {
    state = const AsyncLoading();

    GetPasienListByDokterId getPasienListByDokterId =
        ref.read(getPasienListByDokterIdProvider);

    final result = await getPasienListByDokterId(
      GetPasienListByDokterIdParams(dokterId: dokterId),
    );

    return result.fold(
      (failure) {
        state = AsyncError(failure, StackTrace.current);
        return null;
      },
      (pasienList) {
        state = AsyncData(pasienList);
        return pasienList;
      },
    );
  }
}
