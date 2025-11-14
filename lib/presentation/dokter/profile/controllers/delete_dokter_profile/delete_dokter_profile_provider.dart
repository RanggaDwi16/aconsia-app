import 'package:aconsia_app/presentation/dokter/profile/controllers/dokter_profile_impl_provider.dart';
import 'package:aconsia_app/presentation/dokter/profile/domain/usecases/delete_dokter_profile.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'delete_dokter_profile_provider.g.dart';

@riverpod
DeleteDokterProfile deleteDokterProfile(DeleteDokterProfileRef ref) {
  return DeleteDokterProfile(
    repository: ref.watch(dokterProfileRepositoryProvider),
  );
}
