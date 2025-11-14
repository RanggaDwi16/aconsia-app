import 'package:aconsia_app/ai/controllers/ai_impl_provider.dart';
import 'package:aconsia_app/ai/domain/usecases/delete_recommendation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'delete_recommendation_provider.g.dart';

@riverpod
DeleteRecommendation deleteRecommendation (DeleteRecommendationRef ref) {
  return DeleteRecommendation(
    repository: ref.read(aiRepositoryProvider),
  );
}