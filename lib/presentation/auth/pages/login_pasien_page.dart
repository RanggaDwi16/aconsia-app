import 'package:aconsia_app/core/helpers/custom_app_bar.dart';
import 'package:aconsia_app/core/helpers/widgets/buttons.dart';
import 'package:aconsia_app/core/helpers/widgets/custom_text_field.dart';
import 'package:aconsia_app/core/main/controllers/auth/authentication_provider.dart';
import 'package:aconsia_app/core/routers/router_name.dart';
import 'package:aconsia_app/core/utils/constant/app_colors.dart';
import 'package:aconsia_app/core/utils/extensions/build_context_ext.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final showPasswordProvider = StateProvider.autoDispose<bool>((ref) => false);
const _emailPattern = r'^[^\s@]+@[^\s@]+\.[^\s@]+$';

class LoginPasienPage extends HookConsumerWidget {
  const LoginPasienPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final showPassword = ref.watch(showPasswordProvider);
    final auth = ref.watch(authenticationProvider);

    useListenable(emailController);
    useListenable(passwordController);

    bool isValidEmail(String value) {
      return RegExp(_emailPattern).hasMatch(value.trim());
    }

    void handleLogin() {
      final email = emailController.text.trim();
      final password = passwordController.text.trim();

      if (email.isEmpty) {
        context.showErrorSnackbar(context, 'Email wajib diisi.');
        return;
      }

      if (!isValidEmail(email)) {
        context.showErrorSnackbar(context, 'Format email tidak valid.');
        return;
      }

      if (password.isEmpty) {
        context.showErrorSnackbar(context, 'Password wajib diisi.');
        return;
      }

      if (password.length < 6) {
        context.showErrorSnackbar(context, 'Password minimal 6 karakter.');
        return;
      }

      ref.read(authenticationProvider.notifier).login(
            email: email,
            password: password,
            onSuccess: (user) async {
              context.showSuccessDialog(context, 'Login Pasien Berhasil');
              if (!user.isProfileCompleted) {
                context.goNamed(RouteName.editProfilePasien);
              } else {
                context.goNamed(RouteName.mainPasien);
              }
            },
            onError: (error) {
              context.showErrorSnackbar(context, error);
            },
          );
    }

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Kembali',
        centertitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFF2F8FF),
              Color(0xFFF8FCFF),
            ],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Gap(8),
              const Text(
                'Login Pasien',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Gap(6),
              const Text(
                'Sistem Informasi Informed Consent Anestesi',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColor.textGrayColor,
                ),
                textAlign: TextAlign.center,
              ),
              const Gap(24),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFDCE9FF)),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x14000000),
                      blurRadius: 12,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      width: 62,
                      height: 62,
                      decoration: const BoxDecoration(
                        color: AppColor.primaryColor,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.person_outline,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                    const Gap(14),
                    CustomTextField(
                      controller: emailController,
                      hintText: 'Masukkan email Anda',
                      labelText: 'Email',
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const Gap(16),
                    CustomTextField(
                      labelText: 'Password',
                      controller: passwordController,
                      hintText: 'Masukkan password',
                      obscureText: !showPassword,
                      suffixIcon: IconButton(
                        icon: Icon(
                          showPassword ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () => ref
                            .read(showPasswordProvider.notifier)
                            .update((v) => !v),
                      ),
                    ),
                    const Gap(8),
                    Align(
                      alignment: Alignment.topLeft,
                      child: InkWell(
                        onTap: () => context.pushNamed(RouteName.forgotPassword),
                        child: const Text(
                          'Lupa Password?',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColor.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const Gap(20),
                    Button.filled(
                      disabled: emailController.text.isEmpty ||
                          passwordController.text.isEmpty ||
                          auth.isLoading,
                      onPressed: handleLogin,
                      label: auth.isLoading ? 'Memuat...' : 'Masuk',
                    ),
                    const Gap(12),
                    Button.outlined(
                      onPressed: () => context.pushNamed(RouteName.registerPasien),
                      label: 'Belum Punya Akun? Daftar Pasien',
                    ),
                  ],
                ),
              ),
              const Gap(20),
              const Text(
                'Gunakan akun pasien yang terdaftar untuk mengakses materi edukasi.',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColor.textGrayColor,
                ),
                textAlign: TextAlign.center,
              ),
              const Gap(12),
            ],
          ),
        ),
      ),
    );
  }
}
