import 'package:aconsia_app/presentation/dokter/konten/controllers/dokter_konten_impl_provider.dart';
import 'package:aconsia_app/presentation/dokter/konten/domain/usecases/get_konten_count_by_dokter_id.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'get_konten_count_by_dokter_id_provider.g.dart';

@riverpod
GetKontenCountByDokterId getKontenCountByDokterId(
    GetKontenCountByDokterIdRef ref) {
  return GetKontenCountByDokterId(
    repository: ref.read(dokterKontenRepositoryProvider),
  );
}
