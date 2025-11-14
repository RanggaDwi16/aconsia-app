import 'package:aconsia_app/core/utils/usecase/usecase.dart';
import 'package:aconsia_app/core/main/data/models/dokter_profile_model.dart';
import 'package:aconsia_app/presentation/dokter/profile/domain/repository/dokter_profile_repository.dart';
import 'package:dartz/dartz.dart';

/// UseCase: Stream Dokter Profile (Real-time)
class StreamDokterProfile
    implements UseCase<Stream<DokterProfileModel?>, StreamDokterProfileParams> {
  final DokterProfileRepository repository;

  StreamDokterProfile({required this.repository});

  @override
  Future<Either<String, Stream<DokterProfileModel?>>> call(
      StreamDokterProfileParams params) {
    try {
      final result = repository.streamDokterProfile(uid: params.uid);
      return Future.value(Right(result));
    } catch (e) {
      return Future.value(Left(e.toString()));
    }
  }
}

class StreamDokterProfileParams {
  final String uid;

  StreamDokterProfileParams({required this.uid});
}
