import 'package:aconsia_app/core/ui/components/aconsia_screen_shell.dart';
import 'package:aconsia_app/core/ui/components/aconsia_surface.dart';
import 'package:aconsia_app/core/ui/tokens/ui_palette.dart';
import 'package:aconsia_app/core/ui/tokens/ui_spacing.dart';
import 'package:aconsia_app/core/ui/tokens/ui_typography.dart';
import 'package:aconsia_app/presentation/pasien/main/controllers/selected_index_provider.dart';
import 'package:aconsia_app/presentation/pasien/main/widgets/pasien_main_shell_scope.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

class PasienFeaturePlaceholderPage extends ConsumerWidget {
  final String title;
  final String description;
  final IconData icon;

  const PasienFeaturePlaceholderPage({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: AconsiaPageBackground(
        colors: const [
          UiPalette.blue50,
          UiPalette.white,
        ],
        child: Padding(
          padding: const EdgeInsets.all(UiSpacing.md),
          child: Column(
            children: [
              AconsiaTopActionRow(
                title: title,
                subtitle: 'Fitur ini sedang kami persiapkan untuk Anda.',
                leading: IconButton(
                  onPressed: () =>
                      PasienMainShellScope.maybeOf(context)?.openDrawer(),
                  icon: const Icon(Icons.menu_rounded),
                  color: UiPalette.slate600,
                ),
              ),
              const Gap(UiSpacing.lg),
              Expanded(
                child: Center(
                  child: AconsiaCardSurface(
                    borderColor: UiPalette.slate200,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(icon, size: 44, color: UiPalette.blue600),
                        const Gap(UiSpacing.md),
                        Text(
                          title,
                          style: UiTypography.label.copyWith(
                            fontSize: 22,
                            color: UiPalette.slate900,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const Gap(UiSpacing.sm),
                        Text(
                          description,
                          style: UiTypography.bodySmall.copyWith(
                            color: UiPalette.slate500,
                            fontSize: 15,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const Gap(UiSpacing.lg),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => ref
                                .read(selectedIndexPasienProvider.notifier)
                                .state = 0,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: UiPalette.blue600,
                              foregroundColor: UiPalette.white,
                              padding: const EdgeInsets.symmetric(
                                vertical: UiSpacing.sm,
                              ),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text('Kembali ke Dashboard'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
