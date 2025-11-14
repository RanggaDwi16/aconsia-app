import 'package:aconsia_app/chat/data/datasources/chat_remote_data_source.dart';
import 'package:aconsia_app/chat/data/repositories/chat_repository_impl.dart';
import 'package:aconsia_app/chat/domain/repository/chat_repository.dart';
import 'package:aconsia_app/core/providers/firebase_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chat_impl_provider.g.dart';

@riverpod
ChatRepository chatRepository(ChatRepositoryRef ref) {
  return ChatRepositoryImpl(
    remoteDataSource: ChatRemoteDataSourceImpl(
      firestore: ref.read(firebaseFirestoreProvider),
    ),
  );
}
