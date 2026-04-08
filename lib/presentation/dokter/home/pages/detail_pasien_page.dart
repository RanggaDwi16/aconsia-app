import 'package:aconsia_app/core/helpers/widgets/buttons.dart';
import 'package:aconsia_app/core/routers/router_name.dart';
import 'package:aconsia_app/core/ui/components/aconsia_screen_shell.dart';
import 'package:aconsia_app/core/ui/components/aconsia_surface.dart';
import 'package:aconsia_app/core/ui/tokens/ui_palette.dart';
import 'package:aconsia_app/core/ui/tokens/ui_spacing.dart';
import 'package:aconsia_app/core/ui/tokens/ui_typography.dart';
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
    final agamaController = useTextEditingController();
    final statusPernikahanController = useTextEditingController();
    final pendidikanTerakhirController = useTextEditingController();
    final pekerjaanController = useTextEditingController();
    final emailController = useTextEditingController();
    final phoneController = useTextEditingController();
    final alamatLengkapController = useTextEditingController();
    final rtController = useTextEditingController();
    final rwController = useTextEditingController();
    final kelurahanDesaController = useTextEditingController();
    final kecamatanController = useTextEditingController();
    final kotaKabupatenController = useTextEditingController();
    final provinsiController = useTextEditingController();
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
            ? DateFormat('d/M/yyyy')
                .format(profilePasien.tanggalLahir!.toDate())
            : '';
        jenisKelaminController.text = profilePasien.jenisKelamin ?? '';
        agamaController.text = profilePasien.agama ?? '';
        statusPernikahanController.text = profilePasien.statusPernikahan ?? '';
        pendidikanTerakhirController.text =
            profilePasien.pendidikanTerakhir ?? '';
        pekerjaanController.text = profilePasien.pekerjaan ?? '';
        emailController.text = profilePasien.email ?? '';
        phoneController.text = profilePasien.nomorTelepon ?? '';
        alamatLengkapController.text = profilePasien.alamatLengkap ?? '';
        rtController.text = profilePasien.rt ?? '';
        rwController.text = profilePasien.rw ?? '';
        kelurahanDesaController.text = profilePasien.kelurahanDesa ?? '';
        kecamatanController.text = profilePasien.kecamatan ?? '';
        kotaKabupatenController.text = profilePasien.kotaKabupaten ?? '';
        provinsiController.text = profilePasien.provinsi ?? '';
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
      }
      return null;
    }, [pasienProfileAsync.value]);

    return Scaffold(
      body: AconsiaPageBackground(
        colors: const [Color(0xFFF8FAFC), UiPalette.white],
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(fetchPasienProfileProvider);
            await Future.delayed(const Duration(milliseconds: 400));
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(UiSpacing.md),
            child: pasienProfileAsync.when(
              data: (profile) => Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    AconsiaTopActionRow(
                      title: 'Detail & Review Pasien',
                      subtitle: 'Lihat data lengkap dan status kesiapan pasien',
                      onBack: () => context.pop(),
                    ),
                    const Gap(UiSpacing.md),
                    if (profile != null) ...[
                      _buildReviewStatusBanner(profile),
                      const Gap(UiSpacing.sm),
                    ],
                    AconsiaCardSurface(
                      radius: 14,
                      borderColor: const Color(0xFFDCEAFF),
                      padding: const EdgeInsets.all(UiSpacing.md),
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
                              style: UiTypography.h2.copyWith(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: UiPalette.blue600,
                              ),
                            ),
                          ),
                          const Gap(UiSpacing.sm),
                          Text(
                            namaController.text.isEmpty
                                ? 'Pasien'
                                : namaController.text,
                            style: UiTypography.title.copyWith(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const Gap(UiSpacing.xxs),
                          Text(
                            noRekamMedisController.text.isEmpty
                                ? 'No. rekam medis belum tersedia'
                                : 'No RM: ${noRekamMedisController.text}',
                            style: UiTypography.caption,
                          ),
                          const Gap(UiSpacing.sm),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: UiPalette.blue600,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'Role: Pasien',
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
                    PasienChooseDokterWidget(
                        dokterController: dokterController),
                    const Gap(UiSpacing.md),
                    PasienPersonalInformationWidget(
                      namaController: namaController,
                      noRekamMedisController: noRekamMedisController,
                      nikController: nikController,
                      tanggalLahirController: tanggalLahirController,
                      jenisKelaminController: jenisKelaminController,
                      agamaController: agamaController,
                      statusPernikahanController: statusPernikahanController,
                      pendidikanTerakhirController:
                          pendidikanTerakhirController,
                      pekerjaanController: pekerjaanController,
                    ),
                    const Gap(UiSpacing.md),
                    PasienContactWidget(
                      emailController: emailController,
                      phoneController: phoneController,
                      alamatLengkapController: alamatLengkapController,
                      rtController: rtController,
                      rwController: rwController,
                      kelurahanDesaController: kelurahanDesaController,
                      kecamatanController: kecamatanController,
                      kotaKabupatenController: kotaKabupatenController,
                      provinsiController: provinsiController,
                    ),
                    const Gap(UiSpacing.md),
                    PasienMedicInformationWidget(
                      jenisOperasiController: jenisOperasiController,
                      jenisAnestesiController: jenisAnestesiController,
                      klasifikasiasaController: klasifikasiasaController,
                      tinggiBadanController: tinggiBadanController,
                      beratBadanController: beratBadanController,
                      isDokterInput: true,
                    ),
                    const Gap(UiSpacing.md),
                    PasienWaliInformationWidget(
                      namaController: namaWaliController,
                      hubunganController: hubunganController,
                      nomorHpController: nomorHpController,
                      alamatController: alamatController,
                    ),
                    const Gap(UiSpacing.sm),
                    if (profile == null)
                      const Text(
                        'Profil pasien belum ditemukan.',
                        style: TextStyle(color: UiPalette.red600),
                      ),
                  ],
                ),
              ),
              loading: () => const Center(
                child: Padding(
                  padding: EdgeInsets.only(top: UiSpacing.xxxl),
                  child: CircularProgressIndicator(),
                ),
              ),
              error: (error, _) => Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: UiSpacing.xxxl),
                  child: Text('Gagal memuat detail pasien: $error'),
                ),
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(UiSpacing.md),
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
                  ? 'Perbarui Data Medis'
                  : 'Review Informasi Medis Pasien',
              height: 52,
              borderRadius: 12,
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
    final iconColor =
        isReady ? const Color(0xFF22C35D) : const Color(0xFFF59E0B);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(UiSpacing.sm),
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
          const Gap(UiSpacing.sm),
          Expanded(
            child: Text(
              text,
              style: UiTypography.caption.copyWith(
                color: const Color(0xFF2A415C),
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
