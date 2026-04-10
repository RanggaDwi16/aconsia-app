import 'package:aconsia_app/core/helpers/widgets/buttons.dart';
import 'package:aconsia_app/core/main/data/models/pasien_profile_model.dart';
import 'package:aconsia_app/core/routers/router_name.dart';
import 'package:aconsia_app/core/ui/components/aconsia_screen_shell.dart';
import 'package:aconsia_app/core/ui/components/aconsia_surface.dart';
import 'package:aconsia_app/core/ui/tokens/ui_palette.dart';
import 'package:aconsia_app/core/ui/tokens/ui_spacing.dart';
import 'package:aconsia_app/core/ui/tokens/ui_typography.dart';
import 'package:aconsia_app/core/utils/extensions/build_context_ext.dart';
import 'package:aconsia_app/presentation/dokter/home/controllers/add_pasien_medic_information/post_add_pasien_medic_information_provider.dart';
import 'package:aconsia_app/presentation/dokter/home/domain/usecases/add_pasien_medic_information.dart';
import 'package:aconsia_app/presentation/pasien/profile/controllers/get_pasien_profile/fetch_pasien_profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

class AddPasienMedicInformationPage extends HookConsumerWidget {
  const AddPasienMedicInformationPage({super.key, this.pasienId});

  final String? pasienId;

