import 'package:aconsia_app/core/main/data/models/konten_section_model.dart';
import 'package:aconsia_app/presentation/dokter/konten/controllers/update_section/update_section_provider.dart';
import 'package:aconsia_app/presentation/dokter/konten/domain/usecases/update_section.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'patch_section_provider.g.dart';

@Riverpod(keepAlive: true)
class PatchSection extends _$PatchSection {
  @override
  FutureOr<String?> build() {
    return null;
  }

  Future<void> patchSection({
    required KontenSectionModel section,
    required Function(String message) onSuccess,
    required Function(String error) onError,
  }) async {
    state = const AsyncLoading();

    UpdateSection updateSection = ref.read(updateSectionProvider);

    final result = await updateSection(
      UpdateSectionParams(section: section),
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
