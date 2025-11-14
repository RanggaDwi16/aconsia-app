import 'package:aconsia_app/core/helpers/widgets/buttons.dart';
import 'package:aconsia_app/core/main/controllers/auth/authentication_provider.dart';
import 'package:aconsia_app/core/utils/extensions/build_context_ext.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aconsia_app/core/helpers/custom_app_bar.dart';
import 'package:aconsia_app/core/helpers/widgets/custom_text_field.dart';
import 'package:aconsia_app/core/utils/constant/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ForgotPasswordPage extends HookConsumerWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailController = useTextEditingController();
    final auth = ref.watch(authenticationProvider);
    useListenable(emailController);

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Reset Password',
        centertitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Masukan alamat email kamu untuk melakukan reset password',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: AppColor.textGrayColor,
              ),
              textAlign: TextAlign.center,
            ),
            Gap(24),
            CustomTextField(
              controller: emailController,
              hintText: 'Enter your email address',
              prefixIcon: Icon(Icons.email_outlined),
              keyboardType: TextInputType.emailAddress,
            ),
            Gap(36),
            Button.filled(
              disabled: emailController.text.isEmpty || auth.isLoading,
              onPressed: () =>
                  ref.read(authenticationProvider.notifier).forgotPassword(
                        email: emailController.text.trim(),
                        onSuccess: (message) {
                          context.showSuccessDialog(context,
                              'Link reset password telah dikirim ke email Anda.');
                          Navigator.pop(context);
                        },
                        onError: (error) {
                          context.showErrorSnackbar(context, error);
                        },
                      ),
              label: auth.isLoading ? 'Memproses...' : 'Reset Password',
            ),
          ],
        ),
      ),
    );
  }
}
