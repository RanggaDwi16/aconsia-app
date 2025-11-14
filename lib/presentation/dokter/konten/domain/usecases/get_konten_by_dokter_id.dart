import 'package:aconsia_app/core/utils/usecase/usecase.dart';
import 'package:aconsia_app/core/main/data/models/konten_model.dart';
import 'package:aconsia_app/presentation/dokter/konten/domain/repository/dokter_konten_repository.dart';
import 'package:dartz/dartz.dart';

class GetKontenByDokterId
    implements UseCase<List<KontenModel>, GetKontenByDokterIdParams> {
  final DokterKontenRepository repository;

  GetKontenByDokterId({required this.repository});

  @override
  Future<Either<String, List<KontenModel>>> call(
      GetKontenByDokterIdParams params) {
    return repository.getKontenByDokterId(
      dokterId: params.dokterId,
    );
  }
}

class GetKontenByDokterIdParams {
  final String dokterId;

  GetKontenByDokterIdParams({
    required this.dokterId,
  });
}
