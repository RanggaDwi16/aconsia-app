import 'package:aconsia_app/core/helpers/widgets/buttons.dart';
import 'package:aconsia_app/core/helpers/widgets/custom_text_field.dart';
import 'package:aconsia_app/core/main/controllers/auth/authentication_provider.dart';
import 'package:aconsia_app/core/main/controllers/register/register_provider.dart';
import 'package:aconsia_app/core/providers/repository_providers.dart';
import 'package:aconsia_app/core/routers/router_name.dart';
import 'package:aconsia_app/core/utils/constant/app_colors.dart';
import 'package:aconsia_app/core/utils/extensions/build_context_ext.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aconsia_app/core/helpers/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final showPasswordProvider = StateProvider.autoDispose<bool>((ref) => false);

class LoginDokterPage extends HookConsumerWidget {
  const LoginDokterPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final showPassword = ref.watch(showPasswordProvider);

    final auth = ref.watch(authenticationProvider);

    useListenable(emailController);
    useListenable(passwordController);

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Kembali',
        centertitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Portal Dokter',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Gap(8),
            Text(
              'Kelola materi edukasi anestesi untuk pasien anda',
              style: TextStyle(
                fontSize: 14,
                color: AppColor.textGrayColor,
              ),
              textAlign: TextAlign.center,
            ),
            Gap(32),
            CustomTextField(
              controller: emailController,
              hintText: 'Email',
              labelText: 'Email',
            ),
            Gap(16),
            CustomTextField(
              labelText: 'Password',
              controller: passwordController,
              hintText: 'Password',
              obscureText: !showPassword,
              suffixIcon: IconButton(
                icon: Icon(
                  showPassword ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () =>
                    ref.read(showPasswordProvider.notifier).update((v) => !v),
              ),
            ),
            Gap(8),
            Align(
              alignment: Alignment.topLeft,
              child: InkWell(
                onTap: () => context.pushNamed(RouteName.forgotPassword),
                child: Text(
                  'Lupa Password?',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColor.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Gap(24),
            Button.filled(
              disabled: emailController.text.isEmpty ||
                  passwordController.text.isEmpty ||
                  auth.isLoading,
              onPressed: () => ref.read(authenticationProvider.notifier).login(
                    email: emailController.text.trim(),
                    password: passwordController.text.trim(),
                    onSuccess: (user) async {
                      context.showSuccessDialog(
                          context, 'Login Dokter Berhasil');

                      if (!user.isProfileCompleted) {
                        context.goNamed(RouteName.editProfile);
                      } else {
                        context.goNamed(RouteName.mainDokter);
                      }
                    },
                    onError: (error) {
                      context.showErrorSnackbar(context, error);
                    },
                  ),
              label: auth.isLoading ? 'Memuat...' : 'Masuk',
            ),
            Gap(16),
            Button.outlined(
              onPressed: () => context.pushNamed(RouteName.registerDokter),
              label: 'Daftar Akun',
            ),
          ],
        ),
      ),
    );
  }
}
