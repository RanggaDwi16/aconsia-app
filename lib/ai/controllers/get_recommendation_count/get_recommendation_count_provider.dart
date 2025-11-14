import 'package:aconsia_app/ai/controllers/ai_impl_provider.dart';
import 'package:aconsia_app/ai/domain/usecases/get_recommendation_count.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'get_recommendation_count_provider.g.dart';

@riverpod
GetRecommendationCount getRecommendationCount (GetRecommendationCountRef ref) {
  return GetRecommendationCount(
    repository: ref.read(aiRepositoryProvider),
  );
}