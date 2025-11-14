import 'package:aconsia_app/chat/controllers/chat_impl_provider.dart';
import 'package:aconsia_app/chat/domain/usecases/update_session.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'update_session_provider.g.dart';

@riverpod
UpdateSession updateSession (UpdateSessionRef ref) {
  return UpdateSession(repository: ref.read(chatRepositoryProvider));
}