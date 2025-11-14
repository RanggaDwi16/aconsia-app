import 'package:aconsia_app/chat/controllers/chat_impl_provider.dart';
import 'package:aconsia_app/chat/domain/usecases/delete_message.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'delete_mesage_provider.g.dart';

@riverpod
DeleteMessage deleteMessage (DeleteMessageRef ref) {
  return DeleteMessage(
    repository: ref.read(chatRepositoryProvider),
  );
}