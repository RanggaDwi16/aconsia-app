import 'package:aconsia_app/core/providers/firebase_provider.dart';
import 'package:aconsia_app/presentation/dokter/konten/data/datasources/dokter_konten_remote_datasource.dart';
import 'package:aconsia_app/presentation/dokter/konten/data/repositories/dokter_konten_repository_impl.dart';
import 'package:aconsia_app/presentation/dokter/konten/domain/repository/dokter_konten_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dokter_konten_impl_provider.g.dart';

@riverpod
DokterKontenRepository dokterKontenRepository(DokterKontenRepositoryRef ref) {
  return DokterKontenRepositoryImpl(
    remoteDataSource: DokterKontenRemoteDataSourceImpl(
      firestore: ref.read(firebaseFirestoreProvider),
    ),
  );
}
