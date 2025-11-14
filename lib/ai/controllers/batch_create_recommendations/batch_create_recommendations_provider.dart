import 'package:aconsia_app/ai/controllers/ai_impl_provider.dart';
import 'package:aconsia_app/ai/domain/usecases/batch_create_recommendations.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'batch_create_recommendations_provider.g.dart';

@riverpod
BatchCreateRecommendations batchCreateRecommendations (BatchCreateRecommendationsRef ref) {
  return BatchCreateRecommendations(
    repository: ref.read(aiRepositoryProvider),
  );
}