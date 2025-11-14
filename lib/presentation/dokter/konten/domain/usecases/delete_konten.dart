import 'package:aconsia_app/core/utils/usecase/usecase.dart';
import 'package:aconsia_app/presentation/dokter/konten/domain/repository/dokter_konten_repository.dart';
import 'package:dartz/dartz.dart';

class DeleteKonten implements UseCase<String, DeleteKontenParams> {
  final DokterKontenRepository repository;

  DeleteKonten({required this.repository});

  @override
  Future<Either<String, String>> call(DeleteKontenParams params) {
    return repository.deleteKonten(
      kontenId: params.kontenId,
    );
  }
}

class DeleteKontenParams {
  final String kontenId;

  DeleteKontenParams({
    required this.kontenId,
  });
}
