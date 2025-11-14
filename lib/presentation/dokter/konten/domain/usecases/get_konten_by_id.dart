import 'package:aconsia_app/core/utils/usecase/usecase.dart';
import 'package:aconsia_app/core/main/data/models/konten_model.dart';
import 'package:aconsia_app/presentation/dokter/konten/domain/repository/dokter_konten_repository.dart';
import 'package:dartz/dartz.dart';

class GetKontenById implements UseCase<KontenModel, GetKontenByIdParams> {
  final DokterKontenRepository repository;

  GetKontenById({required this.repository});

  @override
  Future<Either<String, KontenModel>> call(GetKontenByIdParams params) {
    return repository.getKontenById(
      kontenId: params.kontenId,
    );
  }
}

class GetKontenByIdParams {
  final String kontenId;

  GetKontenByIdParams({
    required this.kontenId,
  });
}
