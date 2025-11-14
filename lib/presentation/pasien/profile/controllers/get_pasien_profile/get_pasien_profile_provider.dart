import 'package:aconsia_app/presentation/pasien/profile/controllers/pasien_profile_impl_provider.dart';
import 'package:aconsia_app/presentation/pasien/profile/domain/usecases/get_pasien_profile.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'get_pasien_profile_provider.g.dart';

@riverpod
GetPasienProfile getPasienProfile(GetPasienProfileRef ref) {
  return GetPasienProfile(
      repository: ref.read(pasienProfileRepositoryProvider));
}
