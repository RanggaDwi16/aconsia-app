import 'package:aconsia_app/core/main/data/models/pasien_profile_model.dart';
import 'package:aconsia_app/presentation/pasien/profile/controllers/update_pasien_profile/update_pasien_profile_provider.dart';
import 'package:aconsia_app/presentation/pasien/profile/domain/usecases/update_pasien_profile.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'patch_pasien_profile_provider.g.dart';

@Riverpod(keepAlive: true)
class PatchPasienProfile extends _$PatchPasienProfile {
  @override
  FutureOr<String?> build() {
    return null;
  }

  Future<void> patchPasienProfile({
    required PasienProfileModel pasienProfile,
    required Function(String message) onSuccess,
    required Function(String error) onError,
  }) async {
    state = const AsyncLoading();

    UpdatePasienProfile updatePasienProfile =
        ref.read(updatePasienProfileProvider);
    final result = await updatePasienProfile(
      UpdatePasienProfileParams(updatedProfile: pasienProfile),
    );

    result.fold(
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
