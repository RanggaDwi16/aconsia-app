import 'package:aconsia_app/core/main/data/models/pasien_profile_model.dart';
import 'package:aconsia_app/presentation/dokter/home/domain/usecases/add_pasien_medic_information.dart';
import 'package:dartz/dartz.dart';

abstract class HomeRepository {
  Future<Either<String, int>> getPasienCountByDokterId({
    required String dokterId,
  });

  Future<Either<String, String>> addPasienMedicInformation({
    required String pasienId,
    required PasienProfileModel profile,
    required String diagnosis,
    required DokterApprovalDecision decision,
    String? rejectionReason,
  });

  Future<Either<String, List<PasienProfileModel>>> getPasienListByDokterId({
    required String dokterId,
  });
  
  Future<Either<String, PasienProfileModel>> getPasienProfileById({
    required String pasienId,
  });
}
