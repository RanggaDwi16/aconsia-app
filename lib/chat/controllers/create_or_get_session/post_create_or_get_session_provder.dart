import 'package:aconsia_app/chat/controllers/create_or_get_session/create_or_get_session_provider.dart';
import 'package:aconsia_app/chat/domain/usecases/create_or_get_session.dart';
import 'package:aconsia_app/core/main/data/models/chat_session_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'post_create_or_get_session_provder.g.dart';

@Riverpod(keepAlive: true)
class PostCreateOrGetSession extends _$PostCreateOrGetSession {
  @override
  FutureOr<ChatSessionModel?> build() {
    return null;
  }

  Future<void> postCreateOrGetSession({
    required CreateOrGetSessionParams params,
    required Function(ChatSessionModel data) onSuccess,
    required Function(String error) onError,
  }) async {
    state = const AsyncLoading();

    CreateOrGetSession usecase = ref.read(createOrGetSessionProvider);

    final result = await usecase.call(params);

    result.fold(
      (error) {
        state = AsyncError(error, StackTrace.current);
        onError(error);
      },
      (data) {
        state = AsyncData(data);
        onSuccess(data);
      },
    );
  }
}
