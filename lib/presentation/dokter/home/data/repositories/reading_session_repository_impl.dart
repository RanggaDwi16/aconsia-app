import 'package:dartz/dartz.dart';
import 'package:aconsia_app/core/main/data/models/reading_session_model.dart';
import 'package:aconsia_app/presentation/dokter/home/domain/repositories/reading_session_repository.dart';
import 'package:aconsia_app/presentation/dokter/home/data/datasources/reading_session_remote_data_source.dart';

/// Implementation of ReadingSessionRepository
class ReadingSessionRepositoryImpl implements ReadingSessionRepository {
  final ReadingSessionRemoteDataSource remoteDataSource;

  ReadingSessionRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<String, ReadingSessionModel>> createOrUpdateSession({
    required String pasienId,
    required String kontenId,
    required String sectionId,
    required String dokterId,
  }) async {
    return await remoteDataSource.createOrUpdateSession(
      pasienId: pasienId,
      kontenId: kontenId,
      sectionId: sectionId,
      dokterId: dokterId,
    );
  }

  @override
  Future<Either<String, Unit>> endSession({required String sessionId}) async {
    return await remoteDataSource.endSession(sessionId: sessionId);
  }

  @override
  Future<Either<String, int>> getActiveSessionsCount({
    required String dokterId,
  }) async {
    return await remoteDataSource.getActiveSessionsCount(dokterId: dokterId);
  }

  @override
  Stream<List<ReadingSessionModel>> streamActiveSessions({
    required String dokterId,
  }) {
    return remoteDataSource.streamActiveSessions(dokterId: dokterId);
  }
}
