import 'package:aconsia_app/presentation/dokter/profile/controllers/update_dokter_photo_url/update_dokter_photo_url_provider.dart';
import 'package:aconsia_app/presentation/dokter/profile/domain/usecases/update_dokter_photo_url.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'patch_dokter_photo_url_provider.g.dart';

@Riverpod(keepAlive: true)
class PatchDokterPhotoUrl extends _$PatchDokterPhotoUrl {
  @override
  FutureOr<String?> build() {
    return null;
  }

  Future<void> updatePhotoUrl({
    required String uid,
    required String photoUrl,
    required Function(String message) onSuccess,
    required Function(String error) onError,
  }) async {
    state = const AsyncLoading();

    final updateDokterPhotoUrl = ref.watch(updateDokterPhotoUrlProvider);
    final result = await updateDokterPhotoUrl(
      UpdateDokterPhotoUrlParams(uid: uid, photoUrl: photoUrl),
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
