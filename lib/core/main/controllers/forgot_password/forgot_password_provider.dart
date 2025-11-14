import 'package:aconsia_app/core/main/controllers/authentciation_impl_provider.dart';
import 'package:aconsia_app/core/main/domain/usecases/forgot_password.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'forgot_password_provider.g.dart';

@riverpod
ForgotPassword forgotPassword(ForgotPasswordRef ref) {
  return ForgotPassword(
      repository: ref.watch(authenticationRepositoryProvider));
}
