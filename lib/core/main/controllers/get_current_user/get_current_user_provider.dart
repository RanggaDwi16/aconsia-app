import 'package:aconsia_app/core/main/controllers/authentciation_impl_provider.dart';
import 'package:aconsia_app/core/main/domain/usecases/get_current_user.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'get_current_user_provider.g.dart';

@riverpod
GetCurrentUser getCurrentUser(GetCurrentUserRef ref) {
  return GetCurrentUser(
      repository: ref.watch(authenticationRepositoryProvider));
}
