import 'package:aconsia_app/core/providers/firebase_provider.dart';
import 'package:aconsia_app/presentation/dokter/profile/data/datasources/dokter_profile_remote_data_source.dart';
import 'package:aconsia_app/presentation/dokter/profile/data/repositories/dokter_profile_repository_impl.dart';
import 'package:aconsia_app/presentation/dokter/profile/domain/repository/dokter_profile_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dokter_profile_impl_provider.g.dart';

@riverpod
DokterProfileRepository dokterProfileRepository(
    DokterProfileRepositoryRef ref) {
  return DokterProfileRepositoryImpl(
    remoteDataSource: DokterProfileRemoteDataSourceImpl(
      firestore: ref.watch(firebaseFirestoreProvider),
    ),
  );
}
