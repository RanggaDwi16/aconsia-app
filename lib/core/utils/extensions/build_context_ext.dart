import 'package:aconsia_app/core/main/controllers/auth/authentication_provider.dart';
import 'package:aconsia_app/core/providers/token_manager_provider.dart';
import 'package:aconsia_app/core/routers/router_name.dart';
import 'package:aconsia_app/core/utils/constant/app_colors.dart';
import 'package:aconsia_app/presentation/dokter/main/controllers/selected_index_provider.dart';
import 'package:aconsia_app/presentation/pasien/main/controllers/selected_index_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toastification/toastification.dart';

extension BuildContextExt on BuildContext {
  double get deviceHeight => MediaQuery.of(this).size.height;
  double get deviceWidth => MediaQuery.of(this).size.width;

  // Show success dialog using Toastification
  void showSuccessDialog(BuildContext context, String message) {
    toastification.show(
      context: context, // optional if you use ToastificationWrapper
      type: ToastificationType.success,
      style: ToastificationStyle.fillColored,
      autoCloseDuration: const Duration(seconds: 3),
      title: Text(message),

      alignment: Alignment.topRight,
      direction: TextDirection.ltr,
      animationDuration: const Duration(milliseconds: 3),
      icon: const Icon(Icons.check),
      showIcon: true, // show or hide the icon
      primaryColor: AppColor.primaryColor,
      backgroundColor: AppColor.primaryWhite,
      foregroundColor: Colors.black,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      borderRadius: BorderRadius.circular(12),

      closeButton: ToastCloseButton(
        showType: CloseButtonShowType.onHover,
        buttonBuilder: (context, onClose) {
          return OutlinedButton.icon(
            onPressed: onClose,
            icon: const Icon(Icons.close, size: 20),
            label: const Text('Close'),
          );
        },
      ),
      closeOnClick: false,
      pauseOnHover: true,
      dragToClose: true,
      applyBlurEffect: true,
    );
  }

  // Show error snackbar using Toastification
  void showErrorSnackbar(BuildContext context, String message) {
    toastification.show(
      context: context, // optional if you use ToastificationWrapper
      type: ToastificationType.error,
      style: ToastificationStyle.fillColored,
      autoCloseDuration: const Duration(seconds: 3),
      title: Text(message),

      alignment: Alignment.topRight,
      direction: TextDirection.ltr,
      animationDuration: const Duration(milliseconds: 3),
      icon: const Icon(Icons.close),
      showIcon: true,
      primaryColor: AppColor.primaryRed,
      backgroundColor: AppColor.primaryWhite,
      foregroundColor: Colors.black,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      borderRadius: BorderRadius.circular(12),
      // showProgressBar: true,
      closeButton: ToastCloseButton(
        showType: CloseButtonShowType.onHover,
        buttonBuilder: (context, onClose) {
          return OutlinedButton.icon(
            onPressed: onClose,
            icon: const Icon(Icons.close, size: 20),
            label: const Text('Close'),
          );
        },
      ),
      closeOnClick: false,
      pauseOnHover: true,
      dragToClose: true,
      applyBlurEffect: true,
    );
  }

  Future<bool?> showDeleteContentDialog({
    required VoidCallback onConfirm,
    String title = 'Hapus Konten?',
    String subtitle =
        'Tindakan ini akan menghapus konten secara permanen dan tidak dapat dikembalikan. Apakah Anda yakin ingin melanjutkan?',
  }) {
    return showDialog<bool>(
      context: this,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: AppColor.primaryRed.withOpacity(0.12),
                  child: Icon(
                    Icons.delete_outline_rounded,
                    color: AppColor.primaryRed,
                    size: 30,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 10),
                Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 14, color: Colors.black54),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        style: OutlinedButton.styleFrom(
                          backgroundColor: const Color(0xFF5A6A78),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: const Text(
                          'Batal',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop(true);
                          onConfirm();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor.primaryRed,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: const Text(
                          'Ya, Hapus',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<bool?> showLogoutDialog() {
    final rootContext = this;
    return showDialog<bool>(
      context: rootContext,
      barrierDismissible: true,
      builder: (dialogContext) {
        bool isSubmitting = false;

        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: AppColor.primaryRed.withOpacity(0.12),
                  child: Icon(Icons.warning_amber_rounded,
                      color: AppColor.primaryRed, size: 30),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Yakin Ingin Keluar?',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Anda akan keluar dari akun ini. Pastikan semua data atau perubahan sudah tersimpan sebelum melanjutkan.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                ),
                const SizedBox(height: 20),
                StatefulBuilder(
                  builder: (context, setDialogState) {
                    return Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: isSubmitting
                                ? null
                                : () => Navigator.of(dialogContext).pop(false),
                            style: OutlinedButton.styleFrom(
                              backgroundColor: const Color(
                                  0xFF5A6A78), // dark gray-like background
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            child: const Text(
                              'Cancel',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: isSubmitting
                                ? null
                                : () async {
                                    setDialogState(() {
                                      isSubmitting = true;
                                    });

                                    final container = ProviderScope.containerOf(
                                      dialogContext,
                                      listen: false,
                                    );

                                    await container
                                        .read(authenticationProvider.notifier)
                                        .logout(
                                      onSuccess: (_) async {
                                        final tokenManager = await container
                                            .read(tokenManagerProvider.future);
                                        await tokenManager.clearUserSession();
                                        container
                                            .read(
                                                selectedIndexProvider.notifier)
                                            .state = 0;
                                        container
                                            .read(selectedIndexPasienProvider
                                                .notifier)
                                            .state = 0;

                                        if (dialogContext.mounted &&
                                            Navigator.of(dialogContext)
                                                .canPop()) {
                                          Navigator.of(dialogContext).pop(true);
                                        }

                                        if (!rootContext.mounted) return;
                                        rootContext.goNamed(RouteName.welcome);
                                        rootContext.showSuccessDialog(
                                          rootContext,
                                          'Berhasil Logout',
                                        );
                                      },
                                      onError: (error) {
                                        if (!rootContext.mounted) return;
                                        rootContext.showErrorSnackbar(
                                          rootContext,
                                          'Gagal Logout: $error',
                                        );
                                      },
                                    );

                                    if (dialogContext.mounted) {
                                      setDialogState(() {
                                        isSubmitting = false;
                                      });
                                    }
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColor.primaryRed,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            child: isSubmitting
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Text(
                                    'Yes, Log Out',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600),
                                  ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> showSuccessEditDialog({
    String title = 'Profile Berhasil Di Update',
    String subtitle = 'Perubahan profil Anda telah disimpan dengan aman.',
    Duration duration = const Duration(seconds: 2),
  }) {
    return showDialog<void>(
      context: this,
      barrierDismissible: true,
      builder: (context) {
        // Auto close after [duration]
        Future.delayed(duration, () {
          context.goNamed(RouteName.mainDokter);
        });

        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          insetPadding: const EdgeInsets.symmetric(horizontal: 40),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 26),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: AppColor.primaryGreen.withOpacity(0.12),
                  child: Icon(
                    Icons.check,
                    color: AppColor.primaryGreen,
                    size: 30,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 10),
                Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 14, color: Colors.black54),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
