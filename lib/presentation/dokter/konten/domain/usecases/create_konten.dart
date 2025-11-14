import 'package:aconsia_app/core/utils/usecase/usecase.dart';
import 'package:aconsia_app/core/main/data/models/konten_model.dart';
import 'package:aconsia_app/core/main/data/models/konten_section_model.dart';
import 'package:aconsia_app/presentation/dokter/konten/domain/repository/dokter_konten_repository.dart';
import 'package:dartz/dartz.dart';

class CreateKonten implements UseCase<String, CreateKontenParams> {
  final DokterKontenRepository repository;

  CreateKonten({required this.repository});

  @override
  Future<Either<String, String>> call(CreateKontenParams params) {
    return repository.createKonten(
      konten: params.konten,
      sections: params.sections,
    );
  }
}

class CreateKontenParams {
  final KontenModel konten;
  final List<KontenSectionModel> sections;

  CreateKontenParams({
    required this.konten,
    required this.sections,
  });
}
