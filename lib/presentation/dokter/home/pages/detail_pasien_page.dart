import 'package:aconsia_app/core/helpers/widgets/buttons.dart';
import 'package:aconsia_app/core/main/data/models/pasien_profile_model.dart';
import 'package:aconsia_app/core/routers/router_name.dart';
import 'package:aconsia_app/core/ui/components/aconsia_screen_shell.dart';
import 'package:aconsia_app/core/ui/components/aconsia_surface.dart';
import 'package:aconsia_app/core/ui/tokens/ui_palette.dart';
import 'package:aconsia_app/core/ui/tokens/ui_spacing.dart';
import 'package:aconsia_app/core/ui/tokens/ui_typography.dart';
import 'package:aconsia_app/presentation/pasien/profile/controllers/get_pasien_profile/fetch_pasien_profile_provider.dart';
import 'package:aconsia_app/presentation/pasien/profile/domain/entities/pasien_profile_failure.dart';
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
  const DetailPasienPage({super.key, this.pasienId});

  final String? pasienId;

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

    final safePasienId = (pasienId ?? '').trim();
    final hasValidPasienId = safePasienId.isNotEmpty;
    final pasienProfileAsync = hasValidPasienId
        ? ref.watch(fetchPasienProfileProvider(pasienId: safePasienId))
        : const AsyncValue<PasienProfileModel?>.data(null);

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

    final parsedFailure = pasienProfileAsync.hasError
        ? PasienProfileFailure.fromRaw(
            pasienProfileAsync.error ?? 'unknown_error',
          )
        : null;
    final profile = pasienProfileAsync.value;

    return Scaffold(
      body: AconsiaPageBackground(
        colors: const [Color(0xFFF8FAFC), UiPalette.white],
        child: RefreshIndicator(
          onRefresh: () async {
            if (hasValidPasienId) {
              ref.invalidate(
                  fetchPasienProfileProvider(pasienId: safePasienId));
            }
            await Future.delayed(const Duration(milliseconds: 400));
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(UiSpacing.md),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AconsiaTopActionRow(
                    title: 'Detail & Review Pasien',
                    subtitle: 'Lihat data lengkap dan status kesiapan pasien',
                    onBack: () => context.pop(),
                  ),
                  const Gap(UiSpacing.md),
                  if (!hasValidPasienId) ...[
                    _buildStateBanner(
                      icon: Icons.link_off_rounded,
                      title: 'Konteks pasien tidak valid',
                      message:
                          'ID pasien tidak ditemukan dari halaman sebelumnya. Silakan kembali ke daftar pasien dan pilih ulang.',
                      color: UiPalette.red600,
                      backgroundColor: const Color(0xFFFEF2F2),
                      borderColor: const Color(0xFFFECACA),
                    ),
                    const Gap(UiSpacing.sm),
                  ],
                  if (pasienProfileAsync.isLoading && hasValidPasienId)
                    const Padding(
                      padding: EdgeInsets.only(top: UiSpacing.xxxl),
                      child: CircularProgressIndicator(),
                    )
                  else if (parsedFailure != null) ...[
                    _buildStateBanner(
                      icon: parsedFailure.isPermissionDenied
                          ? Icons.lock_outline_rounded
                          : Icons.error_outline_rounded,
                      title: parsedFailure.isPermissionDenied
                          ? 'Akses ditolak'
                          : 'Gagal memuat detail pasien',
                      message: parsedFailure.message,
                      color: parsedFailure.isPermissionDenied
                          ? const Color(0xFF92400E)
                          : UiPalette.red600,
                      backgroundColor: parsedFailure.isPermissionDenied
                          ? const Color(0xFFFFF7ED)
                          : const Color(0xFFFEF2F2),
                      borderColor: parsedFailure.isPermissionDenied
                          ? const Color(0xFFFED7AA)
                          : const Color(0xFFFECACA),
                    ),
                    const Gap(UiSpacing.sm),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => context.pop(),
                            child: const Text('Kembali'),
                          ),
                        ),
                        const Gap(UiSpacing.sm),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: hasValidPasienId
                                ? () => ref.invalidate(
                                      fetchPasienProfileProvider(
                                        pasienId: safePasienId,
                                      ),
                                    )
                                : null,
                            child: const Text('Coba Lagi'),
                          ),
                        ),
                      ],
                    ),
                  ] else if (profile == null) ...[
                    _buildStateBanner(
                      icon: Icons.person_off_outlined,
                      title: 'Profil pasien tidak ditemukan',
                      message:
                          'Data pasien belum tersedia atau sudah dipindahkan. Silakan kembali dan pilih pasien lain.',
                      color: const Color(0xFF92400E),
                      backgroundColor: const Color(0xFFFFF7ED),
                      borderColor: const Color(0xFFFED7AA),
                    ),
                  ] else ...[
                    _buildReviewStatusBanner(profile),
                    const Gap(UiSpacing.sm),
                    _buildPatientIdentityCard(
                      namaController: namaController,
                      noRekamMedisController: noRekamMedisController,
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
                    _buildPreOperativeAssessmentSection(profile),
                    const Gap(UiSpacing.md),
                    PasienWaliInformationWidget(
                      namaController: namaWaliController,
                      hubunganController: hubunganController,
                      nomorHpController: nomorHpController,
                      alamatController: alamatController,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomActions(
        context: context,
        profile: profile,
        safePasienId: safePasienId,
        hasError: parsedFailure != null || !hasValidPasienId,
      ),
    );
  }

  Widget _buildBottomActions({
    required BuildContext context,
    required PasienProfileModel? profile,
    required String safePasienId,
    required bool hasError,
  }) {
    final isReady = profile != null && _isMedicalReady(profile);
    final pasienUid = (profile?.uid ?? safePasienId).trim();
    final pasienDisplayName = (profile?.namaLengkap ?? 'Pasien').trim();
    final actionsEnabled = !hasError && pasienUid.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.all(UiSpacing.md),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: actionsEnabled
                  ? () => context.pushNamed(
                        RouteName.chatRoom,
                        extra: {
                          'role': 'dokter',
                          'pasienId': pasienUid,
                          'title': pasienDisplayName.isEmpty
                              ? 'Pasien'
                              : pasienDisplayName,
                        },
                      )
                  : null,
              icon: const Icon(Icons.chat_bubble_outline_rounded),
              label: const Text('Chat dengan Pasien'),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(52),
                side: const BorderSide(color: UiPalette.blue100),
                foregroundColor: UiPalette.blue600,
              ),
            ),
          ),
          const Gap(UiSpacing.sm),
          Expanded(
            child: Button.filled(
              onPressed: () => context.pushNamed(
                RouteName.addPasienMedicInformation,
                extra: pasienUid,
              ),
              label: isReady ? 'Perbarui Data Medis' : 'Review Data Medis',
              height: 52,
              borderRadius: 12,
              disabled: !actionsEnabled,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPatientIdentityCard({
    required TextEditingController namaController,
    required TextEditingController noRekamMedisController,
  }) {
    final fallbackName = namaController.text.trim().isEmpty
        ? 'Pasien'
        : namaController.text.trim();
    final firstLetter = fallbackName.substring(0, 1).toUpperCase();
    final rmValue = noRekamMedisController.text.trim();

    return AconsiaCardSurface(
      radius: 14,
      borderColor: const Color(0xFFDCEAFF),
      padding: const EdgeInsets.all(UiSpacing.md),
      child: Column(
        children: [
          CircleAvatar(
            radius: 34,
            backgroundColor: const Color(0xFFEAF2FF),
            child: Text(
              firstLetter,
              style: UiTypography.h2.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: UiPalette.blue600,
              ),
            ),
          ),
          const Gap(UiSpacing.sm),
          Text(
            fallbackName,
            style: UiTypography.title.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
          const Gap(UiSpacing.xxs),
          Text(
            rmValue.isEmpty
                ? 'No. rekam medis belum tersedia'
                : 'No RM: $rmValue',
            style: UiTypography.caption,
          ),
          const Gap(UiSpacing.sm),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
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
    );
  }

  Widget _buildStateBanner({
    required IconData icon,
    required String title,
    required String message,
    required Color color,
    required Color backgroundColor,
    required Color borderColor,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(UiSpacing.sm),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color),
          const Gap(UiSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: UiTypography.label.copyWith(
                    color: color,
                    fontSize: 15,
                  ),
                ),
                const Gap(2),
                Text(
                  message,
                  style: UiTypography.caption.copyWith(
                    color: const Color(0xFF2A415C),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewStatusBanner(PasienProfileModel profile) {
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

  bool _isMedicalReady(PasienProfileModel profile) {
    final operasi = (profile.jenisOperasi ?? '').trim();
    final anestesi = (profile.jenisAnestesi ?? '').trim();
    final asa = (profile.klasifikasiAsa ?? '').trim();
    return operasi.isNotEmpty && anestesi.isNotEmpty && asa.isNotEmpty;
  }

  Widget _buildPreOperativeAssessmentSection(PasienProfileModel profile) {
    final assessment = _normalizeAssessment(profile.preOperativeAssessment);
    final assessmentData = _normalizeAssessmentData(assessment['data']);
    final assessmentDone = profile.assessmentCompleted;
    final updatedAt = profile.preOperativeAssessmentUpdatedAt;
    final updatedAtText = updatedAt == null
        ? '-'
        : DateFormat('dd/MM/yyyy HH:mm').format(updatedAt.toDate());

    final hasAnesthesiaHistory =
        (assessmentData['hasAnesthesiaHistory'] ?? '-').toString();
    final hasDrugAllergy = (assessmentData['hasDrugAllergy'] ?? '-').toString();
    final allergyDetails = (assessmentData['allergyDetails'] ?? '-').toString();
    final takingMedication =
        (assessmentData['takingMedication'] ?? '-').toString();
    final smokingStatus = (assessmentData['smokingStatus'] ?? '-').toString();
    final alcoholStatus = (assessmentData['alcoholStatus'] ?? '-').toString();
    final diseases = <String>[
      if (assessmentData['hasDiabetes'] == true) 'Diabetes',
      if (assessmentData['hasHypertension'] == true) 'Hipertensi',
      if (assessmentData['hasAsthma'] == true) 'Asma',
      if (assessmentData['hasHeartDisease'] == true) 'Penyakit Jantung',
      if (assessmentData['hasStroke'] == true) 'Stroke',
      if (assessmentData['hasKidneyDisease'] == true) 'Penyakit Ginjal',
      if (assessmentData['hasLiverDisease'] == true) 'Penyakit Hati',
      if (assessmentData['hasEpilepsy'] == true) 'Epilepsi',
    ];
    final diseaseText = diseases.isEmpty ? 'Tidak ada' : diseases.join(', ');
    final asaSnapshot = (assessment['asaStatusSnapshot'] ?? '-').toString();

    return AconsiaCardSurface(
      radius: 14,
      borderColor: const Color(0xFFDCEAFF),
      padding: const EdgeInsets.all(UiSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                assessmentDone
                    ? Icons.check_circle_outline_rounded
                    : Icons.hourglass_empty_rounded,
                color: assessmentDone
                    ? const Color(0xFF16A34A)
                    : const Color(0xFFF59E0B),
              ),
              const Gap(UiSpacing.xs),
              Text(
                'Asesmen Pra-Operasi',
                style: UiTypography.label.copyWith(fontSize: 18),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: UiSpacing.xs,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: assessmentDone
                      ? const Color(0xFFECFDF3)
                      : const Color(0xFFFFF6E8),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                    color: assessmentDone
                        ? const Color(0xFF86EFAC)
                        : const Color(0xFFFED7AA),
                  ),
                ),
                child: Text(
                  assessmentDone ? 'Selesai' : 'Belum Submit',
                  style: UiTypography.caption.copyWith(
                    color: assessmentDone
                        ? const Color(0xFF166534)
                        : const Color(0xFF9A3412),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const Gap(UiSpacing.sm),
          Text(
            'Update terakhir: $updatedAtText',
            style: UiTypography.caption.copyWith(color: UiPalette.slate600),
          ),
          const Gap(UiSpacing.sm),
          if (!assessmentDone)
            Text(
              'Pasien belum menyelesaikan asesmen pra-operasi.',
              style: UiTypography.bodySmall.copyWith(color: UiPalette.slate600),
            )
          else ...[
            _assessmentSummaryRow('Riwayat Anestesi', hasAnesthesiaHistory),
            _assessmentSummaryRow(
              'Alergi Obat',
              hasDrugAllergy == 'Ada'
                  ? 'Ada ($allergyDetails)'
                  : hasDrugAllergy,
            ),
            _assessmentSummaryRow('Obat Rutin', takingMedication),
            _assessmentSummaryRow('Merokok', smokingStatus),
            _assessmentSummaryRow('Alkohol', alcoholStatus),
            _assessmentSummaryRow('Komorbid', diseaseText),
            _assessmentSummaryRow('ASA Snapshot', asaSnapshot),
            const Gap(UiSpacing.sm),
            ExpansionTile(
              tilePadding: EdgeInsets.zero,
              childrenPadding: EdgeInsets.zero,
              title: Text(
                'Lihat Detail Jawaban',
                style: UiTypography.bodySmall.copyWith(
                  color: UiPalette.blue600,
                  fontWeight: FontWeight.w700,
                ),
              ),
              children: [
                const Gap(UiSpacing.xs),
                _assessmentSummaryRow(
                  'Masalah Anestesi',
                  (assessmentData['anesthesiaComplications'] ?? '-').toString(),
                ),
                _assessmentSummaryRow(
                  'Reaksi Alergi',
                  (assessmentData['allergyReaction'] ?? '-').toString(),
                ),
                _assessmentSummaryRow(
                  'Cigarettes/Day',
                  (assessmentData['cigarettesPerDay'] ?? '-').toString(),
                ),
                _assessmentSummaryRow(
                  'Penyakit Lain',
                  (assessmentData['otherDiseases'] ?? '-').toString(),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Map<String, dynamic> _normalizeAssessment(Map<String, dynamic>? raw) {
    if (raw == null) return <String, dynamic>{};
    return raw;
  }

  Map<String, dynamic> _normalizeAssessmentData(dynamic raw) {
    if (raw is Map<String, dynamic>) return raw;
    if (raw is Map) return raw.cast<String, dynamic>();
    return <String, dynamic>{};
  }

  Widget _assessmentSummaryRow(String label, String value) {
    final display = value.trim().isEmpty ? '-' : value.trim();
    return Padding(
      padding: const EdgeInsets.only(bottom: UiSpacing.xs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(
              '$label:',
              style: UiTypography.caption.copyWith(
                color: UiPalette.slate500,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              display,
              style: UiTypography.caption.copyWith(
                color: UiPalette.slate800,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
