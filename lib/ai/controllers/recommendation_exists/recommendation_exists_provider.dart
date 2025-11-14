import 'package:aconsia_app/ai/controllers/ai_impl_provider.dart';
import 'package:aconsia_app/ai/domain/usecases/recommendation_exists.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'recommendation_exists_provider.g.dart';

@riverpod
RecommendationExists recommendationExists (RecommendationExistsRef ref) {
  return RecommendationExists(repository: ref.read(aiRepositoryProvider));
}