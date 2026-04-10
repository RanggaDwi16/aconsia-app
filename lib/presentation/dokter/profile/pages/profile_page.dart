import 'package:aconsia_app/presentation/dokter/profile/controllers/get_dokter_profile/fetch_dokter_profile_provider.dart';
import 'package:aconsia_app/core/ui/components/aconsia_surface.dart';
import 'package:aconsia_app/core/ui/tokens/ui_palette.dart';
import 'package:aconsia_app/core/ui/tokens/ui_spacing.dart';
import 'package:aconsia_app/core/ui/tokens/ui_typography.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:aconsia_app/core/helpers/widgets/buttons.dart';
import 'package:aconsia_app/core/routers/router_name.dart';
import 'package:aconsia_app/core/utils/assets.gen.dart';
import 'package:aconsia_app/core/utils/extensions/build_context_ext.dart';
import 'package:aconsia_app/presentation/dokter/profile/widgets/doctor_contact_widget.dart';
import 'package:aconsia_app/presentation/dokter/profile/widgets/doctor_personal_information_widget.dart';
import 'package:aconsia_app/presentation/dokter/profile/widgets/doctor_profesional_information_widget.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ProfilePage extends HookConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final spesialisasiController = useTextEditingController();
    final nomorstrController = useTextEditingController();
    final nomorsipController = useTextEditingController();
    final hospitalNameController = useTextEditingController();
    final tanggalGabungController = useTextEditingController();
    final namaController = useTextEditingController();
    final emailController = useTextEditingController();
    final nomorHpController = useTextEditingController();

    final uid = FirebaseAuth.instance.currentUser?.uid;
    final profileDokter = ref.watch(fetchDokterProfileProvider(uid: uid ?? ''));

    useEffect(() {
      profileDokter.whenData((dokterProfile) {
        if (dokterProfile != null) {
          spesialisasiController.text = dokterProfile.spesialisasi ?? '';
          nomorstrController.text = dokterProfile.nomorStr ?? '';
          nomorsipController.text = dokterProfile.nomorSip ?? '';
          hospitalNameController.text = dokterProfile.hospitalName ?? '';
          tanggalGabungController.text = dokterProfile.tanggalGabung ?? '';
          namaController.text = dokterProfile.namaLengkap ?? '';
          emailController.text = dokterProfile.email ?? '';
          nomorHpController.text = dokterProfile.nomorTelepon ?? '';
        }
      });

      return null;
    }, [profileDokter]);

    if (profileDokter.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: AconsiaPageBackground(
        colors: const [
          Color(0xFFF8FAFC),
          UiPalette.white,
        ],
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(fetchDokterProfileProvider);
            await Future.delayed(const Duration(milliseconds: 500));
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(UiSpacing.md),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Gap(UiSpacing.md),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Profil Dokter',
                      style: UiTypography.h1,
                    ),
                  ),
                  const Gap(UiSpacing.xs),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Kelola informasi profil dan kredensial profesional Anda',
                      style: UiTypography.body,
                    ),
                  ),
                  const Gap(UiSpacing.md),
                  AconsiaCardSurface(
                    padding: const EdgeInsets.all(UiSpacing.md),
                    borderColor: const Color(0xFFDCEAFF),
                    radius: 14,
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 44,
                          backgroundImage: profileDokter.value?.fotoProfilUrl !=
                                      null &&
                                  profileDokter.value!.fotoProfilUrl!.isNotEmpty
                              ? NetworkImage(
                                  profileDokter.value!.fotoProfilUrl!)
                              : AssetImage(Assets.images.placeholderImg.path)
                                  as ImageProvider,
                        ),
                        const Gap(UiSpacing.sm),
                        Text(
                          namaController.text.isEmpty
                              ? 'Dokter'
                              : namaController.text,
                          style: UiTypography.title.copyWith(
                            fontSize: 19,
                            fontWeight: FontWeight.w700,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const Gap(UiSpacing.xxs),
                        Text(
                          spesialisasiController.text.isEmpty
                              ? 'Anestesiologi'
                              : spesialisasiController.text,
                          style: UiTypography.caption,
                        ),
                        const Gap(UiSpacing.sm),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: UiPalette.emerald600,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'Status: ${profileDokter.value?.status?.isNotEmpty == true ? profileDokter.value!.status! : 'active'}',
                            style: UiTypography.caption.copyWith(
                              color: UiPalette.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Gap(UiSpacing.lg),
                  const AconsiaSectionTitle(
                    title: 'Informasi Profil',
                    subtitle: 'Data profesional, personal, dan kontak dokter',
                    titleSize: 20,
                  ),
                  const Gap(UiSpacing.md),
                  DoctorProfesionalInformationWidget(
                    spesialisasiController: spesialisasiController,
                    nomorstrController: nomorstrController,
                    nomorsipController: nomorsipController,
                    hospitalNameController: hospitalNameController,
                    tanggalGabungController: tanggalGabungController,
                  ),
                  const Gap(UiSpacing.md),
                  DoctorPersonalInformationWidget(
                    namaController: namaController,
                  ),
                  const Gap(UiSpacing.md),
                  DoctorContactWidget(
                    emailController: emailController,
                    nomorHpController: nomorHpController,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(UiSpacing.md),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Button.filled(
              onPressed: () => context.pushNamed(RouteName.editProfile),
              label: 'Edit Data Diri',
              color: UiPalette.emerald600,
              borderColor: UiPalette.emerald600,
              borderRadius: 12,
              height: 52,
            ),
            const Gap(UiSpacing.sm),
            Button.outlined(
              onPressed: () => context.showLogoutDialog(),
              label: 'Keluar',
              borderColor: UiPalette.red600,
              textColor: UiPalette.red600,
            ),
          ],
        ),
      ),
    );
  }
}
