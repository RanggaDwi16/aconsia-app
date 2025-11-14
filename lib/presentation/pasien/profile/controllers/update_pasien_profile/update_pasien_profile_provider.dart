import 'package:aconsia_app/presentation/pasien/profile/controllers/pasien_profile_impl_provider.dart';
import 'package:aconsia_app/presentation/pasien/profile/domain/usecases/update_pasien_profile.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'update_pasien_profile_provider.g.dart';

@riverpod
UpdatePasienProfile updatePasienProfile(UpdatePasienProfileRef ref) {
  return UpdatePasienProfile(
      repository: ref.read(pasienProfileRepositoryProvider));
}
