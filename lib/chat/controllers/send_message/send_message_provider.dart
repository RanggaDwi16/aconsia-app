import 'package:aconsia_app/chat/controllers/chat_impl_provider.dart';
import 'package:aconsia_app/chat/domain/usecases/send_message.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'send_message_provider.g.dart';

@riverpod
SendMessage sendMessage (SendMessageRef ref) {
  return SendMessage(repository: ref.read(chatRepositoryProvider));
}