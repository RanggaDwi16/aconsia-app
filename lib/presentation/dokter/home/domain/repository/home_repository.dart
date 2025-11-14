import 'package:aconsia_app/core/main/data/models/pasien_profile_model.dart';
import 'package:dartz/dartz.dart';

abstract class HomeRepository {
  Future<Either<String, int>> getPasienCountByDokterId({
    required String dokterId,
  });

  Future<Either<String, String>> addPasienMedicInformation({
    required String pasienId,
    required PasienProfileModel profile,
  });

  Future<Either<String, List<PasienProfileModel>>> getPasienListByDokterId({
    required String dokterId,
  });
  
  Future<Either<String, PasienProfileModel>> getPasienProfileById({
    required String pasienId,
  });
}