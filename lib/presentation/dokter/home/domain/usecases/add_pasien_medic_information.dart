import 'package:aconsia_app/core/main/data/models/pasien_profile_model.dart';
import 'package:aconsia_app/core/utils/usecase/usecase.dart';
import 'package:aconsia_app/presentation/dokter/home/domain/repository/home_repository.dart';
import 'package:dartz/dartz.dart';

enum DokterApprovalDecision { approve, reject }

class AddPasienMedicInformation
    implements UseCase<String, AddPasienMedicInformationParams> {
  final HomeRepository repository;

  AddPasienMedicInformation({required this.repository});

  @override
  Future<Either<String, String>> call(
      AddPasienMedicInformationParams params) async {
    return await repository.addPasienMedicInformation(
      pasienId: params.pasienId,
      profile: params.profile,
      diagnosis: params.diagnosis,
      decision: params.decision,
      rejectionReason: params.rejectionReason,
    );
  }
}

class AddPasienMedicInformationParams {
  final String pasienId;
  final PasienProfileModel profile;
  final String diagnosis;
  final DokterApprovalDecision decision;
  final String? rejectionReason;

  AddPasienMedicInformationParams({
    required this.pasienId,
    required this.profile,
    required this.diagnosis,
    required this.decision,
    this.rejectionReason,
  });
}
