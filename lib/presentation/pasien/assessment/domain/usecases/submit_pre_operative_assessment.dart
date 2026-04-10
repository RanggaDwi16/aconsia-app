import 'package:aconsia_app/core/utils/usecase/usecase.dart';
import 'package:aconsia_app/presentation/pasien/profile/domain/repository/pasien_profile_repository.dart';
import 'package:dartz/dartz.dart';

class SubmitPreOperativeAssessment
    implements UseCase<String, SubmitPreOperativeAssessmentParams> {
  final PasienProfileRepository repository;

  SubmitPreOperativeAssessment({required this.repository});

  @override
  Future<Either<String, String>> call(
      SubmitPreOperativeAssessmentParams params) {
    return repository.submitPreOperativeAssessment(
      uid: params.uid,
      asaStatusSnapshot: params.asaStatusSnapshot,
      assessmentData: params.assessmentData,
    );
  }
}

class SubmitPreOperativeAssessmentParams {
  final String uid;
  final String asaStatusSnapshot;
  final Map<String, dynamic> assessmentData;

  SubmitPreOperativeAssessmentParams({
    required this.uid,
    required this.asaStatusSnapshot,
    required this.assessmentData,
  });
}
