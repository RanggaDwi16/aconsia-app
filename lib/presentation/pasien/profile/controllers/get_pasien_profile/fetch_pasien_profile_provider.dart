import 'package:aconsia_app/core/main/data/models/pasien_profile_model.dart';
import 'package:aconsia_app/presentation/pasien/profile/controllers/pasien_profile_impl_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'fetch_pasien_profile_provider.g.dart';

@riverpod
class FetchPasienProfile extends _$FetchPasienProfile {
  @override
  FutureOr<PasienProfileModel?> build({required String pasienId}) async {
    state = const AsyncLoading();

    final pasienProfileRepository = ref.read(pasienProfileRepositoryProvider);

    final result =
        await pasienProfileRepository.getPasienProfile(uid: pasienId);

    return result.fold(
      (failure) {
        state = AsyncError(failure, StackTrace.current);
        return null;
      },
      (pasienProfile) {
        state = AsyncData(pasienProfile);
        return pasienProfile;
      },
    );
  }
}
