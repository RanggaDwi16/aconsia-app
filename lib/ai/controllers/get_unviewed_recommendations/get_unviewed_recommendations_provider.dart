import 'package:aconsia_app/ai/controllers/ai_impl_provider.dart';
import 'package:aconsia_app/ai/domain/usecases/get_unviewed_recommendations.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'get_unviewed_recommendations_provider.g.dart';

@riverpod
GetUnviewedRecommendations getUnviewedRecommendations(
    GetUnviewedRecommendationsRef ref) {
  return GetUnviewedRecommendations(repository: ref.read(aiRepositoryProvider));
}
