import 'package:aconsia_app/notification/controllers/mark_all_as_read/mark_all_as_read_provider.dart';
import 'package:aconsia_app/notification/domain/usecases/mark_all_as_read.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'post_mark_all_as_read_provider.g.dart';

@Riverpod(keepAlive: true)
class PostMarkAllAsRead extends _$PostMarkAllAsRead {
  @override
  FutureOr<String?> build() {
    return null;
  }

  Future<void> postMarkAllAsRead({
    required MarkAllAsReadParams params,
    required Function(String message) onSuccess,
    required Function(String error) onError,
  }) async {
    state = const AsyncLoading();
    MarkAllAsRead markAllAsRead = ref.read(markAllAsReadProvider);

    final result = await markAllAsRead(params);

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
