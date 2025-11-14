import 'package:aconsia_app/core/providers/firebase_provider.dart';
import 'package:aconsia_app/presentation/pasien/profile/data/datasources/pasien_profile_remote_data_source.dart';
import 'package:aconsia_app/presentation/pasien/profile/data/repositories/pasien_profile_repository_impl.dart';
import 'package:aconsia_app/presentation/pasien/profile/domain/repository/pasien_profile_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'pasien_profile_impl_provider.g.dart';

@riverpod
PasienProfileRepository pasienProfileRepository(
    PasienProfileRepositoryRef ref) {
  return PasienProfileRepositoryImpl(
    remoteDataSource: PasienProfileRemoteDataSourceImpl(
      firestore: ref.watch(firebaseFirestoreProvider),
    ),
  );
}