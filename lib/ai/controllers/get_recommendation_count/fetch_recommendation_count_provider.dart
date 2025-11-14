import 'package:aconsia_app/ai/controllers/get_recommendation_count/get_recommendation_count_provider.dart';
import 'package:aconsia_app/ai/domain/usecases/get_recommendation_count.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'fetch_recommendation_count_provider.g.dart';

@riverpod
class FetchRecommendationCount extends _$FetchRecommendationCount {
  @override
  FutureOr<int?> build({required String pasienId}) async {
    state = const AsyncLoading();
    GetRecommendationCount getRecommendationCount =
        ref.read(getRecommendationCountProvider);

    final result = await getRecommendationCount(
      GetRecommendationCountParams(pasienId: pasienId),
    );

    return result.fold(
      (failure) {
        state = AsyncError(failure, StackTrace.current);
        return null;
      },
      (count) {
        state = AsyncData(count);
        return count;
      },
    );
  }
}
