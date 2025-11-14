import 'package:aconsia_app/core/helpers/custom_app_bar.dart';
import 'package:aconsia_app/core/helpers/widgets/buttons.dart';
import 'package:aconsia_app/core/helpers/widgets/custom_text_field.dart';
import 'package:aconsia_app/core/main/controllers/auth/authentication_provider.dart';
import 'package:aconsia_app/core/utils/constant/app_colors.dart';
import 'package:aconsia_app/core/utils/extensions/build_context_ext.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final passwordVisibleProvider = StateProvider.autoDispose<bool>((ref) => false);
final confirmPasswordVisibleProvider =
    StateProvider.autoDispose<bool>((ref) => false);

class RegisterDokterPage extends HookConsumerWidget {
  const RegisterDokterPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final namaController = useTextEditingController();
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final confirmPasswordController = useTextEditingController();

    final isPasswordVisible = ref.watch(passwordVisibleProvider);
    final isConfirmPasswordVisible = ref.watch(confirmPasswordVisibleProvider);

    final auth = ref.watch(authenticationProvider);

    useListenable(namaController);
    useListenable(emailController);
    useListenable(passwordController);
    useListenable(confirmPasswordController);

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Daftar Akun',
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
              controller: namaController,
              hintText: 'Nama Lengkap',
              labelText: 'Nama Lengkap',
            ),
            Gap(16),
            CustomTextField(
              controller: emailController,
              hintText: 'Email',
              labelText: 'Email',
              keyboardType: TextInputType.emailAddress,
            ),
            Gap(16),
            CustomTextField(
              controller: passwordController,
              hintText: 'Password',
              labelText: 'Password',
              obscureText: !isPasswordVisible,
              suffixIcon: IconButton(
                icon: Icon(isPasswordVisible
                    ? Icons.visibility
                    : Icons.visibility_off),
                onPressed: () => ref
                    .read(passwordVisibleProvider.notifier)
                    .update((s) => !s),
              ),
            ),
            Gap(16),
            CustomTextField(
              controller: confirmPasswordController,
              hintText: 'Konfirmasi Password',
              labelText: 'Konfirmasi Password',
              obscureText: !isConfirmPasswordVisible,
              suffixIcon: IconButton(
                icon: Icon(isConfirmPasswordVisible
                    ? Icons.visibility
                    : Icons.visibility_off),
                onPressed: () => ref
                    .read(confirmPasswordVisibleProvider.notifier)
                    .update((s) => !s),
              ),
            ),
            Gap(36),
            Button.filled(
              disabled: namaController.text.isEmpty ||
                  emailController.text.isEmpty ||
                  passwordController.text.isEmpty ||
                  confirmPasswordController.text.isEmpty ||
                  passwordController.text.trim() !=
                      confirmPasswordController.text.trim() ||
                  auth.isLoading,
              onPressed: () =>
                  ref.read(authenticationProvider.notifier).registerDokter(
                        email: emailController.text.trim(),
                        password: passwordController.text.trim(),
                        name: namaController.text.trim(),
                        onSuccess: (message) {
                          context.showSuccessDialog(context, message);
                        },
                        onError: (error) {
                          context.showErrorSnackbar(context, error);
                        },
                      ),
              label: auth.isLoading ? 'Memproses...' : 'Daftar',
            )
          ],
        ),
      ),
    );
  }
}
