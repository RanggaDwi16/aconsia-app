import 'package:aconsia_app/presentation/pasien/konten/data/datasources/pasien_konten_remote_datasource.dart';
import 'package:aconsia_app/presentation/pasien/konten/domain/repository/pasien_konten_repository.dart';

class PasienKontenRepositoryImpl implements PasienKontenRepository {
  final PasienKontenRemoteDataSource remoteDataSource;

  PasienKontenRepositoryImpl({required this.remoteDataSource});

  // Implement methods related to pasien konten here
}