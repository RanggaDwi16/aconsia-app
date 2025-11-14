import 'package:aconsia_app/ai/controllers/ai_impl_provider.dart';
import 'package:aconsia_app/ai/domain/usecases/clear_old_recommendations.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'clear_old_recommendations_provider.g.dart';

@riverpod
ClearOldRecommendations clearOldRecommendations (ClearOldRecommendationsRef ref) {
  return ClearOldRecommendations(
    repository: ref.read(aiRepositoryProvider),
  );
}