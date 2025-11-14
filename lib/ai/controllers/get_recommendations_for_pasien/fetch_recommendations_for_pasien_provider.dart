import 'package:aconsia_app/ai/controllers/get_recommendations_for_pasien/get_recommendations_for_pasien_provider.dart';
import 'package:aconsia_app/ai/domain/usecases/get_recommendations_for_pasien.dart';
import 'package:aconsia_app/core/main/data/models/ai_recommendation_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'fetch_recommendations_for_pasien_provider.g.dart';

@riverpod
class FetchRecommendationsForPasien extends _$FetchRecommendationsForPasien {
  @override
  FutureOr<List<AIRecommendationModel>?> build(
      {required String pasienId, int limit = 10}) async {
    state = const AsyncLoading();

    GetRecommendationsForPasien getRecommendationsForPasien =
        ref.read(getRecommendationsForPasienProvider);

    final result = await getRecommendationsForPasien(
      GetRecommendationsForPasienParams(
        pasienId: pasienId,
      ),
    );

    return result.fold(
      (failure) {
        state = AsyncError(failure, StackTrace.current);
        return null;
      },
      (recommendations) {
        state = AsyncData(recommendations);
        return recommendations;
      },
    );
  }
}
