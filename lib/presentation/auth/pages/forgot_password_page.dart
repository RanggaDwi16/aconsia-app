import 'package:aconsia_app/core/helpers/widgets/buttons.dart';
import 'package:aconsia_app/core/main/controllers/auth/authentication_provider.dart';
import 'package:aconsia_app/core/ui/components/aconsia_auth_shell.dart';
import 'package:aconsia_app/core/ui/components/aconsia_surface.dart';
import 'package:aconsia_app/core/ui/tokens/ui_palette.dart';
import 'package:aconsia_app/core/ui/tokens/ui_spacing.dart';
import 'package:aconsia_app/core/ui/tokens/ui_typography.dart';
import 'package:aconsia_app/core/utils/extensions/build_context_ext.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:aconsia_app/core/helpers/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

const _emailPattern = r'^[^\s@]+@[^\s@]+\.[^\s@]+$';

class ForgotPasswordPage extends HookConsumerWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailController = useTextEditingController();
    final auth = ref.watch(authenticationProvider);
    useListenable(emailController);

    bool isValidEmail(String value) {
      return RegExp(_emailPattern).hasMatch(value.trim());
    }

    void handleSubmit() {
      final email = emailController.text.trim();
      if (email.isEmpty) {
        context.showErrorSnackbar(context, 'Email wajib diisi.');
        return;
      }
      if (!isValidEmail(email)) {
        context.showErrorSnackbar(context, 'Format email tidak valid.');
        return;
      }

      ref.read(authenticationProvider.notifier).forgotPassword(
            email: email,
            onSuccess: (message) {
              context.showSuccessDialog(
                context,
                'Link reset password telah dikirim ke email Anda.',
              );
              Navigator.pop(context);
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
                          AconsiaAuthBackButton(
                            onPressed: () => Navigator.of(context).maybePop(),
                          ),
                          const Gap(UiSpacing.xl),
                          AconsiaAuthCard(
                            child: Column(
                              children: [
                                const Icon(
                                  Icons.lock_reset_rounded,
                                  size: 40,
                                  color: UiPalette.blue600,
                                ),
                                const Gap(UiSpacing.sm),
                                const Text(
                                  'Reset Password',
                                  style: UiTypography.h2,
                                ),
                                const Gap(UiSpacing.xs),
                                const Text(
                                  'Masukkan alamat email Anda untuk menerima link reset password.',
                                  textAlign: TextAlign.center,
                                  style: UiTypography.body,
                                ),
                                const Gap(UiSpacing.lg),
                                CustomTextField(
                                  controller: emailController,
                                  labelText: 'Email',
                                  hintText: 'Masukkan email Anda',
                                  prefixIcon: const Icon(Icons.email_outlined),
                                  keyboardType: TextInputType.emailAddress,
                                ),
                                const Gap(UiSpacing.xl),
                                Button.filled(
                                  disabled: emailController.text.isEmpty ||
                                      auth.isLoading,
                                  onPressed: handleSubmit,
                                  label: auth.isLoading
                                      ? 'Memproses...'
                                      : 'Kirim Link Reset',
                                  color: const Color(0xFF2563EB),
                                  borderColor: const Color(0xFF2563EB),
                                  height: 52,
                                  borderRadius: 12,
                                ),
                              ],
                            ),
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
