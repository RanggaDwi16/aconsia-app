import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:aconsia_app/core/main/data/models/reading_session_model.dart';

/// Remote DataSource untuk Reading Session
/// Handles tracking pasien yang sedang membaca konten
abstract class ReadingSessionRemoteDataSource {
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

class ReadingSessionRemoteDataSourceImpl
    implements ReadingSessionRemoteDataSource {
  final FirebaseFirestore firestore;

  ReadingSessionRemoteDataSourceImpl({required this.firestore});

  @override
  Future<Either<String, ReadingSessionModel>> createOrUpdateSession({
    required String pasienId,
    required String kontenId,
    required String sectionId,
    required String dokterId,
  }) async {
    try {
      print(
          '[ReadingSession] 🔍 Creating/updating session for pasien: $pasienId, konten: $kontenId');

      // STEP 1: End ALL active sessions for this pasien (regardless of konten)
      // This ensures 1 pasien = max 1 active session
      final allActiveSessions = await firestore
          .collection('reading_sessions')
          .where('pasienId', isEqualTo: pasienId)
          .where('isActive', isEqualTo: true)
          .get();

      if (allActiveSessions.docs.isNotEmpty) {
        print(
            '[ReadingSession] 🧹 Found ${allActiveSessions.docs.length} active sessions for this pasien, ending them...');

        // End all old sessions
        final batch = firestore.batch();
        for (var doc in allActiveSessions.docs) {
          batch.update(doc.reference, {
            'isActive': false,
            'endedAt': FieldValue.serverTimestamp(),
          });
        }
        await batch.commit();
        print('[ReadingSession] ✅ All old sessions ended');
      }

      // STEP 2: Create new session
      final docRef = firestore.collection('reading_sessions').doc();
      final session = ReadingSessionModel(
        id: docRef.id,
        pasienId: pasienId,
        kontenId: kontenId,
        sectionId: sectionId,
        dokterId: dokterId,
        startedAt: DateTime.now(),
        isActive: true,
      );

      await docRef.set(ReadingSessionModel.toFirestore(session));
      print('[ReadingSession] ✅ New session created: ${docRef.id}');

      return Right(session);
    } catch (e) {
      print('[ReadingSession] ❌ Error: $e');
      return Left('Gagal membuat/update session: $e');
    }
  }

  @override
  Future<Either<String, Unit>> endSession({required String sessionId}) async {
    try {
      print('[ReadingSession] 📤 Ending session: $sessionId');

      await firestore.collection('reading_sessions').doc(sessionId).update({
        'isActive': false,
        'endedAt': FieldValue.serverTimestamp(),
      });

      print('[ReadingSession] ✅ Session $sessionId ended (isActive = false)');
      return const Right(unit);
    } catch (e) {
      print('[ReadingSession] ❌ Error ending session: $e');
      return Left('Gagal mengakhiri session: $e');
    }
  }

  @override
  Future<Either<String, int>> getActiveSessionsCount({
    required String dokterId,
  }) async {
    try {
      final snapshot = await firestore
          .collection('reading_sessions')
          .where('dokterId', isEqualTo: dokterId)
          .where('isActive', isEqualTo: true)
          .get();

      return Right(snapshot.docs.length);
    } catch (e) {
      return Left('Gagal menghitung session aktif: $e');
    }
  }

  @override
  Stream<List<ReadingSessionModel>> streamActiveSessions({
    required String dokterId,
  }) {
    print('[ReadingSession] 📡 Starting stream for dokterId: $dokterId');

    return firestore
        .collection('reading_sessions')
        .where('dokterId', isEqualTo: dokterId)
        .where('isActive', isEqualTo: true)
        .snapshots()
        .map((snapshot) {
      final sessions = snapshot.docs
          .map((doc) => ReadingSessionModel.fromFirestore(doc))
          .toList();

      print('[ReadingSession] 📊 Active sessions count: ${sessions.length}');
      for (var session in sessions) {
        print(
            '[ReadingSession]   - Session ${session.id}: pasien=${session.pasienId}, konten=${session.kontenId}, isActive=${session.isActive}');
      }

      return sessions;
    });
  }
}
