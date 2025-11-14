import 'package:aconsia_app/presentation/dokter/konten/controllers/dokter_konten_impl_provider.dart';
import 'package:aconsia_app/presentation/dokter/konten/domain/usecases/get_konten_by_id.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'get_konten_by_id_provider.g.dart';

@riverpod
GetKontenById getKontenById(GetKontenByIdRef ref) {
  return GetKontenById(
    repository: ref.read(dokterKontenRepositoryProvider),
  );
}
