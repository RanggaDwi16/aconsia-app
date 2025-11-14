import 'package:aconsia_app/core/main/data/datasources/authentication_remote_data_source.dart';
import 'package:aconsia_app/core/main/data/repositories/authentication_repository_impl.dart';
import 'package:aconsia_app/core/main/domain/repository/authentication_repository.dart';
import 'package:aconsia_app/core/providers/firebase_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'authentciation_impl_provider.g.dart';

@riverpod
AuthenticationRepository authenticationRepository(
    AuthenticationRepositoryRef ref) {
  return AuthenticationRepositoryImpl(
    remoteDataSource: AuthenticationRemoteDataSourceImpl(
      firebaseAuth: ref.watch(firebaseAuthProvider),
      firestore: ref.watch(firebaseFirestoreProvider),
    ),
  );
}
