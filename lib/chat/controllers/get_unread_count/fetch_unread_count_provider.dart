import 'package:aconsia_app/chat/controllers/chat_impl_provider.dart';
import 'package:aconsia_app/chat/controllers/get_unread_count/get_unread_count_provider.dart';
import 'package:aconsia_app/chat/domain/usecases/get_unread_count.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'fetch_unread_count_provider.g.dart';

@riverpod
class FetchUnreadCount extends _$FetchUnreadCount {
  @override
  FutureOr<int?> build({required GetUnreadCountParams params}) async {
    state = const AsyncLoading();

    GetUnreadCount usecase = ref.watch(getUnreadCountProvider);

    final result = await usecase.call(params);

    return result.fold(
      (error) {
        state = AsyncError(error, StackTrace.current);
        return null;
      },
      (data) {
        state = AsyncData(data);
        return data;
      },
    );
  }
}