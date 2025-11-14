import 'package:aconsia_app/ai/controllers/ai_impl_provider.dart';
import 'package:aconsia_app/ai/domain/usecases/create_recommendation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'create_recommendation_provider.g.dart';

@riverpod
CreateRecommendation createRecommendation (CreateRecommendationRef ref) {
  return CreateRecommendation(
    repository: ref.read(aiRepositoryProvider),
  );
}