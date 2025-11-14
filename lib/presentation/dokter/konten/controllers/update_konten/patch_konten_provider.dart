import 'package:aconsia_app/core/main/data/models/konten_model.dart';
import 'package:aconsia_app/core/main/data/models/konten_section_model.dart';
import 'package:aconsia_app/presentation/dokter/konten/controllers/update_konten/update_konten_provider.dart';
import 'package:aconsia_app/presentation/dokter/konten/domain/usecases/update_konten.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'patch_konten_provider.g.dart';

@Riverpod(keepAlive: true)
class PatchKonten extends _$PatchKonten {
  @override
  FutureOr<String?> build() {
    return null;
  }

  Future<void> patchKonten({
    required KontenModel konten,
    required KontenSectionModel section,
    required Function(String message) onSuccess,
    required Function(String error) onError,
  }) async {
    state = const AsyncLoading();

    UpdateKonten updateKonten = ref.read(updateKontenProvider);
    final result = await updateKonten(
      UpdateKontenParams(
        konten: konten,
        section: section,
      ),
    );

    result.fold(
      (failure) {
        state = AsyncError(failure, StackTrace.current);
        onError(failure);
      },
      (message) {
        state = AsyncData(message);
        onSuccess(message);
      },
    );
  }
}
