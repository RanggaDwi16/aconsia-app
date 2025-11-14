import 'package:aconsia_app/notification/controllers/mark_as_read/mark_as_read_provider.dart';
import 'package:aconsia_app/notification/domain/usecases/mark_as_read.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'post_mark_as_read_provider.g.dart';

@Riverpod(keepAlive: true)
class PostMarkAsRead extends _$PostMarkAsRead {
  @override
  FutureOr<String?> build() {
    return null;
  }

  Future<void> postMarkAsRead({
    required MarkAsReadParams params,
    required Function(String message) onSuccess,
    required Function(String error) onError,
  }) async {
    state = const AsyncLoading();
    MarkAsRead markAsRead = ref.read(markAsReadProvider);

    final result = await markAsRead(params);

    result.fold(
      (error) {
        state = AsyncError(error, StackTrace.current);
        onError(error);
      },
      (message) {
        state = AsyncData(message);
        onSuccess(message);
      },
    );
  }
}
