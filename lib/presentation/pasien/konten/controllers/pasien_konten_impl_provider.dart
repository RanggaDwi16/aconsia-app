import 'package:aconsia_app/core/providers/firebase_provider.dart';
import 'package:aconsia_app/presentation/pasien/konten/data/datasources/pasien_konten_remote_datasource.dart';
import 'package:aconsia_app/presentation/pasien/konten/data/repositories/pasien_konten_repository_impl.dart';
import 'package:aconsia_app/presentation/pasien/konten/domain/repository/pasien_konten_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'pasien_konten_impl_provider.g.dart';

@riverpod
PasienKontenRepository pasienKontenRepository(PasienKontenRepositoryRef ref) {
  return PasienKontenRepositoryImpl(
    remoteDataSource: PasienKontenRemoteDataSourceImpl(
      firestore: ref.read(firebaseFirestoreProvider),
    ),
  );
}
