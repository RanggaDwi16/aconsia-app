import 'package:aconsia_app/chat/controllers/chat_impl_provider.dart';
import 'package:aconsia_app/chat/domain/usecases/create_or_get_session.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'create_or_get_session_provider.g.dart';

@riverpod
CreateOrGetSession createOrGetSession (CreateOrGetSessionRef ref) {
  return CreateOrGetSession(
    repository: ref.read(chatRepositoryProvider),
  );
}