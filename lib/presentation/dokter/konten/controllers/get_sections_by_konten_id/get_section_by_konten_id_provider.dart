import 'package:aconsia_app/presentation/dokter/konten/controllers/dokter_konten_impl_provider.dart';
import 'package:aconsia_app/presentation/dokter/konten/domain/usecases/get_sections_by_konten_id.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'get_section_by_konten_id_provider.g.dart';

@riverpod
GetSectionsByKontenId getSectionsByKontenId(GetSectionsByKontenIdRef ref) {
  return GetSectionsByKontenId(
    repository: ref.read(dokterKontenRepositoryProvider),
  );
}
