import 'package:aconsia_app/presentation/pasien/profile/controllers/delete_pasien_profile/delete_pasien_profile_provider.dart';
import 'package:aconsia_app/presentation/pasien/profile/domain/usecases/delete_pasien_profile.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'put_pasien_profile_provider.g.dart';

@Riverpod(keepAlive: true)
class PutPasienProfile extends _$PutPasienProfile {
  @override
  FutureOr<String?> build() {
    return null;
  }

  Future<void> putPasienProfile({
    required String pasienId,
    required Function(String message) onSuccess,
    required Function(String error) onError,
  }) async {
    state = const AsyncLoading();
    DeletePasienProfile deletePasienProfile =
        ref.read(deletePasienProfileProvider);
    final result = await deletePasienProfile(
      DeletePasienProfileParams(uid: pasienId),
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
