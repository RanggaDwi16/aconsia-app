import 'package:aconsia_app/presentation/dokter/profile/controllers/dokter_profile_impl_provider.dart';
import 'package:aconsia_app/presentation/dokter/profile/domain/usecases/get_dokter_profile.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'get_dokter_profile_provider.g.dart';

@riverpod
GetDokterProfile getDokterProfile(GetDokterProfileRef ref) {
  return GetDokterProfile(
    repository: ref.watch(dokterProfileRepositoryProvider),
  );
}
