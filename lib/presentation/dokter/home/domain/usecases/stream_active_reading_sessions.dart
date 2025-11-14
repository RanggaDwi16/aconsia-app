import 'package:aconsia_app/core/main/data/models/reading_session_model.dart';
import 'package:aconsia_app/presentation/dokter/home/domain/repositories/reading_session_repository.dart';

/// UseCase: Stream Active Reading Sessions (Real-time)
class StreamActiveReadingSessions {
  final ReadingSessionRepository repository;

  StreamActiveReadingSessions(this.repository);

  Stream<List<ReadingSessionModel>> call({required String dokterId}) {
    return repository.streamActiveSessions(dokterId: dokterId);
  }
}
