import 'package:aconsia_app/core/helpers/custom_app_bar.dart';
import 'package:aconsia_app/core/helpers/widgets/buttons.dart';
import 'package:aconsia_app/core/routers/router_name.dart';
import 'package:aconsia_app/core/utils/constant/app_colors.dart';
import 'package:aconsia_app/presentation/pasien/profile/controllers/get_pasien_profile/fetch_pasien_profile_provider.dart';
import 'package:aconsia_app/presentation/pasien/profile/widgets/pasien_choose_dokter_widget.dart';
import 'package:aconsia_app/presentation/pasien/profile/widgets/pasien_contact_widget.dart';
import 'package:aconsia_app/presentation/pasien/profile/widgets/pasien_medic_information_widget.dart';
import 'package:aconsia_app/presentation/pasien/profile/widgets/pasien_personal_information_widget.dart';
import 'package:aconsia_app/presentation/pasien/profile/widgets/pasien_wali_information_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
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

    final pasienProfileAsync =
        ref.watch(fetchPasienProfileProvider(pasienId: pasienId ?? ''));

    useEffect(() {
      final profilePasien = pasienProfileAsync.value;
      if (profilePasien != null) {
        dokterController.text = profilePasien.dokterId ?? '';
        namaController.text = profilePasien.namaLengkap ?? '';
        noRekamMedisController.text = profilePasien.noRekamMedis ?? '';
        nikController.text = profilePasien.nik ?? '';
        tanggalLahirController.text = profilePasien.tanggalLahir != null
            ? DateFormat('d/M/yyyy').format(profilePasien.tanggalLahir!.toDate())
            : '';
        jenisKelaminController.text = profilePasien.jenisKelamin ?? '';
        emailController.text = profilePasien.email ?? '';
        phoneController.text = profilePasien.nomorTelepon ?? '';
        jenisOperasiController.text = profilePasien.jenisOperasi ?? '';
        jenisAnestesiController.text = profilePasien.jenisAnestesi ?? '';
        klasifikasiasaController.text = profilePasien.klasifikasiAsa ?? '';
        tinggiBadanController.text = profilePasien.tinggiBadan?.toString() ?? '';
        beratBadanController.text = profilePasien.beratBadan?.toString() ?? '';
        namaWaliController.text = profilePasien.namaWali ?? '';
        hubunganController.text = profilePasien.hubunganWali ?? '';
        nomorHpController.text = profilePasien.nomorHpWali ?? '';
        alamatController.text = profilePasien.alamatWali ?? '';
      }
      return null;
    }, [pasienProfileAsync.value]);

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Detail Pasien',
        centertitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFF4FAFF),
              Color(0xFFFFFFFF),
            ],
          ),
        ),
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(fetchPasienProfileProvider);
            await Future.delayed(const Duration(milliseconds: 400));
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: pasienProfileAsync.when(
            data: (profile) => Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (profile != null) ...[
                      _buildReviewStatusBanner(profile),
                      const Gap(12),
                    ],
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFFDCEAFF)),
                      ),
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 34,
                            backgroundColor: const Color(0xFFEAF2FF),
                            child: Text(
                              (namaController.text.isNotEmpty
                                      ? namaController.text
                                      : 'Pasien')
                                  .substring(0, 1)
                                  .toUpperCase(),
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppColor.primaryColor,
                              ),
                            ),
                          ),
                          const Gap(10),
                          Text(
                            namaController.text.isEmpty
                                ? 'Pasien'
                                : namaController.text,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const Gap(4),
                          Text(
                            noRekamMedisController.text.isEmpty
                                ? 'No. rekam medis belum tersedia'
                                : 'No RM: ${noRekamMedisController.text}',
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
                              color: AppColor.primaryColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              'Role: Pasien',
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
                    PasienChooseDokterWidget(dokterController: dokterController),
                    const Gap(16),
                    PasienPersonalInformationWidget(
                      namaController: namaController,
                      noRekamMedisController: noRekamMedisController,
                      nikController: nikController,
                      tanggalLahirController: tanggalLahirController,
                      jenisKelaminController: jenisKelaminController,
                    ),
                    const Gap(16),
                    PasienContactWidget(
                      emailController: emailController,
                      phoneController: phoneController,
                    ),
                    const Gap(16),
                    PasienMedicInformationWidget(
                      jenisOperasiController: jenisOperasiController,
                      jenisAnestesiController: jenisAnestesiController,
                      klasifikasiasaController: klasifikasiasaController,
                      tinggiBadanController: tinggiBadanController,
                      beratBadanController: beratBadanController,
                      isDokterInput: true,
                    ),
                    const Gap(16),
                    PasienWaliInformationWidget(
                      namaController: namaWaliController,
                      hubunganController: hubunganController,
                      nomorHpController: nomorHpController,
                      alamatController: alamatController,
                    ),
                    const Gap(8),
                    if (profile == null)
                      const Text(
                        'Profil pasien belum ditemukan.',
                        style: TextStyle(color: AppColor.primaryRed),
                      ),
                  ],
                ),
              ),
              loading: () => const Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 48),
                  child: CircularProgressIndicator(),
                ),
              ),
              error: (error, _) => Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: Text('Gagal memuat detail pasien: $error'),
                ),
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Builder(
          builder: (_) {
            final profile = pasienProfileAsync.value;
            final isReady = profile != null && _isMedicalReady(profile);
            return Button.filled(
              onPressed: () => context.pushNamed(
                RouteName.addPasienMedicInformation,
                extra: pasienId,
              ),
              label: isReady
                  ? 'Perbarui Informasi Medis'
                  : 'Lengkapi Informasi Medis Pasien',
            );
          },
        ),
      ),
    );
  }

  Widget _buildReviewStatusBanner(profile) {
    final isReady = _isMedicalReady(profile);
    final text = isReady
        ? 'Status: Siap Edukasi. Data medis inti sudah lengkap.'
        : 'Status: Menunggu Review. Lengkapi jenis operasi, anestesi, dan klasifikasi ASA.';
    final bgColor = isReady ? const Color(0xFFEAF9EF) : const Color(0xFFFFF6E8);
    final borderColor =
        isReady ? const Color(0xFFCDEFD8) : const Color(0xFFFFE3B3);
    final iconColor = isReady ? const Color(0xFF22C35D) : const Color(0xFFF59E0B);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          Icon(
            isReady ? Icons.check_circle_outline : Icons.hourglass_top_rounded,
            color: iconColor,
          ),
          const Gap(8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF2A415C),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _isMedicalReady(profile) {
    final operasi = (profile.jenisOperasi ?? '').trim();
    final anestesi = (profile.jenisAnestesi ?? '').trim();
    final asa = (profile.klasifikasiAsa ?? '').trim();
    return operasi.isNotEmpty && anestesi.isNotEmpty && asa.isNotEmpty;
  }
}