  static const List<String> _anesthesiaOptions = [
    'General Anesthesia',
    'Spinal Anesthesia',
    'Epidural Anesthesia',
    'Regional Anesthesia',
    'Local Anesthesia + Sedation',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final namaController = useTextEditingController();
    final diagnosisController = useTextEditingController();
    final jenisOperasiController = useTextEditingController();
    final jenisAnestesiController = useTextEditingController();
    final klasifikasiasaController = useTextEditingController();
    final tinggiBadanController = useTextEditingController();
    final beratBadanController = useTextEditingController();
    final selectedAnesthesia = useState<String?>(null);

    final safePasienId = (pasienId ?? '').trim();
    final hasValidPasienId = safePasienId.isNotEmpty;
    final pasienProfileAsync = hasValidPasienId
        ? ref.watch(fetchPasienProfileProvider(pasienId: safePasienId))
        : const AsyncValue<PasienProfileModel?>.data(null);

    final postAdd = ref.watch(postAddPasienMedicInformationProvider);

    useEffect(() {
      final profilePasien = pasienProfileAsync.value;
      if (profilePasien != null) {
        final preOpDiagnosis =
            (profilePasien.preOperativeAssessment?['diagnosis'] as String? ??
                    '')
                .trim();
        namaController.text = profilePasien.namaLengkap ?? '';
        diagnosisController.text = preOpDiagnosis.isNotEmpty
            ? preOpDiagnosis
            : (profilePasien.jenisOperasi ?? '').trim();
        jenisOperasiController.text = (profilePasien.jenisOperasi ?? '').trim();
        jenisAnestesiController.text =
            (profilePasien.jenisAnestesi ?? '').trim();
        klasifikasiasaController.text =
            (profilePasien.klasifikasiAsa ?? '').trim();
        tinggiBadanController.text =
            profilePasien.tinggiBadan?.toString() ?? '';
        beratBadanController.text = profilePasien.beratBadan?.toString() ?? '';

        final existingAnesthesia = jenisAnestesiController.text.trim();
        selectedAnesthesia.value =
            existingAnesthesia.isEmpty ? null : existingAnesthesia;
      }
      return null;
    }, [pasienProfileAsync.value]);

    useListenable(diagnosisController);
    useListenable(jenisOperasiController);
    useListenable(jenisAnestesiController);
    useListenable(klasifikasiasaController);
    useListenable(tinggiBadanController);
    useListenable(beratBadanController);

    final isSubmitDisabled = !hasValidPasienId ||
        postAdd.isLoading ||
        diagnosisController.text.trim().isEmpty ||
        jenisOperasiController.text.trim().isEmpty ||
        jenisAnestesiController.text.trim().isEmpty ||
        klasifikasiasaController.text.trim().isEmpty;

    return Scaffold(
      body: AconsiaPageBackground(
        colors: const [Color(0xFFF8FAFC), UiPalette.white],
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(UiSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AconsiaTopActionRow(
                title: 'Review & Approval Pasien',
                subtitle:
                    'Lengkapi data medis untuk melanjutkan edukasi pasien',
                onBack: () => context.pop(),
              ),
              const Gap(UiSpacing.md),
              if (!hasValidPasienId)
                _errorBanner(
                  'Parameter patientId tidak valid. Silakan kembali ke daftar pasien.',
                ),
              if (pasienProfileAsync.isLoading && hasValidPasienId)
                const Padding(
                  padding: EdgeInsets.only(top: UiSpacing.xxxl),
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (pasienProfileAsync.hasError) ...[
                _errorBanner(
                  'Gagal memuat data pasien. Silakan coba lagi atau kembali.',
                ),
              ] else if (pasienProfileAsync.value == null) ...[
                _errorBanner(
                  'Data pasien tidak ditemukan.',
                ),
              ] else ...[
                _identityCard(pasienProfileAsync.value!),
                const Gap(UiSpacing.md),
                _healthCard(pasienProfileAsync.value!),
                const Gap(UiSpacing.md),
                _medicalFormCard(
                  diagnosisController: diagnosisController,
                  jenisOperasiController: jenisOperasiController,
                  jenisAnestesiController: jenisAnestesiController,
                  klasifikasiasaController: klasifikasiasaController,
                  tinggiBadanController: tinggiBadanController,
                  beratBadanController: beratBadanController,
                  selectedAnesthesia: selectedAnesthesia,
                ),
              ],
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(UiSpacing.md),
        child: Row(
          children: [
            Expanded(
              child: Button.outlined(
                onPressed: () async {
                  if (!hasValidPasienId || postAdd.isLoading) return;
                  final reason = await _showRejectDialog(context);
                  if (reason == null) return;

                  await ref
                      .read(postAddPasienMedicInformationProvider.notifier)
                      .postAddPasienMedicInformation(
                        pasienId: safePasienId,
                        diagnosis: diagnosisController.text.trim(),
                        decision: DokterApprovalDecision.reject,
                        rejectionReason: reason,
                        profile: PasienProfileModel(
                          jenisOperasi: jenisOperasiController.text.trim(),
                          jenisAnestesi: jenisAnestesiController.text.trim(),
                          klasifikasiAsa: klasifikasiasaController.text.trim(),
                          tinggiBadan: _parseDouble(tinggiBadanController.text),
                          beratBadan: _parseDouble(beratBadanController.text),
                        ),
                        onSuccess: (message) {
                          context.showSuccessDialog(context, message);
                          context.goNamed(RouteName.mainDokter);
                        },
                        onError: (message) {
                          context.showErrorSnackbar(context, message);
                        },
                      );
                },
                label: postAdd.isLoading ? 'Memproses...' : 'Tolak',
                borderColor: UiPalette.red600,
                textColor: UiPalette.red600,
                height: 52,
                borderRadius: 12,
                disabled: !hasValidPasienId || postAdd.isLoading,
              ),
            ),
            const Gap(UiSpacing.sm),
            Expanded(
              flex: 2,
              child: Button.filled(
                disabled: isSubmitDisabled,
                onPressed: () => ref
                    .read(postAddPasienMedicInformationProvider.notifier)
                    .postAddPasienMedicInformation(
                      pasienId: safePasienId,
                      diagnosis: diagnosisController.text.trim(),
                      decision: DokterApprovalDecision.approve,
                      profile: PasienProfileModel(
                        jenisOperasi: jenisOperasiController.text.trim(),
                        jenisAnestesi: jenisAnestesiController.text.trim(),
                        klasifikasiAsa: klasifikasiasaController.text.trim(),
                        tinggiBadan: _parseDouble(tinggiBadanController.text),
                        beratBadan: _parseDouble(beratBadanController.text),
                      ),
                      onSuccess: (message) {
                        context.showSuccessDialog(context, message);
                        context.goNamed(RouteName.mainDokter);
                      },
                      onError: (message) {
                        context.showErrorSnackbar(context, message);
                      },
                    ),
                label: postAdd.isLoading
                    ? 'Memproses...'
                    : 'Setujui & Aktifkan Edukasi',
                color: UiPalette.emerald600,
                borderColor: UiPalette.emerald600,
                height: 52,
                borderRadius: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _errorBanner(String message) {
    return AconsiaCardSurface(
      borderColor: const Color(0xFFFECACA),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.error_outline_rounded, color: UiPalette.red600),
          const Gap(UiSpacing.sm),
          Expanded(
            child: Text(
              message,
              style: UiTypography.bodySmall.copyWith(
                color: UiPalette.red600,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _identityCard(PasienProfileModel profile) {
    final tanggal = profile.tanggalLahir == null
        ? '-'
        : DateFormat('dd MMMM yyyy', 'id_ID')
            .format(profile.tanggalLahir!.toDate());
    return AconsiaCardSurface(
      borderColor: const Color(0xFFBFDBFE),
      radius: 14,
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(UiSpacing.md),
            decoration: const BoxDecoration(
              color: Color(0xFFEFF6FF),
              borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
            ),
            child: Row(
              children: [
                const Icon(Icons.person_outline_rounded,
                    color: UiPalette.blue600),
                const Gap(UiSpacing.xs),
                Text(
                  'Identitas Pasien',
                  style: UiTypography.title.copyWith(fontSize: 18),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(UiSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _infoItem('Nama Lengkap', profile.namaLengkap ?? '-'),
                _infoItem('No. Rekam Medis', profile.noRekamMedis ?? '-'),
                _infoItem('NIK', profile.nik ?? '-'),
                _infoItem('Tanggal Lahir', tanggal),
                _infoItem('Jenis Kelamin', profile.jenisKelamin ?? '-'),
                _infoItem('No. Telepon', profile.nomorTelepon ?? '-'),
                _infoItem('Alamat', profile.alamatLengkap ?? '-'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _healthCard(PasienProfileModel profile) {
    return AconsiaCardSurface(
      borderColor: const Color(0xFFFECACA),
      radius: 14,
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(UiSpacing.md),
            decoration: const BoxDecoration(
              color: Color(0xFFFEF2F2),
              borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
            ),
            child: Row(
              children: [
                const Icon(Icons.favorite_outline_rounded,
                    color: UiPalette.red600),
                const Gap(UiSpacing.xs),
                Text(
                  'Data Kesehatan',
                  style: UiTypography.title.copyWith(fontSize: 18),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(UiSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _healthMetric(
                        'Tinggi',
                        profile.tinggiBadan == null
                            ? '-'
                            : '${profile.tinggiBadan!.toStringAsFixed(0)} cm',
                      ),
                    ),
                    Expanded(
                      child: _healthMetric(
                        'Berat',
                        profile.beratBadan == null
                            ? '-'
                            : '${profile.beratBadan!.toStringAsFixed(0)} kg',
                      ),
                    ),
                    Expanded(
                      child: _healthMetric('Gol. Darah', '-'),
                    ),
                  ],
                ),
                const Gap(UiSpacing.sm),
                _infoItem('Alergi', 'Tidak ada'),
                _infoItem('Riwayat Penyakit', 'Tidak ada'),
                _infoItem('Obat Saat Ini', 'Tidak ada'),
                _infoItem('Riwayat Anestesi', 'Belum pernah'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _medicalFormCard({
    required TextEditingController diagnosisController,
    required TextEditingController jenisOperasiController,
    required TextEditingController jenisAnestesiController,
    required TextEditingController klasifikasiasaController,
    required TextEditingController tinggiBadanController,
    required TextEditingController beratBadanController,
    required ValueNotifier<String?> selectedAnesthesia,
  }) {
    return AconsiaCardSurface(
      borderColor: const Color(0xFFBBF7D0),
      radius: 14,
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(UiSpacing.md),
            decoration: const BoxDecoration(
              color: Color(0xFFF0FDF4),
              borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.medical_services_outlined,
                        color: UiPalette.emerald600),
                    const Gap(UiSpacing.xs),
                    Text(
                      'Lengkapi Data Medis & Operasi',
                      style: UiTypography.title.copyWith(fontSize: 18),
                    ),
                  ],
                ),
                const Gap(UiSpacing.xs),
                Text(
                  'Data ini akan menentukan konten edukasi yang diterima pasien',
                  style: UiTypography.bodySmall
                      .copyWith(color: UiPalette.slate600),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(UiSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _fieldLabel('Diagnosis Medis *'),
                const Gap(6),
                TextField(
                  controller: diagnosisController,
                  decoration: const InputDecoration(
                    hintText: 'Contoh: Appendicitis Acute, Cholelithiasis, dll',
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                ),
                const Gap(UiSpacing.md),
                _fieldLabel('Jenis Operasi *'),
                const Gap(6),
                TextField(
                  controller: jenisOperasiController,
                  decoration: const InputDecoration(
                    hintText:
                        'Contoh: Appendektomi, Kolesistektomi, Operasi Caesar, dll',
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                ),
                const Gap(UiSpacing.md),
                _fieldLabel('Jenis Anestesi *'),
                const Gap(6),
                _anesthesiaGuidance(),
                const Gap(UiSpacing.sm),
                DropdownButtonFormField<String>(
                  value: selectedAnesthesia.value,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                  items: _anesthesiaOptions
                      .map(
                        (item) => DropdownMenuItem<String>(
                          value: item,
                          child: Text(item),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    selectedAnesthesia.value = value;
                    jenisAnestesiController.text = value ?? '';
                  },
                  hint: const Text('-- Pilih Jenis Anestesi --'),
                ),
                const Gap(UiSpacing.sm),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(UiSpacing.sm),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF6FF),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFBFDBFE)),
                  ),
                  child: Text(
                    'SISTEM AUTO-FILTER: Setelah memilih jenis anestesi, materi edukasi pasien akan difilter sesuai jenis anestesi yang dipilih.',
                    style: UiTypography.caption.copyWith(
                      color: UiPalette.blue600,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const Gap(UiSpacing.md),
                _fieldLabel('Klasifikasi ASA *'),
                const Gap(6),
                TextField(
                  controller: klasifikasiasaController,
                  decoration: const InputDecoration(
                    hintText: 'Contoh: ASA II',
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                ),
                const Gap(UiSpacing.md),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: tinggiBadanController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Tinggi Badan (cm)',
                          border: OutlineInputBorder(),
                          isDense: true,
                        ),
                      ),
                    ),
                    const Gap(UiSpacing.sm),
                    Expanded(
                      child: TextField(
                        controller: beratBadanController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Berat Badan (kg)',
                          border: OutlineInputBorder(),
                          isDense: true,
                        ),
                      ),
                    ),
                  ],
                ),
                const Gap(UiSpacing.md),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(UiSpacing.sm),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFFBEB),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFFDE68A)),
                  ),
                  child: Text(
                    'Catatan: Setelah disetujui, pasien dapat mengakses materi sesuai jenis anestesi yang dipilih. Pasien harus mencapai pemahaman minimal 80% sebelum menjadwalkan tanda tangan informed consent.',
                    style: UiTypography.caption.copyWith(
                      color: const Color(0xFF92400E),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _anesthesiaGuidance() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(UiSpacing.sm),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F3FF),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFDDD6FE)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Panduan Pemilihan Jenis Anestesi:',
            style: UiTypography.bodySmall.copyWith(
              color: const Color(0xFF5B21B6),
              fontWeight: FontWeight.w700,
            ),
          ),
          const Gap(UiSpacing.xs),
          _guidanceItem(
            'Anestesi Umum (General)',
            'Operasi mayor, durasi lama, atau pasien tidak kooperatif.',
          ),
          _guidanceItem(
            'Anestesi Regional (Spinal/Epidural)',
            'Operasi ekstremitas bawah/pelvis atau pasien risiko tinggi GA.',
          ),
          _guidanceItem(
            'Anestesi Lokal + Sedasi',
            'Operasi minor, area terbatas, pasien kooperatif/rawat jalan.',
          ),
        ],
      ),
    );
  }

  Widget _guidanceItem(String title, String body) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        '• $title: $body',
        style: UiTypography.caption.copyWith(
          color: const Color(0xFF4C1D95),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _fieldLabel(String text) {
    return Text(
      text,
      style: UiTypography.body.copyWith(
        color: UiPalette.slate900,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  Widget _healthMetric(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: UiTypography.caption.copyWith(color: UiPalette.slate500),
        ),
        const Gap(2),
        Text(
          value.trim().isEmpty ? '-' : value,
          style: UiTypography.body.copyWith(
            color: UiPalette.slate900,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _infoItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: UiSpacing.xs),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: UiTypography.caption.copyWith(color: UiPalette.slate500),
          ),
          const Gap(2),
          Text(
            value.trim().isEmpty ? '-' : value.trim(),
            style: UiTypography.body.copyWith(
              color: UiPalette.slate900,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Future<String?> _showRejectDialog(BuildContext context) async {
    final reasonController = TextEditingController();
    final result = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Tolak Pasien'),
          content: TextField(
            controller: reasonController,
            maxLines: 3,
            decoration: const InputDecoration(
              hintText: 'Alasan penolakan (opsional)',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(reasonController.text.trim());
              },
              child: const Text('Tolak'),
            ),
          ],
        );
      },
    );
    reasonController.dispose();
    return result;
  }

  double? _parseDouble(String raw) {
    final text = raw.trim().replaceAll(',', '.');
    if (text.isEmpty) return null;
    return double.tryParse(text);
  }
}
