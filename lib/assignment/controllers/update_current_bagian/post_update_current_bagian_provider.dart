import 'package:aconsia_app/assignment/controllers/update_current_bagian/update_current_bagian_provider.dart';
import 'package:aconsia_app/assignment/domain/usecases/update_current_bagian.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'post_update_current_bagian_provider.g.dart';

@Riverpod(keepAlive: true)
class PostUpdateCurrentBagian extends _$PostUpdateCurrentBagian {
  @override
  FutureOr<String?> build() {
    return null;
  }

  Future<void> postUpdateCurrentBagian({
    required UpdateCurrentBagianParams params,
    required Function(String message) onSuccess,
    required Function(String errorMessage) onError,
  }) async {
    state = const AsyncLoading();

    final updateCurrentBagianUseCase = ref.read(updateCurrentBagianProvider);

    final result = await updateCurrentBagianUseCase(params);

    result.fold(
      (error) {
        state = AsyncError(error, StackTrace.current);
        onError(error.toString());
        return null;
      },
      (data) {
        state = AsyncData(data);
        onSuccess(data);
        return data;
      },
    );
  }
}
