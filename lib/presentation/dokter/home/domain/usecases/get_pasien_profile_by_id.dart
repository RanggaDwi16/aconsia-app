import 'package:aconsia_app/core/main/data/models/pasien_profile_model.dart';
import 'package:aconsia_app/core/utils/usecase/usecase.dart';
import 'package:aconsia_app/presentation/dokter/home/domain/repository/home_repository.dart';
import 'package:dartz/dartz.dart';

class GetPasienProfileById implements UseCase<PasienProfileModel, GetPasienProfileByIdParams> {
  final HomeRepository repository;

  GetPasienProfileById({required this.repository});

  @override
  Future<Either<String, PasienProfileModel>> call(GetPasienProfileByIdParams params) async {
    return await repository.getPasienProfileById(pasienId: params.pasienId);
  }
}

class GetPasienProfileByIdParams {
  final String pasienId;

  GetPasienProfileByIdParams({required this.pasienId});
}