import 'package:aconsia_app/core/main/data/models/dokter_profile_model.dart';
import 'package:aconsia_app/presentation/dokter/profile/controllers/get_dokter_profile/get_dokter_profile_provider.dart';
import 'package:aconsia_app/presentation/dokter/profile/domain/usecases/get_dokter_profile.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'fetch_dokter_profile_provider.g.dart';

@riverpod
class FetchDokterProfile extends _$FetchDokterProfile {
  @override
  FutureOr<DokterProfileModel?> build({required String uid}) async {
    state = const AsyncLoading();

    final getDokterProfile = ref.watch(getDokterProfileProvider);

    final result =
        await getDokterProfile(GetDokterProfileParams(uid: uid));

    return result.fold(
      (error) {
        state = AsyncError(error, StackTrace.current);
        return null;
      },
      (dokterProfile) {
        state = AsyncData(dokterProfile);
        return dokterProfile;
      },
    );
  }
}