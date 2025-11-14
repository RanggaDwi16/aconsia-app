import 'package:aconsia_app/presentation/dokter/home/controllers/home_impl_provider.dart';
import 'package:aconsia_app/presentation/dokter/home/domain/usecases/get_pasien_profile_by_id.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'get_pasien_profile_by_id_provider.g.dart';

@riverpod
GetPasienProfileById getPasienProfileById (GetPasienProfileByIdRef ref) {
  return GetPasienProfileById(
    repository: ref.read(homeRepositoryProvider),
  );
}