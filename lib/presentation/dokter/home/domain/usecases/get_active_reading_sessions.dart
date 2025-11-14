import 'package:dartz/dartz.dart';
import 'package:aconsia_app/presentation/dokter/home/domain/repositories/reading_session_repository.dart';

/// UseCase: Get Active Reading Sessions Count
class GetActiveReadingSessions {
  final ReadingSessionRepository repository;

  GetActiveReadingSessions(this.repository);

  Future<Either<String, int>> call({required String dokterId}) async {
    return await repository.getActiveSessionsCount(dokterId: dokterId);
  }
}
