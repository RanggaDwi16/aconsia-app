import 'package:aconsia_app/core/main/controllers/authentciation_impl_provider.dart';
import 'package:aconsia_app/core/main/domain/usecases/login.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'login_provider.g.dart';

@riverpod
Login login (LoginRef ref) {
  return Login(repository: ref.watch(authenticationRepositoryProvider));
}