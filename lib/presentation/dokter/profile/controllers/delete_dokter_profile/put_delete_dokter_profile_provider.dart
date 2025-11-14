import 'package:aconsia_app/presentation/dokter/profile/controllers/delete_dokter_profile/delete_dokter_profile_provider.dart';
import 'package:aconsia_app/presentation/dokter/profile/domain/usecases/delete_dokter_profile.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'put_delete_dokter_profile_provider.g.dart';

@Riverpod(keepAlive: true)
class PutDeleteDokterProfile extends _$PutDeleteDokterProfile {
  @override
  FutureOr<String?> build() {
    return null;
  }

  void putDeleteDokterProfile({
    required String uid,
    required Function(String message) onSuccess,
    required Function(String error) onError,
  }) async {
    state = const AsyncLoading();

    final putDeleteDokterProfile = ref.watch(deleteDokterProfileProvider);
    final result = await putDeleteDokterProfile(
      DeleteDokterProfileParams(uid: uid),
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
