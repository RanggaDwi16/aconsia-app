import 'package:aconsia_app/core/main/data/models/konten_model.dart';
import 'package:aconsia_app/core/main/data/models/konten_section_model.dart';
import 'package:aconsia_app/core/utils/usecase/usecase.dart';
import 'package:aconsia_app/presentation/dokter/konten/domain/repository/dokter_konten_repository.dart';
import 'package:dartz/dartz.dart';

class EnsureSectionExistsForKonten
    implements UseCase<KontenSectionModel, EnsureSectionExistsForKontenParams> {
  final DokterKontenRepository repository;

  EnsureSectionExistsForKonten({required this.repository});

  @override
  Future<Either<String, KontenSectionModel>> call(
    EnsureSectionExistsForKontenParams params,
  ) {
    return repository.ensureSectionExistsForKonten(konten: params.konten);
  }
}

class EnsureSectionExistsForKontenParams {
  final KontenModel konten;

  EnsureSectionExistsForKontenParams({required this.konten});
}

