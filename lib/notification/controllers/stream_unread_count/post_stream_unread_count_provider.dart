import 'package:aconsia_app/notification/controllers/notification_impl_provider.dart';
import 'package:aconsia_app/notification/domain/usecases/stream_unread_count.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'post_stream_unread_count_provider.g.dart';

@riverpod
Stream<int> postStreamUnreadCount(PostStreamUnreadCountRef ref,
    {required String userId}) {
  final repository = ref.read(notificationRepositoryProvider);
  final streamUnreadCount = StreamUnreadCount(repository: repository);

  return streamUnreadCount(userId: userId);
}

// @Riverpod(keepAlive: true)
// Stream<List<ChatMessageModel>> postStreamMessages(
//   PostStreamMessagesRef ref, {
//   required String sessionId,
// }) {
//   final repository = ref.read(chatRepositoryProvider);
//   final streamMessages = StreamMessages(repository: repository);
//   return streamMessages(sessionId: sessionId);
// }
