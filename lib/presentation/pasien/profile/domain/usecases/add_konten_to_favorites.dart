import 'package:aconsia_app/core/utils/usecase/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:aconsia_app/presentation/pasien/profile/domain/repository/pasien_profile_repository.dart';

/// UseCase: Add Konten to Favorites
class AddKontenToFavorites
    implements UseCase<String, AddKontenToFavoritesParams> {
  final PasienProfileRepository repository;

  AddKontenToFavorites({required this.repository});

  @override
  Future<Either<String, String>> call(AddKontenToFavoritesParams params) {
    return repository.addKontenToFavorites(
      pasienId: params.pasienId,
      kontenId: params.kontenId,
    );
  }
}

class AddKontenToFavoritesParams {
  final String pasienId;

  final String kontenId;

  AddKontenToFavoritesParams({
    required this.pasienId,
    required this.kontenId,
  });
}
