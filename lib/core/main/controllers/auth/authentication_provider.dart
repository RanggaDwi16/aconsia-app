import 'package:aconsia_app/core/main/controllers/login/login_provider.dart';
import 'package:aconsia_app/core/main/controllers/logout/logout_provider.dart';
import 'package:aconsia_app/core/main/controllers/register/register_provider.dart';
import 'package:aconsia_app/core/main/controllers/forgot_password/forgot_password_provider.dart';
import 'package:aconsia_app/core/main/controllers/get_current_user/get_current_user_provider.dart';
import 'package:aconsia_app/core/main/controllers/update_profile/update_profile_provider.dart';
import 'package:aconsia_app/core/main/controllers/delete_account/delete_account_provider.dart';
import 'package:aconsia_app/core/main/domain/usecases/login.dart';
import 'package:aconsia_app/core/main/domain/usecases/register_dokter.dart';
import 'package:aconsia_app/core/main/domain/usecases/register_pasien.dart';
import 'package:aconsia_app/core/main/domain/usecases/forgot_password.dart';
import 'package:aconsia_app/core/main/domain/usecases/get_current_user.dart';
import 'package:aconsia_app/core/main/domain/usecases/update_profile_completed.dart';
import 'package:aconsia_app/core/main/domain/usecases/delete_account.dart';
import 'package:aconsia_app/core/providers/token_manager_provider.dart';
import 'package:aconsia_app/core/routers/router_name.dart';
import 'package:aconsia_app/core/main/data/models/user_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'authentication_provider.g.dart';

@Riverpod(keepAlive: true)
class Authentication extends _$Authentication {
  @override
  FutureOr<String?> build() {
    return null;
  }

  Future<void> login({
    required String email,
    required String password,
    required Function(UserModel userModel) onSuccess,
    required Function(String error) onError,
  }) async {
    state = const AsyncLoading();

    final login = ref.watch(loginProvider);
    final result = await login(LoginParams(email: email, password: password));

    await result.fold(
      (error) async {
        state = AsyncError(error, StackTrace.current);
        onError(error);
      },
      (userModel) async {
        // Save user session to SharedPreferences
        // Get TokenManager instance
        final tokenManager = await ref.read(tokenManagerProvider.future);
        await tokenManager.saveUserSession(
          uid: userModel.uid,
          email: userModel.email,
          name: userModel.name!,
          role: userModel.role,
          isProfileCompleted: userModel.isProfileCompleted,
        );
        await tokenManager.saveUid(userModel.uid);
        await tokenManager.saveEmail(userModel.email);

        state = AsyncData("Login successful");
        onSuccess(userModel);
      },
    );
  }

  Future<void> registerDokter({
    required String email,
    required String password,
    required String name,
    required Function(String message) onSuccess,
    required Function(String error) onError,
  }) async {
    state = AsyncLoading();
    final registerDokter = ref.watch(registerDokterProvider);
    final result = await registerDokter(
      RegisterDokterParams(email: email, password: password, name: name),
    );
    result.fold(
      (error) {
        state = AsyncError(error, StackTrace.current);
        onError(error);
      },
      (message) {
        state = AsyncData(message);
        onSuccess(message);
      },
    );
  }

  Future<void> registerPasien({
    required String email,
    required String password,
    required String name,
    required Function(String message) onSuccess,
    required Function(String error) onError,
  }) async {
    state = AsyncLoading();
    final registerPasien = ref.watch(registerPasienProvider);
    final result = await registerPasien(
      RegisterPasienParams(email: email, password: password, name: name),
    );
    result.fold(
      (error) {
        state = AsyncError(error, StackTrace.current);
        onError(error);
      },
      (message) {
        state = AsyncData(message);
        onSuccess(message);
      },
    );
  }

  Future<void> logout({
    required Function(String message) onSuccess,
    required Function(String error) onError,
  }) async {
    state = AsyncLoading();
    final logout = ref.watch(logoutProvider);
    final result = await logout(null);
    result.fold(
      (error) {
        state = AsyncError(error, StackTrace.current);
        onError(error);
      },
      (message) {
        state = AsyncData(message);
        onSuccess(message);
      },
    );
  }

  Future<void> forgotPassword({
    required String email,
    required Function(String message) onSuccess,
    required Function(String error) onError,
  }) async {
    state = AsyncLoading();
    final forgotPassword = ref.watch(forgotPasswordProvider);
    final result = await forgotPassword(ForgotPasswordParams(email: email));
    result.fold(
      (error) {
        state = AsyncError(error, StackTrace.current);
        onError(error);
      },
      (message) {
        state = AsyncData(message);
        onSuccess(message);
      },
    );
  }

  Future<void> getCurrentUser({
    required Function(UserModel userData) onSuccess,
    required Function(String error) onError,
  }) async {
    state = AsyncLoading();
    final getCurrentUser = ref.watch(getCurrentUserProvider);
    final result = await getCurrentUser(GetCurrentUserParams());
    result.fold(
      (error) {
        state = AsyncError(error, StackTrace.current);
        onError(error);
      },
      (userData) {
        state = AsyncData("User data loaded");
        onSuccess(userData);
      },
    );
  }

  Future<void> updateProfileCompleted({
    required String uid,
    required bool isCompleted,
    required Function(String message) onSuccess,
    required Function(String error) onError,
  }) async {
    state = AsyncLoading();
    final updateProfile = ref.watch(updateProfileCompletedProvider);
    final result = await updateProfile(
      UpdateProfileCompletedParams(uid: uid, isCompleted: isCompleted),
    );
    result.fold(
      (error) {
        state = AsyncError(error, StackTrace.current);
        onError(error);
      },
      (message) async {
        state = AsyncData(message);
        final tokenManager = await ref.read(tokenManagerProvider.future);
        await tokenManager.saveProfileCompleted(true);
        onSuccess(message);
      },
    );
  }

  Future<void> deleteAccount({
    required String uid,
    required Function(String message) onSuccess,
    required Function(String error) onError,
  }) async {
    state = AsyncLoading();
    final deleteAccount = ref.watch(deleteAccountProvider);
    final result = await deleteAccount(DeleteAccountParams(uid: uid));
    result.fold(
      (error) {
        state = AsyncError(error, StackTrace.current);
        onError(error);
      },
      (message) {
        state = AsyncData(message);
        onSuccess(message);
      },
    );
  }
}
