import 'package:aconsia_app/chat/controllers/chat_impl_provider.dart';
import 'package:aconsia_app/chat/domain/usecases/stream_messages.dart';
import 'package:aconsia_app/core/main/data/models/chat_message_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'post_stream_messages_provider.g.dart';

@Riverpod(keepAlive: true)
Stream<List<ChatMessageModel>> postStreamMessages(
  PostStreamMessagesRef ref, {
  required String sessionId,
}) {
  final repository = ref.read(chatRepositoryProvider);
  final streamMessages = StreamMessages(repository: repository);
  return streamMessages(sessionId: sessionId);
}
