import 'package:aconsia_app/chat/controllers/chat_impl_provider.dart';
import 'package:aconsia_app/chat/domain/usecases/get_messages.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'get_messages_provider.g.dart';

@riverpod
GetMessages getMessages(GetMessagesRef ref) {
  return GetMessages(repository: ref.read(chatRepositoryProvider));
}
