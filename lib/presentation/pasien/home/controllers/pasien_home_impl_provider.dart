import 'package:aconsia_app/core/providers/firebase_provider.dart';
import 'package:aconsia_app/presentation/pasien/home/data/datasources/pasien_home_remote_data_source.dart';
import 'package:aconsia_app/presentation/pasien/home/data/repositories/pasien_home_repository_impl.dart';
import 'package:aconsia_app/presentation/pasien/home/domain/repository/pasien_home_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'pasien_home_impl_provider.g.dart';

@riverpod
PasienHomeRepository pasienHomeRepository(PasienHomeRepositoryRef ref) {
  return PasienHomeRepositoryImpl(
      remoteDataSource: PasienHomeRemoteDataSourceImpl(
    firestore: ref.read(firebaseFirestoreProvider),
  ));
}