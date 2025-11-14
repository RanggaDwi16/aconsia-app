import 'package:aconsia_app/notification/controllers/get_unread_count/get_unread_count_provider.dart';
import 'package:aconsia_app/notification/domain/usecases/get_unread_count.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'fetch_unread_count_provider.g.dart';

@riverpod
class FetchUnreadCount extends _$FetchUnreadCount {
  @override
  FutureOr<int?> build({required GetUnreadCountParams params}) async {
    state = const AsyncLoading();
    GetUnreadCount getUnreadCount = ref.read(getUnreadCountProvider);

    final result = await getUnreadCount(params);

    return result.fold(
      (error) {
        state = AsyncError(error, StackTrace.current);
        return null;
      },
      (count) {
        state = AsyncData(count);
        return count;
      },
    );
  }
}
