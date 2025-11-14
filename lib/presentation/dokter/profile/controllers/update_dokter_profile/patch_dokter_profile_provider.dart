import 'package:aconsia_app/core/main/data/models/dokter_profile_model.dart';
import 'package:aconsia_app/presentation/dokter/profile/controllers/update_dokter_profile/update_dokter_profile_provider.dart';
import 'package:aconsia_app/presentation/dokter/profile/domain/usecases/update_dokter_profile.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'patch_dokter_profile_provider.g.dart';

@Riverpod(keepAlive: true)
class PatchDokterProfile extends _$PatchDokterProfile {
  @override
  FutureOr<String?> build() {
    return null;
  }

  Future<void> updateProfile({
    required DokterProfileModel model,
    required Function(String message) onSuccess,
    required Function(String error) onError,
  }) async {
    state = const AsyncLoading();

    final updateDokterProfile = ref.watch(updateDokterProfileProvider);
    final result = await updateDokterProfile(
      UpdateDokterProfileParams(profile: model),
    );

    await result.fold(
      (error) async {
        state = AsyncError(error, StackTrace.current);
        onError(error);
      },
      (message) async {
        state = AsyncData(message);
        onSuccess(message);
      },
    );
  }
}
