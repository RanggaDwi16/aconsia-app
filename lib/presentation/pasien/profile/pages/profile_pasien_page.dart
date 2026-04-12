import 'package:aconsia_app/core/helpers/widgets/buttons.dart';
import 'package:aconsia_app/core/routers/router_name.dart';
import 'package:aconsia_app/core/ui/components/aconsia_screen_shell.dart';
import 'package:aconsia_app/core/ui/components/aconsia_surface.dart';
import 'package:aconsia_app/core/ui/tokens/ui_palette.dart';
import 'package:aconsia_app/core/ui/tokens/ui_spacing.dart';
import 'package:aconsia_app/core/ui/tokens/ui_typography.dart';
import 'package:aconsia_app/presentation/pasien/home/controllers/pasien_learning_summary_provider.dart';
import 'package:aconsia_app/presentation/pasien/main/controllers/selected_index_provider.dart';
import 'package:aconsia_app/presentation/pasien/main/widgets/pasien_main_shell_scope.dart';
import 'package:aconsia_app/presentation/pasien/profile/controllers/get_pasien_profile/fetch_pasien_profile_provider.dart';
import 'package:aconsia_app/presentation/pasien/profile/widgets/pasien_choose_dokter_widget.dart';
import 'package:aconsia_app/presentation/pasien/profile/widgets/pasien_contact_widget.dart';
import 'package:aconsia_app/presentation/pasien/profile/widgets/pasien_medic_information_widget.dart';
import 'package:aconsia_app/presentation/pasien/profile/widgets/pasien_personal_information_widget.dart';
import 'package:aconsia_app/presentation/pasien/profile/widgets/pasien_wali_information_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

class ProfilePasienPage extends HookConsumerWidget {
  const ProfilePasienPage({super.key});

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

    final uid = FirebaseAuth.instance.currentUser?.uid ?? '';
    final selectedTab = useState(_ProfileTab.info);

    final profilePasien =
        ref.watch(fetchPasienProfileProvider(pasienId: uid)).value;
    final dokterId = profilePasien?.dokterId ?? '';
    final preOperativeMap =
        profilePasien?.preOperativeAssessment ?? const <String, dynamic>{};
    final scheduledDateRaw = preOperativeMap['scheduledSignatureDate'];
    final scheduledTimeRaw = preOperativeMap['scheduledSignatureTime'];
    final hasScheduledSignature = scheduledDateRaw != null &&
        scheduledTimeRaw is String &&
        scheduledTimeRaw.trim().isNotEmpty;
    final learningSummaryAsync = uid.isNotEmpty && dokterId.isNotEmpty
        ? ref.watch(
            pasienLearningSummaryProvider(
              PasienLearningSummaryParams(
                pasienId: uid,
                dokterId: dokterId,
              ),
            ),
          )
        : const AsyncValue.data(PasienLearningSummary.empty());

    useEffect(() {
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
    }, [profilePasien]);

    return Scaffold(
      body: AconsiaPageBackground(
        colors: const [
          UiPalette.blue50,
          UiPalette.white,
        ],
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(fetchPasienProfileProvider);
            if (uid.isNotEmpty && dokterId.isNotEmpty) {
              ref.invalidate(
                pasienLearningSummaryProvider(
                  PasienLearningSummaryParams(
                    pasienId: uid,
                    dokterId: dokterId,
                  ),
                ),
              );
            }
            await Future.delayed(const Duration(milliseconds: 500));
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(UiSpacing.md),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AconsiaTopActionRow(
                    title: 'Profil Saya',
                    subtitle: 'Kelola data pribadi dan informasi medis Anda',
                    leading: IconButton(
                      onPressed: () => PasienMainShellScope.maybeOf(
                        context,
                      )?.openDrawer(),
                      icon: const Icon(Icons.menu_rounded),
                      color: UiPalette.slate600,
                    ),
                  ),
                  const Gap(UiSpacing.md),
                  _buildHeader(
                    nama: namaController.text,
                    email: emailController.text,
                    mrn: noRekamMedisController.text,
                    nik: nikController.text,
                    assessmentCompleted:
                        profilePasien?.assessmentCompleted ?? false,
                  ),
                  const Gap(UiSpacing.sm),
                  _buildClinicalSummary(
                    operasi: jenisOperasiController.text,
                    anestesi: jenisAnestesiController.text,
                    asa: klasifikasiasaController.text,
                    hasScheduledSignature: hasScheduledSignature,
                    scheduleDateRaw: scheduledDateRaw,
                    scheduleTimeRaw: scheduledTimeRaw?.toString() ?? '',
                  ),
                  const Gap(UiSpacing.sm),
                  _buildTabSwitcher(
                    selectedTab: selectedTab.value,
                    onSelect: (tab) => selectedTab.value = tab,
                  ),
                  const Gap(UiSpacing.md),
                  if (selectedTab.value == _ProfileTab.info) ...[
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
                  ] else ...[
                    _buildPerformaTab(context, ref, learningSummaryAsync),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(UiSpacing.md),
        child: Button.filled(
          onPressed: () => context.pushNamed(RouteName.editProfilePasien),
          label: 'Edit Data Diri',
          color: UiPalette.blue600,
          borderColor: UiPalette.blue600,
          borderRadius: 12,
          height: 52,
        ),
      ),
    );
  }

