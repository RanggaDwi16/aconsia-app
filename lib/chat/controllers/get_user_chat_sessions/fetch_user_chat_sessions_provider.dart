import 'package:aconsia_app/chat/controllers/chat_impl_provider.dart';
import 'package:aconsia_app/chat/controllers/get_user_chat_sessions/get_user_chat_sessions_provider.dart';
import 'package:aconsia_app/chat/domain/usecases/get_user_chat_sessions.dart';
import 'package:aconsia_app/core/main/data/models/chat_session_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'fetch_user_chat_sessions_provider.g.dart';

@riverpod
class FetchUserChatSessions extends _$FetchUserChatSessions {
  @override
  FutureOr<List<ChatSessionModel>?> build({required GetUserChatSessionsParams params}) async {
    state = const AsyncLoading();

    GetUserChatSessions usecase = ref.watch(getUserChatSessionsProvider);

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