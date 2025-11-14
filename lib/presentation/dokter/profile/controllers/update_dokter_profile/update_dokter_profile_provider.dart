import 'package:aconsia_app/presentation/dokter/profile/controllers/dokter_profile_impl_provider.dart';
import 'package:aconsia_app/presentation/dokter/profile/domain/usecases/update_dokter_profile.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'update_dokter_profile_provider.g.dart';

@riverpod
UpdateDokterProfile updateDokterProfile(UpdateDokterProfileRef ref) {
  return UpdateDokterProfile(
    repository: ref.watch(dokterProfileRepositoryProvider),
  );
}
