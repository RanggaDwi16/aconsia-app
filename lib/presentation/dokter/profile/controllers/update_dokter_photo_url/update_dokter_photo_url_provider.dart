import 'package:aconsia_app/presentation/dokter/profile/controllers/dokter_profile_impl_provider.dart';
import 'package:aconsia_app/presentation/dokter/profile/domain/usecases/update_dokter_photo_url.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'update_dokter_photo_url_provider.g.dart';

@riverpod
UpdateDokterPhotoUrl updateDokterPhotoUrl(UpdateDokterPhotoUrlRef ref) {
  return UpdateDokterPhotoUrl(
    repository: ref.watch(dokterProfileRepositoryProvider),
  );
}
