import 'package:aconsia_app/core/main/data/models/pasien_profile_model.dart';
import 'package:aconsia_app/presentation/dokter/home/controllers/get_pasien_profile_by_id/get_pasien_profile_by_id_provider.dart';
import 'package:aconsia_app/presentation/dokter/home/domain/usecases/get_pasien_profile_by_id.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'fetch_pasien_profile_by_id_provider.g.dart';

@riverpod
class FetchPasienProfileById extends _$FetchPasienProfileById {
  @override
  FutureOr<PasienProfileModel?> build({required String pasienId}) async {
    state = const AsyncLoading();

    GetPasienProfileById getPasienProfileById =
        ref.read(getPasienProfileByIdProvider);

    final result = await getPasienProfileById(
      GetPasienProfileByIdParams(pasienId: pasienId),
    );

    return result.fold(
      (failure) {
        state = AsyncError(failure, StackTrace.current);
        return null;
      },
      (profile) {
        state = AsyncData(profile);
        return profile;
      },
    );
  }
}
