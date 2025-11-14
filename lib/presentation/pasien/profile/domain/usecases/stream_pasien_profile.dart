import 'package:aconsia_app/core/utils/usecase/usecase.dart';
import 'package:aconsia_app/core/main/data/models/pasien_profile_model.dart';
import 'package:aconsia_app/presentation/pasien/profile/domain/repository/pasien_profile_repository.dart';
import 'package:dartz/dartz.dart';

/// UseCase: Stream Pasien Profile (Real-time)
class StreamPasienProfile
    implements UseCase<PasienProfileModel, StreamPasienProfileParams> {
  final PasienProfileRepository repository;

  StreamPasienProfile({required this.repository});

  @override
  Future<Either<String, PasienProfileModel>> call(
      StreamPasienProfileParams params) {
    try {
      final stream = repository.streamPasienProfile(uid: params.uid);
      // Assuming we want to get the first value from the stream for this use case
      return stream.first.then((profile) => Right(profile!));
    } catch (e) {
      return Future.value(Left(e.toString()));
    }
  }
}

class StreamPasienProfileParams {
  final String uid;

  StreamPasienProfileParams({required this.uid});
}
