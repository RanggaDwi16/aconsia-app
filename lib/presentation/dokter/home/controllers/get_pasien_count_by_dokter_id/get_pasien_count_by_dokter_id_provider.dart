import 'package:aconsia_app/presentation/dokter/home/controllers/home_impl_provider.dart';
import 'package:aconsia_app/presentation/dokter/home/domain/usecases/get_pasien_count_by_dokter_id.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'get_pasien_count_by_dokter_id_provider.g.dart';

@riverpod
GetPasienCountByDokterId getPasienCountByDokterId(
    GetPasienCountByDokterIdRef ref) {
  return GetPasienCountByDokterId(
    repository: ref.watch(homeRepositoryProvider),
  );
}
