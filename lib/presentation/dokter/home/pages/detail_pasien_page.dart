import 'package:aconsia_app/core/helpers/custom_app_bar.dart';
import 'package:aconsia_app/presentation/pasien/profile/controllers/get_pasien_profile/fetch_pasien_profile_provider.dart';
import 'package:aconsia_app/presentation/pasien/profile/widgets/pasien_choose_dokter_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aconsia_app/core/helpers/widgets/buttons.dart';
import 'package:aconsia_app/core/routers/router_name.dart';
import 'package:aconsia_app/core/utils/constant/app_colors.dart';
import 'package:aconsia_app/core/utils/extensions/build_context_ext.dart';
import 'package:aconsia_app/presentation/pasien/profile/widgets/pasien_contact_widget.dart';
import 'package:aconsia_app/presentation/pasien/profile/widgets/pasien_medic_information_widget.dart';
import 'package:aconsia_app/presentation/pasien/profile/widgets/pasien_personal_information_widget.dart';
import 'package:aconsia_app/presentation/pasien/profile/widgets/pasien_wali_information_widget.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

class DetailPasienPage extends HookConsumerWidget {
  final String? pasienId;
  const DetailPasienPage({super.key, this.pasienId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dokterController = useTextEditingController();
    final namaController = useTextEditingController();
    final noRekamMedisController = useTextEditingController();
    final nikController = useTextEditingController();
    final tanggalLahirController = useTextEditingController();
    final jenisKelaminController = useTextEditingController();
    final emailController = useTextEditingController();
    final phoneController = useTextEditingController();
    final jenisOperasiController = useTextEditingController();
    final jenisAnestesiController = useTextEditingController();
    final klasifikasiasaController = useTextEditingController();
    final tinggiBadanController = useTextEditingController();
    final beratBadanController = useTextEditingController();
    final namaWaliController = useTextEditingController();
    final hubunganController = useTextEditingController();
    final nomorHpController = useTextEditingController();
    final alamatController = useTextEditingController();

    final profilePasien =
        ref.watch(fetchPasienProfileProvider(pasienId: pasienId ?? '')).value;

    useEffect(() {
      if (profilePasien != null) {
        dokterController.text = profilePasien.dokterId ?? '';
        namaController.text = profilePasien.namaLengkap ?? '';
        noRekamMedisController.text = profilePasien.noRekamMedis ?? '';
        nikController.text = profilePasien.nik ?? '';
        tanggalLahirController.text = tanggalLahirController.text =
            profilePasien.tanggalLahir != null
                ? DateFormat('d/M/yyyy')
                    .format(profilePasien.tanggalLahir!.toDate())
                : '';
        jenisKelaminController.text = profilePasien.jenisKelamin ?? '';
        emailController.text = profilePasien.email ?? '';
        phoneController.text = profilePasien.nomorTelepon ?? '';
        jenisOperasiController.text = profilePasien.jenisOperasi ?? '';
        jenisAnestesiController.text = profilePasien.jenisAnestesi ?? '';
        klasifikasiasaController.text = profilePasien.klasifikasiAsa ?? '';
        tinggiBadanController.text =
            profilePasien.tinggiBadan?.toString() ?? '';
        beratBadanController.text = profilePasien.beratBadan?.toString() ?? '';
        namaWaliController.text = profilePasien.namaWali ?? '';
        hubunganController.text = profilePasien.hubunganWali ?? '';
        nomorHpController.text = profilePasien.nomorHpWali ?? '';
        alamatController.text = profilePasien.alamatWali ?? '';

        print('Dokter ID: ${dokterController.text}');
      }
      return null;
    }, [profilePasien]);
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Gap(context.deviceHeight * 0.1),
              Text(
                namaController.text,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Gap(8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColor.primaryColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Pasien',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColor.primaryWhite,
                  ),
                ),
              ),
              Gap(24),
              PasienChooseDokterWidget(dokterController: dokterController),
              Gap(16),
              PasienPersonalInformationWidget(
                namaController: namaController,
                noRekamMedisController: noRekamMedisController,
                nikController: nikController,
                tanggalLahirController: tanggalLahirController,
                jenisKelaminController: jenisKelaminController,
              ),
              Gap(16),
              PasienContactWidget(
                  emailController: emailController,
                  phoneController: phoneController),
              Gap(16),
              PasienMedicInformationWidget(
                jenisOperasiController: jenisOperasiController,
                jenisAnestesiController: jenisAnestesiController,
                klasifikasiasaController: klasifikasiasaController,
                tinggiBadanController: tinggiBadanController,
                beratBadanController: beratBadanController,
                isDokterInput: true,
              ),
              Gap(16),
              PasienWaliInformationWidget(
                namaController: namaWaliController,
                hubunganController: hubunganController,
                nomorHpController: nomorHpController,
                alamatController: alamatController,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Button.filled(
              onPressed: () => context.pushNamed(
                  RouteName.addPasienMedicInformation,
                  extra: pasienId),
              label: 'Isi Informasi Medis Pasien',
            ),
          ],
        ),
      ),
    );
  }
}
