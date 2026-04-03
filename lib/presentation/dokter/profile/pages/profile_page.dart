import 'package:aconsia_app/presentation/dokter/profile/controllers/get_dokter_profile/fetch_dokter_profile_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:aconsia_app/core/helpers/widgets/buttons.dart';
import 'package:aconsia_app/core/routers/router_name.dart';
import 'package:aconsia_app/core/utils/assets.gen.dart';
import 'package:aconsia_app/core/utils/constant/app_colors.dart';
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
    final tanggalGabungController = useTextEditingController();
    final namaController = useTextEditingController();
    final tempatLahirController = useTextEditingController();
    final tanggalLahirController = useTextEditingController();
    final jenisKelaminController = useTextEditingController();
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
          tanggalGabungController.text = dokterProfile.tanggalGabung ?? '';
          namaController.text = dokterProfile.namaLengkap ?? '';
          tempatLahirController.text = dokterProfile.tempatLahir ?? '';
          tanggalLahirController.text = dokterProfile.tanggalLahir ?? '';
          jenisKelaminController.text = dokterProfile.jenisKelamin ?? '';
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
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFEFFAF3),
              Color(0xFFFFFFFF),
            ],
          ),
        ),
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(fetchDokterProfileProvider);
            await Future.delayed(const Duration(milliseconds: 500));
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Gap(16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFD8EFDF)),
                    ),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 44,
                          backgroundImage:
                              profileDokter.value?.fotoProfilUrl != null &&
                                      profileDokter.value!.fotoProfilUrl!.isNotEmpty
                                  ? NetworkImage(profileDokter.value!.fotoProfilUrl!)
                                  : AssetImage(Assets.images.placeholderImg.path)
                                      as ImageProvider,
                        ),
                        const Gap(10),
                        Text(
                          namaController.text.isEmpty
                              ? 'Dokter'
                              : namaController.text,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const Gap(4),
                        Text(
                          spesialisasiController.text.isEmpty
                              ? 'Anestesiologi'
                              : spesialisasiController.text,
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColor.textGrayColor,
                          ),
                        ),
                        const Gap(8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColor.backgroundStatusAktifColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'Status: Aktif',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColor.primaryWhite,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Gap(20),
                  DoctorProfesionalInformationWidget(
                    spesialisasiController: spesialisasiController,
                    nomorstrController: nomorstrController,
                    nomorsipController: nomorsipController,
                    tanggalGabungController: tanggalGabungController,
                  ),
                  const Gap(16),
                  DoctorPersonalInformationWidget(
                    namaController: namaController,
                    tempatLahirController: tempatLahirController,
                    tanggalLahirController: tanggalLahirController,
                    jenisKelaminController: jenisKelaminController,
                  ),
                  const Gap(16),
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Button.filled(
              onPressed: () => context.pushNamed(RouteName.editProfile),
              label: 'Edit Data Diri',
            ),
            Gap(12),
            Button.outlined(
              onPressed: () => context.showLogoutDialog(ref),
              label: 'Keluar',
              borderColor: AppColor.primaryRed,
              textColor: AppColor.primaryRed,
            ),
          ],
        ),
      ),
    );
  }
}
