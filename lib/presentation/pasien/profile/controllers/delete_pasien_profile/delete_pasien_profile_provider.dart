import 'package:aconsia_app/presentation/pasien/profile/controllers/pasien_profile_impl_provider.dart';
import 'package:aconsia_app/presentation/pasien/profile/domain/usecases/delete_pasien_profile.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'delete_pasien_profile_provider.g.dart';

@riverpod
DeletePasienProfile deletePasienProfile (DeletePasienProfileRef ref) {
  return DeletePasienProfile(
      repository: ref.read(pasienProfileRepositoryProvider));
}