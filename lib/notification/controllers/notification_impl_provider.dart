import 'package:aconsia_app/core/providers/firebase_provider.dart';
import 'package:aconsia_app/notification/data/datasources/notification_remote_data_source.dart';
import 'package:aconsia_app/notification/data/repositories/notification_repository_impl.dart';
import 'package:aconsia_app/notification/domain/repository/notification_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notification_impl_provider.g.dart';

@riverpod
NotificationRepository notificationRepository(NotificationRepositoryRef ref) {
  return NotificationRepositoryImpl(
      remoteDataSource: NotificationRemoteDataSourceImpl(
          firestore: ref.read(firebaseFirestoreProvider)));
}
