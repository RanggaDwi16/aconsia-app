import 'package:aconsia_app/ai/controllers/ai_impl_provider.dart';
import 'package:aconsia_app/ai/domain/usecases/get_recommendations_for_pasien.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'get_recommendations_for_pasien_provider.g.dart';

@riverpod
GetRecommendationsForPasien getRecommendationsForPasien (GetRecommendationsForPasienRef ref) {
  return GetRecommendationsForPasien(repository: ref.read(aiRepositoryProvider));
}