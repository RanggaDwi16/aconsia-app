import 'package:aconsia_app/core/main/data/models/konten_model.dart';
import 'package:aconsia_app/core/main/data/models/konten_section_model.dart';
import 'package:aconsia_app/presentation/dokter/konten/controllers/create_konten/create_konten_provider.dart';
import 'package:aconsia_app/presentation/dokter/konten/domain/usecases/create_konten.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'post_create_konten_provider.g.dart';

@Riverpod(keepAlive: true)
class PostCreateKonten extends _$PostCreateKonten {
  @override
  FutureOr<String?> build() {
    return null;
  }

  Future<void> postCreateKonten({
    required KontenModel konten,
    required List<KontenSectionModel> sections,
    required Function(String message) onSuccess,
    required Function(String error) onError,
  }) async {
    state = const AsyncLoading();

    CreateKonten createKonten = ref.read(createKontenProvider);
    final result = await createKonten(
      CreateKontenParams(
        konten: konten,
        sections: sections,
      ),
    );

    return result.fold(
      (failure) {
        state = AsyncError(failure, StackTrace.current);
        onError(failure);
      },
      (kontenId) {
        state = AsyncData(kontenId);
        onSuccess(kontenId);
      },
    );
  }
}
