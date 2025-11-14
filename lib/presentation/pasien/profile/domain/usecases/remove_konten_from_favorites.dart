import 'package:aconsia_app/core/utils/usecase/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:aconsia_app/presentation/pasien/profile/domain/repository/pasien_profile_repository.dart';

/// UseCase: Remove Konten from Favorites
class RemoveKontenFromFavorites
    implements UseCase<String, RemoveKontenFromFavoritesParams> {
  final PasienProfileRepository repository;

  RemoveKontenFromFavorites({required this.repository});

  @override
  Future<Either<String, String>> call(RemoveKontenFromFavoritesParams params) {
    return repository.removeKontenFromFavorites(
      pasienId: params.pasienId,
      kontenId: params.kontenId,
    );
  }
}

class RemoveKontenFromFavoritesParams {
  final String pasienId;

  final String kontenId;

  RemoveKontenFromFavoritesParams({
    required this.pasienId,
    required this.kontenId,
  });
}
