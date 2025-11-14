import 'package:aconsia_app/core/utils/usecase/usecase.dart';
import 'package:aconsia_app/presentation/dokter/home/domain/repository/home_repository.dart';
import 'package:dartz/dartz.dart';

class GetPasienCountByDokterId implements UseCase<int, GetPasienCountByDokterIdParams> {
  final HomeRepository repository;

  GetPasienCountByDokterId({required this.repository});

  @override
  Future<Either<String, int>> call(GetPasienCountByDokterIdParams params) async {
    return await repository.getPasienCountByDokterId(dokterId: params.dokterId);
  }
}

class GetPasienCountByDokterIdParams {
  final String dokterId;

  GetPasienCountByDokterIdParams({required this.dokterId});
}