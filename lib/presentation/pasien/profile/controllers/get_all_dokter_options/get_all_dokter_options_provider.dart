import 'package:aconsia_app/presentation/pasien/profile/controllers/pasien_profile_impl_provider.dart';
import 'package:aconsia_app/presentation/pasien/profile/domain/usecases/get_all_dokter_options.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'get_all_dokter_options_provider.g.dart';

@riverpod
GetAllDokterOptions getAllDokterOptions(GetAllDokterOptionsRef ref) {
  return GetAllDokterOptions(
    repository: ref.read(pasienProfileRepositoryProvider),
  );
}
