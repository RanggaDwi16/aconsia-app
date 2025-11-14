import 'package:aconsia_app/core/utils/usecase/usecase.dart';
import 'package:aconsia_app/core/main/data/models/konten_model.dart';
import 'package:aconsia_app/core/main/data/models/konten_section_model.dart';
import 'package:aconsia_app/presentation/dokter/konten/domain/repository/dokter_konten_repository.dart';
import 'package:dartz/dartz.dart';

class UpdateKonten implements UseCase<String, UpdateKontenParams> {
  final DokterKontenRepository repository;

  UpdateKonten({required this.repository});

  @override
  Future<Either<String, String>> call(UpdateKontenParams params) {
    return repository.updateKonten(
      konten: params.konten,
      section: params.section,
    );
  }
}

class UpdateKontenParams {
  final KontenModel konten;
  final KontenSectionModel section;

  UpdateKontenParams({
    required this.konten,
    required this.section,
  });
}
