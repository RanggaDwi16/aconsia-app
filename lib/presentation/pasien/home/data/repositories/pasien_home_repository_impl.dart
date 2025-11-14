import 'package:aconsia_app/presentation/pasien/home/data/datasources/pasien_home_remote_data_source.dart';
import 'package:aconsia_app/presentation/pasien/home/domain/repository/pasien_home_repository.dart';

class PasienHomeRepositoryImpl implements PasienHomeRepository {
  final PasienHomeRemoteDataSource remoteDataSource;

  PasienHomeRepositoryImpl({required this.remoteDataSource});

  // Implement methods related to pasien home here
}