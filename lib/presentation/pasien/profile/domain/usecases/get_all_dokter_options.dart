import 'package:aconsia_app/core/utils/usecase/usecase.dart';
import 'package:aconsia_app/core/main/data/models/dokter_profile_model.dart';
import 'package:aconsia_app/presentation/pasien/profile/domain/repository/pasien_profile_repository.dart';
import 'package:dartz/dartz.dart';

class GetAllDokterOptions implements UseCase<List<DokterProfileModel>, void> {
  final PasienProfileRepository repository;

  GetAllDokterOptions({required this.repository});
  
  @override
  Future<Either<String, List<DokterProfileModel>>> call(void params) {
    return repository.getAllDokterOptions();
  }

}
