import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:aconsia_app/core/main/data/models/reading_session_model.dart';
import 'package:aconsia_app/presentation/dokter/home/data/datasources/reading_session_remote_data_source.dart';
import 'package:aconsia_app/presentation/dokter/home/data/repositories/reading_session_repository_impl.dart';
import 'package:aconsia_app/presentation/dokter/home/domain/repositories/reading_session_repository.dart';
import 'package:aconsia_app/presentation/dokter/home/domain/usecases/get_active_reading_sessions.dart';
import 'package:aconsia_app/presentation/dokter/home/domain/usecases/stream_active_reading_sessions.dart';
import 'package:dartz/dartz.dart';

part 'reading_session_provider.g.dart';

// ==================== DATA SOURCE ====================

@riverpod
ReadingSessionRemoteDataSource readingSessionRemoteDataSource(
  ReadingSessionRemoteDataSourceRef ref,
) {
  return ReadingSessionRemoteDataSourceImpl(
    firestore: FirebaseFirestore.instance,
  );
}

// ==================== REPOSITORY ====================

@riverpod
ReadingSessionRepository readingSessionRepository(
  ReadingSessionRepositoryRef ref,
) {
  return ReadingSessionRepositoryImpl(
    remoteDataSource: ref.watch(readingSessionRemoteDataSourceProvider),
  );
}

// ==================== USE CASES ====================

@riverpod
GetActiveReadingSessions getActiveReadingSessions(
  GetActiveReadingSessionsRef ref,
) {
  return GetActiveReadingSessions(
    ref.watch(readingSessionRepositoryProvider),
  );
}

@riverpod
StreamActiveReadingSessions streamActiveReadingSessions(
  StreamActiveReadingSessionsRef ref,
) {
  return StreamActiveReadingSessions(
    ref.watch(readingSessionRepositoryProvider),
  );
}

// ==================== STREAM PROVIDER ====================

/// Real-time stream provider untuk active reading sessions
@riverpod
Stream<List<ReadingSessionModel>> activeReadingSessionsStream(
  ActiveReadingSessionsStreamRef ref,
  String dokterId,
) {
  final streamUseCase = ref.watch(streamActiveReadingSessionsProvider);
  return streamUseCase(dokterId: dokterId);
}

/// Provider untuk count active readers (simplified)
/// Counts UNIQUE pasien (not total documents)
@riverpod
int activeReadersCount(
  ActiveReadersCountRef ref,
  String dokterId,
) {
  final sessionsAsync =
      ref.watch(activeReadingSessionsStreamProvider(dokterId));
  return sessionsAsync.when(
    data: (sessions) {
      // Count unique pasien IDshj
      final uniquePasienIds = sessions.map((s) => s.pasienId).toSet();
      return uniquePasienIds.length;
    },
    loading: () => 0,
    error: (_, __) => 0,
  );
}

// ==================== ACTION PROVIDERS ====================

/// Provider untuk create or update reading session
@riverpod
class CreateOrUpdateReadingSession extends _$CreateOrUpdateReadingSession {
  @override
  FutureOr<ReadingSessionModel?> build() async {
    return null;
  }

  Future<void> createOrUpdate({
    required String pasienId,
    required String kontenId,
    required String sectionId,
    required String dokterId,
  }) async {
    state = const AsyncLoading();

    final dataSource = ref.read(readingSessionRemoteDataSourceProvider);
    final result = await dataSource.createOrUpdateSession(
      pasienId: pasienId,
      kontenId: kontenId,
      sectionId: sectionId,
      dokterId: dokterId,
    );

    result.fold(
      (error) {
        state = AsyncError(error, StackTrace.current);
      },
      (session) {
        state = AsyncData(session);
      },
    );
  }
}

/// Provider untuk end reading session
@riverpod
class EndReadingSession extends _$EndReadingSession {
  @override
  FutureOr<bool> build() async {
    return false;
  }

  Future<void> endSession({required String sessionId}) async {
    state = const AsyncLoading();

    final dataSource = ref.read(readingSessionRemoteDataSourceProvider);
    final result = await dataSource.endSession(sessionId: sessionId);

    result.fold(
      (error) {
        state = AsyncError(error, StackTrace.current);
      },
      (_) {
        state = const AsyncData(true);
      },
    );
  }
}
