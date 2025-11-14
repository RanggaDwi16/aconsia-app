import 'package:aconsia_app/core/utils/usecase/usecase.dart';
import 'package:aconsia_app/core/main/data/models/konten_section_model.dart';
import 'package:aconsia_app/presentation/dokter/konten/domain/repository/dokter_konten_repository.dart';
import 'package:dartz/dartz.dart';

class UpdateSection implements UseCase<String, UpdateSectionParams> {
  final DokterKontenRepository repository;

  UpdateSection({required this.repository});

  @override
  Future<Either<String, String>> call(UpdateSectionParams params) {
    return repository.updateSection(
      section: params.section,
    );
  }
}

class UpdateSectionParams {
  final KontenSectionModel section;

  UpdateSectionParams({
    required this.section,
  });
}
