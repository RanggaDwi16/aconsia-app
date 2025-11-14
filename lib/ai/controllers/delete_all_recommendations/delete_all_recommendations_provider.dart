import 'package:aconsia_app/ai/controllers/ai_impl_provider.dart';
import 'package:aconsia_app/ai/domain/usecases/delete_all_recommendations.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'delete_all_recommendations_provider.g.dart';

@riverpod
DeleteAllRecommendations deleteAllRecommendations (DeleteAllRecommendationsRef ref) {
  return DeleteAllRecommendations(
    repository: ref.read(aiRepositoryProvider),
  );
}