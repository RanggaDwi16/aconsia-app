import 'package:aconsia_app/chat/controllers/chat_impl_provider.dart';
import 'package:aconsia_app/chat/domain/usecases/stream_messages.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'stream_messages_provider.g.dart';

@riverpod
StreamMessages streamMessages (StreamMessagesRef ref) {
  return StreamMessages(repository: ref.read(chatRepositoryProvider));
}