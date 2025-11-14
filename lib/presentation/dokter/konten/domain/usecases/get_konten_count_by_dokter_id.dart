import 'package:aconsia_app/core/utils/usecase/usecase.dart';
import 'package:aconsia_app/presentation/dokter/konten/domain/repository/dokter_konten_repository.dart';
import 'package:dartz/dartz.dart';

class GetKontenCountByDokterId
    implements UseCase<int, GetKontenCountByDokterIdParams> {
  final DokterKontenRepository repository;

  GetKontenCountByDokterId({required this.repository});

  @override
  Future<Either<String, int>> call(GetKontenCountByDokterIdParams params) {
    return repository.getKontenCountByDokterId(
      dokterId: params.dokterId,
    );
  }
}

class GetKontenCountByDokterIdParams {
  final String dokterId;

  GetKontenCountByDokterIdParams({
    required this.dokterId,
  });
}
