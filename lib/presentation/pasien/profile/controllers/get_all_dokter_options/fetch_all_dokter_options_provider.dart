import 'package:aconsia_app/core/main/data/models/dokter_profile_model.dart';
import 'package:aconsia_app/presentation/pasien/profile/controllers/get_all_dokter_options/get_all_dokter_options_provider.dart';
import 'package:aconsia_app/presentation/pasien/profile/domain/usecases/get_all_dokter_options.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'fetch_all_dokter_options_provider.g.dart';

@riverpod
class FetchAllDokterOptions extends _$FetchAllDokterOptions {
  @override
  FutureOr<List<DokterProfileModel>?> build() async {
    state = const AsyncLoading();

    GetAllDokterOptions getAllDokterOptions =
        ref.read(getAllDokterOptionsProvider);

    final result = await getAllDokterOptions(null);

    return result.fold(
      (failure) {
        state = AsyncError(failure, StackTrace.current);
        return null;
      },
      (dokterList) {
        state = AsyncData(dokterList);
        return dokterList;
      },
    );
  }
}
