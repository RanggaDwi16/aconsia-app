import 'package:aconsia_app/chat/controllers/get_messages/get_messages_provider.dart';
import 'package:aconsia_app/chat/domain/usecases/get_messages.dart';
import 'package:aconsia_app/core/main/data/models/chat_message_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'fetch_messages_provider.g.dart';

@riverpod
class FetchMessages extends _$FetchMessages {
  @override
  FutureOr<List<ChatMessageModel>?> build({required GetMessagesParams params}) async {
    state = const AsyncLoading();

    GetMessages getMessagesUseCase = ref.read(getMessagesProvider);

    final result = await getMessagesUseCase.call(params);

    return result.fold(
      (error) {
        state = AsyncError(error, StackTrace.current);
        return null;
      },
      (messages) {
        state = AsyncData(messages);
        return messages;
      },
    );
  }
}