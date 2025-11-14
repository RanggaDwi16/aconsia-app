import 'package:aconsia_app/core/main/data/models/konten_section_model.dart';
import 'package:aconsia_app/presentation/dokter/konten/controllers/get_sections_by_konten_id/get_section_by_konten_id_provider.dart';
import 'package:aconsia_app/presentation/dokter/konten/domain/usecases/get_sections_by_konten_id.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'fetch_sections_by_konten_id_provider.g.dart';

@riverpod
class FetchSectionsByKontenId extends _$FetchSectionsByKontenId {
  @override
  FutureOr<List<KontenSectionModel>?> build({required String kontenId}) async {
    state = const AsyncLoading();

    GetSectionsByKontenId getSectionsByKontenId =
        ref.read(getSectionsByKontenIdProvider);

    final result = await getSectionsByKontenId(
      GetSectionsByKontenIdParams(kontenId: kontenId),
    );

    return result.fold(
      (failure) {
        state = AsyncError(failure, StackTrace.current);
        return null;
      },
      (sections) {
        state = AsyncData(sections);
        return sections;
      },
    );
  }
}
