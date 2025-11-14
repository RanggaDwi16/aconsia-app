import 'package:aconsia_app/presentation/dokter/konten/controllers/dokter_konten_impl_provider.dart';
import 'package:aconsia_app/presentation/dokter/konten/domain/usecases/update_section.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'update_section_provider.g.dart';

@riverpod
UpdateSection updateSection(UpdateSectionRef ref) {
  return UpdateSection(repository: ref.read(dokterKontenRepositoryProvider));
}
