import 'package:aconsia_app/core/main/controllers/authentciation_impl_provider.dart';
import 'package:aconsia_app/core/main/domain/usecases/update_profile_completed.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'update_profile_provider.g.dart';

@riverpod
UpdateProfileCompleted updateProfileCompleted(UpdateProfileCompletedRef ref) {
  return UpdateProfileCompleted(
      repository: ref.watch(authenticationRepositoryProvider));
}
