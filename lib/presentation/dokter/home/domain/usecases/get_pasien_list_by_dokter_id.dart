import 'package:aconsia_app/core/main/data/models/pasien_profile_model.dart';
import 'package:aconsia_app/core/utils/usecase/usecase.dart';
import 'package:aconsia_app/presentation/dokter/home/domain/repository/home_repository.dart';
import 'package:dartz/dartz.dart';

class GetPasienListByDokterId implements UseCase<List<PasienProfileModel>, GetPasienListByDokterIdParams> {
  final HomeRepository repository;

  GetPasienListByDokterId({required this.repository});

  @override
  Future<Either<String, List<PasienProfileModel>>> call(GetPasienListByDokterIdParams params) async {
    return await repository.getPasienListByDokterId(dokterId: params.dokterId);
  }
}

class GetPasienListByDokterIdParams {
  final String dokterId;

  GetPasienListByDokterIdParams({required this.dokterId});
}