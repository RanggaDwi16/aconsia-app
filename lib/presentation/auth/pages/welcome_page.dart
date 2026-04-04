import 'package:aconsia_app/core/helpers/widgets/buttons.dart';
import 'package:aconsia_app/core/routers/router_name.dart';
import 'package:aconsia_app/core/ui/components/aconsia_auth_shell.dart';
import 'package:aconsia_app/core/ui/components/aconsia_brand_logo.dart';
import 'package:aconsia_app/core/ui/components/aconsia_surface.dart';
import 'package:aconsia_app/core/ui/tokens/ui_palette.dart';
import 'package:aconsia_app/core/ui/tokens/ui_spacing.dart';
import 'package:aconsia_app/core/ui/tokens/ui_typography.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UiPalette.blue50,
      body: SafeArea(
        child: AconsiaPageBackground(
          colors: const [UiPalette.blue50, UiPalette.white],
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: UiSpacing.pageHorizontal,
                      vertical: UiSpacing.xxxl,
                    ),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 440),
                      child: Column(
                        children: [
                          _LogoSection(),
                          const Gap(UiSpacing.xxxl),
                          const _DescriptionSection(),
                          const Gap(UiSpacing.lg),
                          const Text(
                            'Portal desktop khusus dokter dan admin. Pasien menggunakan aplikasi mobile.',
                            textAlign: TextAlign.center,
                            style: UiTypography.bodySmall,
                          ),
                          const Gap(UiSpacing.md),
                          Button.filled(
                            onPressed: () =>
                                context.pushNamed(RouteName.loginDokter),
                            label: 'Masuk Sebagai Dokter',
                            color: const Color(0xFF059669),
                            borderColor: const Color(0xFF059669),
                            height: 54,
                            borderRadius: 12,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                          ),
                          const Gap(UiSpacing.sm),
                          Button.outlined(
                            onPressed: () =>
                                context.pushNamed(RouteName.loginPasien),
                            label: 'Masuk Sebagai Pasien',
                            textColor: UiPalette.slate700,
                            borderColor: UiPalette.slate300,
                            height: 54,
                            borderRadius: 12,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                          ),
                          const Gap(UiSpacing.lg),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Butuh Bantuan?',
                                style: UiTypography.body,
                              ),
                              const Gap(UiSpacing.sm),
                              InkWell(
                                onTap: () =>
                                    context.pushNamed(RouteName.helpdesk),
                                child: const Text(
                                  'Tutorial',
                                  style: TextStyle(
                                    color: UiPalette.blue600,
                                    decoration: TextDecoration.underline,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
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

class _LogoSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const AconsiaBrandLogo(size: 96, imageSize: 62),
        const Gap(UiSpacing.lg),
        const Text(
          'ACONSIA',
          style: UiTypography.display,
        ),
      ],
    );
  }
}

class _DescriptionSection extends StatelessWidget {
  const _DescriptionSection();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Text(
          'Platform Edukasi Anestesi Digital',
          textAlign: TextAlign.center,
          style: UiTypography.h2,
        ),
        Gap(UiSpacing.xs),
        Text(
          'Menghubungkan dokter dan pasien untuk memahami prosedur anestesi dengan lebih baik sebelum operasi',
          textAlign: TextAlign.center,
          style: UiTypography.body,
        ),
      ],
    );
  }
}
