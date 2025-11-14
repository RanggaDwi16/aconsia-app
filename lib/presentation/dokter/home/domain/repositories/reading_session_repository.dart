import 'package:dartz/dartz.dart';
import 'package:aconsia_app/core/main/data/models/reading_session_model.dart';

/// Repository interface untuk Reading Session operations
abstract class ReadingSessionRepository {
  /// Create or update reading session
  Future<Either<String, ReadingSessionModel>> createOrUpdateSession({
    required String pasienId,
    required String kontenId,
    required String sectionId,
    required String dokterId,
  });

  /// End reading session
  Future<Either<String, Unit>> endSession({required String sessionId});

  /// Get active sessions count by dokter ID
  Future<Either<String, int>> getActiveSessionsCount({
    required String dokterId,
  });

  /// Stream active sessions by dokter ID (real-time)
  Stream<List<ReadingSessionModel>> streamActiveSessions({
    required String dokterId,
  });
}
