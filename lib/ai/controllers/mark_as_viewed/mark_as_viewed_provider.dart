import 'package:aconsia_app/ai/controllers/ai_impl_provider.dart';
import 'package:aconsia_app/ai/domain/usecases/mark_as_viewed.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'mark_as_viewed_provider.g.dart';

@riverpod
MarkAsViewed markAsViewed (MarkAsViewedRef ref) {
  return MarkAsViewed(repository: ref.read(aiRepositoryProvider));
}