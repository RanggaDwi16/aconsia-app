import 'package:aconsia_app/core/utils/usecase/usecase.dart';
import 'package:aconsia_app/core/main/data/models/konten_section_model.dart';
import 'package:aconsia_app/presentation/dokter/konten/domain/repository/dokter_konten_repository.dart';
import 'package:dartz/dartz.dart';

class GetSectionsByKontenId
    implements UseCase<List<KontenSectionModel>, GetSectionsByKontenIdParams> {
  final DokterKontenRepository repository;

  GetSectionsByKontenId({required this.repository});

  @override
  Future<Either<String, List<KontenSectionModel>>> call(
      GetSectionsByKontenIdParams params) {
    return repository.getSectionsByKontenId(
      kontenId: params.kontenId,
    );
  }
}

class GetSectionsByKontenIdParams {
  final String kontenId;

  GetSectionsByKontenIdParams({
    required this.kontenId,
  });
}