  Widget _buildHeader({
    required String nama,
    required String email,
    required String mrn,
    required String nik,
    required bool assessmentCompleted,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(UiSpacing.md),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF2563EB),
            Color(0xFF0891B2),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: const Color(0xFFE6F0FF),
                child: Text(
                  (nama.isNotEmpty ? nama : 'Pasien')
                      .substring(0, 1)
                      .toUpperCase(),
                  style: UiTypography.h2.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: UiPalette.blue600,
                  ),
                ),
              ),
              const Gap(UiSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      nama.isEmpty ? 'Pasien' : nama,
                      style: UiTypography.title.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: UiPalette.white,
                      ),
                    ),
                    const Gap(UiSpacing.xxs),
                    Text(
                      email,
                      style: UiTypography.caption.copyWith(
                        color: const Color(0xFFE2E8F0),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: UiPalette.white,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  assessmentCompleted ? 'Asesmen Selesai' : 'Asesmen Pending',
                  style: UiTypography.caption.copyWith(
                    color: assessmentCompleted
                        ? const Color(0xFF166534)
                        : const Color(0xFF9A3412),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const Gap(UiSpacing.sm),
          Wrap(
            spacing: UiSpacing.xs,
            runSpacing: UiSpacing.xs,
            children: [
              _headerPill('No. RM: ${mrn.isEmpty ? '-' : mrn}'),
              _headerPill('NIK: ${nik.isEmpty ? '-' : nik}'),
              _headerPill('Role: Pasien'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _headerPill(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0x33FFFFFF),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0x66FFFFFF)),
      ),
      child: Text(
        text,
        style: UiTypography.caption.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildClinicalSummary({
    required String operasi,
    required String anestesi,
    required String asa,
    required bool hasScheduledSignature,
    required dynamic scheduleDateRaw,
    required String scheduleTimeRaw,
  }) {
    String scheduleValue = 'Belum dijadwalkan';
    if (hasScheduledSignature) {
      DateTime? parsed;
      if (scheduleDateRaw is String && scheduleDateRaw.trim().isNotEmpty) {
        parsed = DateTime.tryParse(scheduleDateRaw);
      }
      if (parsed != null) {
        scheduleValue =
            '${DateFormat('d MMM yyyy', 'id_ID').format(parsed)} • $scheduleTimeRaw';
      } else {
        scheduleValue = scheduleTimeRaw;
      }
    }

    return AconsiaCardSurface(
      borderColor: const Color(0xFFDCEAFF),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _metric(
                  title: 'Jenis Operasi',
                  value: operasi.trim().isEmpty ? '-' : operasi,
                  color: const Color(0xFF0284C7),
                ),
              ),
              const Gap(UiSpacing.xs),
              Expanded(
                child: _metric(
                  title: 'Anestesi',
                  value: anestesi.trim().isEmpty ? '-' : anestesi,
                  color: const Color(0xFF7C3AED),
                ),
              ),
            ],
          ),
          const Gap(UiSpacing.xs),
          Row(
            children: [
              Expanded(
                child: _metric(
                  title: 'ASA',
                  value: asa.trim().isEmpty ? '-' : asa,
                  color: const Color(0xFFEA580C),
                ),
              ),
              const Gap(UiSpacing.xs),
              Expanded(
                child: _metric(
                  title: 'Ttd Consent',
                  value: scheduleValue,
                  color: hasScheduledSignature
                      ? const Color(0xFF16A34A)
                      : UiPalette.slate600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTabSwitcher({
    required _ProfileTab selectedTab,
    required void Function(_ProfileTab tab) onSelect,
  }) {
    Widget pill({
      required String text,
      required _ProfileTab tab,
    }) {
      final selected = selectedTab == tab;
      return Expanded(
        child: InkWell(
          onTap: () => onSelect(tab),
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: selected ? UiPalette.blue600 : Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: selected ? UiPalette.blue600 : const Color(0xFFDCE7F5),
              ),
            ),
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: UiTypography.caption.copyWith(
                fontWeight: FontWeight.w700,
                color: selected ? Colors.white : UiPalette.slate600,
              ),
            ),
          ),
        ),
      );
    }

    return Row(
      children: [
        pill(text: 'Informasi', tab: _ProfileTab.info),
        const Gap(UiSpacing.xs),
        pill(text: 'Performa', tab: _ProfileTab.performa),
      ],
    );
  }

  Widget _buildPerformaTab(
    BuildContext context,
    WidgetRef ref,
    AsyncValue<PasienLearningSummary> summaryAsync,
  ) {
    return AconsiaCardSurface(
      borderColor: const Color(0xFFE2EAF4),
      child: summaryAsync.when(
        data: (summary) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Ringkasan Performa',
                style: UiTypography.title,
              ),
              const Gap(UiSpacing.xs),
              Text(
                'Progress belajar dan hasil sesi pembelajaran terbaru Anda.',
                style: UiTypography.bodySmall,
              ),
              const Gap(UiSpacing.sm),
              Row(
                children: [
                  Expanded(
                    child: _metric(
                      title: 'Progress',
                      value: '${summary.completionRate.toStringAsFixed(0)}%',
                      color: const Color(0xFF0EA5E9),
                    ),
                  ),
                  const Gap(UiSpacing.xs),
                  Expanded(
                    child: _metric(
                      title: 'Materi Selesai',
                      value: '${summary.completedKonten}',
                      color: const Color(0xFF22C35D),
                    ),
                  ),
                ],
              ),
              const Gap(UiSpacing.xs),
              Row(
                children: [
                  Expanded(
                    child: _metric(
                      title: 'Belum Selesai',
                      value: '${summary.unreadKonten}',
                      color: const Color(0xFFF59E0B),
                    ),
                  ),
                  const Gap(UiSpacing.xs),
                  Expanded(
                    child: _metric(
                      title: 'Rata-rata Sesi AI',
                      value: '${summary.averageQuizScore.toStringAsFixed(0)}%',
                      color: const Color(0xFF7C3AED),
                    ),
                  ),
                ],
              ),
              const Gap(UiSpacing.sm),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  onPressed: () =>
                      ref.read(selectedIndexPasienProvider.notifier).state = 4,
                  icon: const Icon(Icons.smart_toy_outlined),
                  label: const Text('Diskusi dengan AI'),
                ),
              ),
              const Gap(UiSpacing.xs),
              if (summary.latestQuiz == null)
                Text(
                  'Belum ada hasil sesi. Lanjutkan pembelajaran untuk melihat insight lebih detail.',
                  style: UiTypography.caption,
                )
              else
                Text(
                  'Sesi terakhir: ${summary.latestQuiz!.overallScore}% • ${summary.latestQuiz!.status}',
                  style: UiTypography.caption.copyWith(
                    color: const Color(0xFF51657D),
                    fontWeight: FontWeight.w600,
                  ),
                ),
            ],
          );
        },
        loading: () => const Padding(
          padding: EdgeInsets.symmetric(vertical: 12),
          child: Center(child: CircularProgressIndicator()),
        ),
        error: (error, _) => Text(
          'Gagal memuat performa: $error',
          style: const TextStyle(
            color: UiPalette.red600,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget _metric({
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF5F748B),
              fontWeight: FontWeight.w500,
            ),
          ),
          const Gap(6),
          Text(
            value,
            style: UiTypography.title.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

enum _ProfileTab { info, performa }
