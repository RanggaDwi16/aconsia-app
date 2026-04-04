import 'package:aconsia_app/core/helpers/widgets/buttons.dart';
import 'package:aconsia_app/core/helpers/widgets/custom_text_field.dart';
import 'package:aconsia_app/core/main/controllers/auth/authentication_provider.dart';
import 'package:aconsia_app/core/routers/router_name.dart';
import 'package:aconsia_app/core/ui/components/aconsia_auth_shell.dart';
import 'package:aconsia_app/core/ui/components/aconsia_brand_logo.dart';
import 'package:aconsia_app/core/ui/components/aconsia_surface.dart';
import 'package:aconsia_app/core/ui/tokens/ui_palette.dart';
import 'package:aconsia_app/core/ui/tokens/ui_spacing.dart';
import 'package:aconsia_app/core/ui/tokens/ui_typography.dart';
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
      backgroundColor: UiPalette.blue50,
      body: SafeArea(
        child: AconsiaPageBackground(
          colors: const [UiPalette.blue50, UiPalette.white],
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: UiSpacing.pageHorizontal,
                    vertical: UiSpacing.pageVertical,
                  ),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 440),
                      child: Column(
                        children: [
                          AconsiaAuthBackButton(onPressed: () => context.pop()),
                          const Gap(UiSpacing.xl),
                          AconsiaAuthCard(
                            padding: EdgeInsets.zero,
                            child: Column(
                              children: [
                                Container(
                                  width: double.infinity,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF2563EB),
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(16),
                                      topRight: Radius.circular(16),
                                    ),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: UiSpacing.xxl,
                                  ),
                                  child: Column(
                                    children: [
                                      const AconsiaBrandLogo(size: 78, imageSize: 48),
                                      const Gap(UiSpacing.sm),
                                      Text(
                                        'Login Pasien',
                                        style: UiTypography.h2.copyWith(
                                          color: Colors.white,
                                        ),
                                      ),
                                      const Gap(UiSpacing.xs),
                                      Text(
                                        'Sistem Informasi Informed Consent Anestesi',
                                        textAlign: TextAlign.center,
                                        style: UiTypography.bodySmall.copyWith(
                                          color: const Color(0xFFBFDBFE),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(UiSpacing.xl),
                                  child: Column(
                                    children: [
                                      CustomTextField(
                                        controller: emailController,
                                        hintText: 'Masukkan email Anda',
                                        labelText: 'Email',
                                        keyboardType:
                                            TextInputType.emailAddress,
                                      ),
                                      const Gap(UiSpacing.lg),
                                      CustomTextField(
                                        labelText: 'Password',
                                        controller: passwordController,
                                        hintText: 'Masukkan password',
                                        obscureText: !showPassword,
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                            showPassword
                                                ? Icons.visibility
                                                : Icons.visibility_off,
                                          ),
                                          onPressed: () => ref
                                              .read(
                                                  showPasswordProvider.notifier)
                                              .update((v) => !v),
                                        ),
                                      ),
                                      const Gap(UiSpacing.sm),
                                      Align(
                                        alignment: Alignment.topLeft,
                                        child: InkWell(
                                          onTap: () => context.pushNamed(
                                              RouteName.forgotPassword),
                                          child: const Text(
                                            'Lupa Password?',
                                            style: UiTypography.body,
                                          ),
                                        ),
                                      ),
                                      const Gap(UiSpacing.xl),
                                      Button.filled(
                                        disabled: emailController
                                                .text.isEmpty ||
                                            passwordController.text.isEmpty ||
                                            auth.isLoading,
                                        onPressed: handleLogin,
                                        label: auth.isLoading
                                            ? 'Memuat...'
                                            : 'Masuk',
                                        color: const Color(0xFF2563EB),
                                        borderColor: const Color(0xFF2563EB),
                                        height: 52,
                                        borderRadius: 12,
                                      ),
                                      const Gap(UiSpacing.sm),
                                      Button.outlined(
                                        onPressed: () => context.pushNamed(
                                            RouteName.registerPasien),
                                        label:
                                            'Belum Punya Akun? Daftar Pasien',
                                        borderColor: const Color(0xFF93C5FD),
                                        textColor: const Color(0xFF1D4ED8),
                                        height: 52,
                                        borderRadius: 12,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Gap(UiSpacing.lg),
                          const Text(
                            'Gunakan akun pasien yang terdaftar untuk mengakses materi edukasi.',
                            textAlign: TextAlign.center,
                            style: UiTypography.caption,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const AconsiaAuthFooter(),
            ],
          ),
        ),
      ),
    );
  }
}
