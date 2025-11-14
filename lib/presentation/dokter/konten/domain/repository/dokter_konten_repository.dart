import 'package:aconsia_app/core/main/data/models/konten_model.dart';
import 'package:aconsia_app/core/main/data/models/konten_section_model.dart';
import 'package:dartz/dartz.dart';

abstract class DokterKontenRepository {
  Future<Either<String, String>> createKonten({
    required KontenModel konten,
    required List<KontenSectionModel> sections,
  });

  Future<Either<String, KontenModel>> getKontenById({
    required String kontenId,
  });

  Future<Either<String, List<KontenSectionModel>>> getSectionsByKontenId({
    required String kontenId,
  });

  Future<Either<String, List<KontenModel>>> getKontenByDokterId({
    required String dokterId,
  });

  Future<Either<String, String>> updateKonten({
    required KontenModel konten,
    required KontenSectionModel section,
  });

  Future<Either<String, String>> updateSection({
    required KontenSectionModel section,
  });

  Future<Either<String, String>> deleteKonten({
    required String kontenId,
  });

  Future<Either<String, int>> getKontenCountByDokterId({
    required String dokterId,
  });

}
