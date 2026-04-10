import 'package:aconsia_app/core/ui/components/aconsia_screen_shell.dart';
import 'package:aconsia_app/core/ui/components/aconsia_surface.dart';
import 'package:aconsia_app/core/ui/tokens/ui_palette.dart';
import 'package:aconsia_app/core/ui/tokens/ui_spacing.dart';
import 'package:aconsia_app/core/ui/tokens/ui_typography.dart';
import 'package:aconsia_app/core/utils/extensions/build_context_ext.dart';
import 'package:aconsia_app/presentation/pasien/assessment/controllers/pre_operative_assessment_controller.dart';
import 'package:aconsia_app/presentation/pasien/assessment/models/pre_operative_assessment_form_data.dart';
import 'package:aconsia_app/presentation/pasien/main/controllers/selected_index_provider.dart';
import 'package:aconsia_app/presentation/pasien/main/widgets/pasien_main_shell_scope.dart';
import 'package:aconsia_app/presentation/pasien/profile/controllers/get_pasien_profile/fetch_pasien_profile_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

final currentPasienUidProvider = Provider<String>((ref) {
  return FirebaseAuth.instance.currentUser?.uid ?? '';
});

class PreOperativeAssessmentPage extends ConsumerStatefulWidget {
  final bool embeddedInMainShell;

  const PreOperativeAssessmentPage({
    super.key,
    this.embeddedInMainShell = true,
  });

  @override
  ConsumerState<PreOperativeAssessmentPage> createState() =>
      _PreOperativeAssessmentPageState();
}

class _PreOperativeAssessmentPageState
    extends ConsumerState<PreOperativeAssessmentPage> {
  @override
  Widget build(BuildContext context) {
    final uid = ref.watch(currentPasienUidProvider);
    final profileAsync = ref.watch(fetchPasienProfileProvider(pasienId: uid));
    final state = ref.watch(preOperativeAssessmentControllerProvider);
    final notifier =
        ref.read(preOperativeAssessmentControllerProvider.notifier);

    ref.listen(preOperativeAssessmentControllerProvider, (previous, next) {
      if (next.submitError != null &&
          next.submitError != previous?.submitError) {
        context.showErrorSnackbar(context, next.submitError!);
      }

      if (next.submitSuccess && previous?.submitSuccess != true) {
        context.showSuccessDialog(
          context,
          'Asesmen pra-operasi berhasil disimpan.',
        );
        ref.invalidate(fetchPasienProfileProvider);
      }
    });

    profileAsync.whenData((profile) {
      if (profile != null) {
        notifier.hydrateFromProfile(profile);
      }
    });

    return Scaffold(
      body: AconsiaPageBackground(
        colors: const [UiPalette.blue50, UiPalette.white],
        child: profileAsync.when(
          data: (profile) {
            if (profile == null) {
              return const Center(
                  child: Text('Profil pasien belum ditemukan.'));
            }
            final asaText = (profile.klasifikasiAsa ?? '').trim();
            return Theme(
              data: _buildAssessmentTheme(context),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(UiSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AconsiaTopActionRow(
                      title: 'Asesmen Pra-Operasi',
                      subtitle:
                          'Isi data lengkap untuk evaluasi risiko anestesi',
                      leading: widget.embeddedInMainShell
                          ? IconButton(
                              onPressed: () =>
                                  PasienMainShellScope.maybeOf(context)
                                      ?.openDrawer(),
                              icon: const Icon(Icons.menu_rounded),
                              color: UiPalette.slate600,
                            )
                          : IconButton(
                              onPressed: () => context.pop(),
                              icon: const Icon(Icons.arrow_back_rounded),
                              color: UiPalette.slate600,
                            ),
                    ),
                    const Gap(UiSpacing.md),
                    _ProgressCard(currentStep: state.currentStep),
                    const Gap(UiSpacing.md),
                    Container(
                      decoration: BoxDecoration(
                        color: UiPalette.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: UiPalette.slate200),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x120F172A),
                            blurRadius: 20,
                            offset: Offset(0, 8),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(UiSpacing.md),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                  color: UiPalette.blue50,
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                child: const Icon(
                                  Icons.assignment_outlined,
                                  color: UiPalette.blue600,
                                  size: 18,
                                ),
                              ),
                              const Gap(UiSpacing.xs),
                              Text(
                                _titleByStep(state.currentStep),
                                style: UiTypography.title.copyWith(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                          if (asaText.isNotEmpty) ...[
                            const Gap(UiSpacing.sm),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(UiSpacing.sm),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF1F8FF),
                                borderRadius: BorderRadius.circular(10),
                                border:
                                    Border.all(color: const Color(0xFFBFDBFE)),
                              ),
                              child: Text(
                                'ASA (ditetapkan dokter): $asaText',
                                style: UiTypography.bodySmall.copyWith(
                                  color: UiPalette.slate700,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                          const Gap(UiSpacing.md),
                          _StepBody(state: state, notifier: notifier),
                          const Gap(UiSpacing.md),
                          _StepActions(
                            state: state,
                            notifier: notifier,
                            uid: uid,
                            asaStatusSnapshot: asaText,
                            onSuccess: () {
                              if (widget.embeddedInMainShell) {
                                ref
                                    .read(selectedIndexPasienProvider.notifier)
                                    .state = 0;
                              } else {
                                context.pop();
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(
            child: Text('Gagal memuat asesmen: $error'),
          ),
        ),
      ),
    );
  }

  String _titleByStep(int step) {
    switch (step) {
      case 1:
        return 'Riwayat Anestesi & Alergi';
      case 2:
        return 'Obat-obatan & Kebiasaan';
      case 3:
        return 'Riwayat Penyakit';
      case 4:
        return 'Konfirmasi Data';
      default:
        return 'Asesmen';
    }
  }

  ThemeData _buildAssessmentTheme(BuildContext context) {
    final base = Theme.of(context);
    return base.copyWith(
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return UiPalette.blue600;
          return UiPalette.slate400;
        }),
      ),
      inputDecorationTheme: InputDecorationTheme(
        isDense: true,
        filled: true,
        fillColor: const Color(0xFFF8FAFC),
        hintStyle: UiTypography.bodySmall.copyWith(color: UiPalette.slate400),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: UiSpacing.sm,
          vertical: UiSpacing.sm,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: UiPalette.slate200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: UiPalette.blue500, width: 1.2),
        ),
      ),
    );
  }
}

class _ProgressCard extends StatelessWidget {
  final int currentStep;
  const _ProgressCard({required this.currentStep});

  @override
  Widget build(BuildContext context) {
    final completedColor = UiPalette.blue600;
    final inactiveColor = const Color(0xFFCBD5E1);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        UiSpacing.md,
        UiSpacing.md,
        UiSpacing.md,
        UiSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: UiPalette.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFBFDBFE)),
      ),
      child: Column(
        children: [
          Row(
            children: List.generate(4, (index) {
              final step = index + 1;
              final active = step <= currentStep;
              final isCurrent = step == currentStep;

              return Expanded(
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: active ? completedColor : inactiveColor,
                        boxShadow: isCurrent
                            ? const [
                                BoxShadow(
                                  color: Color(0x332563EB),
                                  blurRadius: 10,
                                  offset: Offset(0, 3),
                                )
                              ]
                            : null,
                      ),
                      child: Text(
                        '$step',
                        style: UiTypography.bodySmall.copyWith(
                          color: active ? UiPalette.white : UiPalette.slate600,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    if (index < 3)
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: UiSpacing.xs),
                          height: 4,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(999),
                            color: step < currentStep
                                ? completedColor
                                : inactiveColor,
                          ),
                        ),
                      ),
                  ],
                ),
              );
            }),
          ),
          const Gap(UiSpacing.sm),
          Text(
            'Progress asesmen',
            style: UiTypography.bodySmall.copyWith(
              color: UiPalette.slate500,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Gap(2),
          Text(
            'Langkah $currentStep dari 4',
            style: UiTypography.bodySmall.copyWith(
              color: UiPalette.slate700,
              fontWeight: FontWeight.w800,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}

class _StepBody extends StatelessWidget {
  final PreOperativeAssessmentState state;
  final PreOperativeAssessmentController notifier;
  const _StepBody({required this.state, required this.notifier});

  @override
  Widget build(BuildContext context) {
    switch (state.currentStep) {
      case 1:
        return _StepOne(state: state, notifier: notifier);
      case 2:
        return _StepTwo(state: state, notifier: notifier);
      case 3:
        return _StepThree(state: state, notifier: notifier);
      case 4:
        return _StepFour(state: state, notifier: notifier);
      default:
        return const SizedBox.shrink();
    }
  }
}

class _StepOne extends StatelessWidget {
  final PreOperativeAssessmentState state;
  final PreOperativeAssessmentController notifier;
  const _StepOne({required this.state, required this.notifier});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionLabel(
            'Apakah Anda pernah menjalani anestesi sebelumnya? *'),
        ...['Belum pernah', 'Pernah, tidak ada masalah', 'Pernah, ada masalah']
            .map(
          (option) => _RadioOption(
            label: option,
            value: option,
            groupValue: state.form.hasAnesthesiaHistory,
            onChanged: notifier.setAnesthesiaHistory,
          ),
        ),
        _ErrorText(state.errors['hasAnesthesiaHistory']),
        if (state.form.hasAnesthesiaHistory == 'Pernah, ada masalah') ...[
          const Gap(UiSpacing.sm),
          TextFormField(
            key: const ValueKey('anesthesiaComplications'),
            initialValue: state.form.anesthesiaComplications,
            minLines: 3,
            maxLines: 4,
            onChanged: notifier.setAnesthesiaComplications,
            decoration: const InputDecoration(
              hintText: 'Jelaskan masalah anestesi yang terjadi',
            ),
          ),
          _ErrorText(state.errors['anesthesiaComplications']),
        ],
        const Gap(UiSpacing.md),
        const _SectionLabel(
            'Apakah Anda memiliki alergi terhadap obat-obatan? *'),
        ...['Tidak ada', 'Ada'].map(
          (option) => _RadioOption(
            label: option,
            value: option,
            groupValue: state.form.hasDrugAllergy,
            onChanged: notifier.setDrugAllergy,
          ),
        ),
        _ErrorText(state.errors['hasDrugAllergy']),
        if (state.form.hasDrugAllergy == 'Ada') ...[
          const Gap(UiSpacing.sm),
          TextFormField(
            key: const ValueKey('allergyDetails'),
            initialValue: state.form.allergyDetails,
            onChanged: notifier.setAllergyDetails,
            decoration: const InputDecoration(
              hintText: 'Nama obat penyebab alergi',
            ),
          ),
          _ErrorText(state.errors['allergyDetails']),
          const Gap(UiSpacing.sm),
          TextFormField(
            key: const ValueKey('allergyReaction'),
            initialValue: state.form.allergyReaction,
            onChanged: notifier.setAllergyReaction,
            decoration: const InputDecoration(
              hintText: 'Reaksi alergi yang terjadi',
            ),
          ),
          _ErrorText(state.errors['allergyReaction']),
        ],
      ],
    );
  }
}

class _StepTwo extends StatelessWidget {
  final PreOperativeAssessmentState state;
  final PreOperativeAssessmentController notifier;
  const _StepTwo({required this.state, required this.notifier});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionLabel('Apakah Anda rutin mengonsumsi obat-obatan? *'),
        ...['Tidak', 'Ya'].map(
          (option) => _RadioOption(
            label: option,
            value: option,
            groupValue: state.form.takingMedication,
            onChanged: notifier.setTakingMedication,
          ),
        ),
        _ErrorText(state.errors['takingMedication']),
        if (state.form.takingMedication == 'Ya') ...[
          const Gap(UiSpacing.sm),
          ...state.form.medicationList.asMap().entries.map((entry) {
            final index = entry.key;
            final med = entry.value;
            return _MedicationCard(
              index: index,
              entry: med,
              onDelete: () => notifier.removeMedication(index),
              onNameChanged: (value) =>
                  notifier.updateMedication(index, med.copyWith(name: value)),
              onDoseChanged: (value) =>
                  notifier.updateMedication(index, med.copyWith(dose: value)),
              onFrequencyChanged: (value) => notifier.updateMedication(
                index,
                med.copyWith(frequency: value),
              ),
            );
          }),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: notifier.addMedication,
              icon: const Icon(Icons.add_rounded),
              label: const Text('Tambah Obat'),
            ),
          ),
          _ErrorText(state.errors['medicationList']),
        ],
        const Gap(UiSpacing.md),
        const _SectionLabel('Status merokok *'),
        ...[
          'Tidak merokok',
          'Pernah merokok (sudah berhenti)',
          'Merokok aktif',
        ].map(
          (option) => _RadioOption(
            label: option,
            value: option,
            groupValue: state.form.smokingStatus,
            onChanged: notifier.setSmokingStatus,
          ),
        ),
        _ErrorText(state.errors['smokingStatus']),
        if (state.form.smokingStatus == 'Merokok aktif') ...[
          const Gap(UiSpacing.sm),
          TextFormField(
            key: const ValueKey('cigarettesPerDay'),
            initialValue: state.form.cigarettesPerDay,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onChanged: notifier.setCigarettesPerDay,
            decoration: const InputDecoration(
              hintText: 'Batang rokok per hari',
            ),
          ),
          _ErrorText(state.errors['cigarettesPerDay']),
        ],
        const Gap(UiSpacing.md),
        const _SectionLabel('Konsumsi alkohol *'),
        ...[
          'Tidak pernah',
          'Jarang (1-2x/bulan)',
          'Sering (>1x/minggu)',
          'Setiap hari',
        ].map(
          (option) => _RadioOption(
            label: option,
            value: option,
            groupValue: state.form.alcoholStatus,
            onChanged: notifier.setAlcoholStatus,
          ),
        ),
        _ErrorText(state.errors['alcoholStatus']),
      ],
    );
  }
}

class _MedicationCard extends StatelessWidget {
  final int index;
  final MedicationEntry entry;
  final VoidCallback onDelete;
  final ValueChanged<String> onNameChanged;
  final ValueChanged<String> onDoseChanged;
  final ValueChanged<String> onFrequencyChanged;

  const _MedicationCard({
    required this.index,
    required this.entry,
    required this.onDelete,
    required this.onNameChanged,
    required this.onDoseChanged,
    required this.onFrequencyChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: UiSpacing.sm),
      padding: const EdgeInsets.all(UiSpacing.sm),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: UiPalette.slate200),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                'Obat ${index + 1}',
                style: UiTypography.bodySmall.copyWith(
                    color: UiPalette.slate900, fontWeight: FontWeight.w700),
              ),
              const Spacer(),
              IconButton(
                onPressed: onDelete,
                icon: const Icon(Icons.delete_outline_rounded),
                color: UiPalette.red600,
              ),
            ],
          ),
          TextFormField(
            key: ValueKey('med_name_$index'),
            initialValue: entry.name,
            onChanged: onNameChanged,
            decoration: const InputDecoration(hintText: 'Nama obat'),
          ),
          const Gap(UiSpacing.xs),
          TextFormField(
            key: ValueKey('med_dose_$index'),
            initialValue: entry.dose,
            onChanged: onDoseChanged,
            decoration: const InputDecoration(hintText: 'Dosis'),
          ),
          const Gap(UiSpacing.xs),
          TextFormField(
            key: ValueKey('med_freq_$index'),
            initialValue: entry.frequency,
            onChanged: onFrequencyChanged,
            decoration: const InputDecoration(hintText: 'Frekuensi'),
          ),
        ],
      ),
    );
  }
}

class _DiseaseOption {
  final String keyName;
  final String label;
  final bool selected;

  const _DiseaseOption({
    required this.keyName,
    required this.label,
    required this.selected,
  });
}

class _StepThree extends StatelessWidget {
  final PreOperativeAssessmentState state;
  final PreOperativeAssessmentController notifier;
  const _StepThree({required this.state, required this.notifier});

  @override
  Widget build(BuildContext context) {
    final diseases = [
      _DiseaseOption(
        keyName: 'hasDiabetes',
        label: 'Diabetes (Kencing Manis)',
        selected: state.form.hasDiabetes,
      ),
      _DiseaseOption(
        keyName: 'hasHypertension',
        label: 'Hipertensi',
        selected: state.form.hasHypertension,
      ),
      _DiseaseOption(
        keyName: 'hasAsthma',
        label: 'Asma',
        selected: state.form.hasAsthma,
      ),
      _DiseaseOption(
        keyName: 'hasHeartDisease',
        label: 'Penyakit Jantung',
        selected: state.form.hasHeartDisease,
      ),
      _DiseaseOption(
        keyName: 'hasStroke',
        label: 'Riwayat Stroke',
        selected: state.form.hasStroke,
      ),
      _DiseaseOption(
        keyName: 'hasKidneyDisease',
        label: 'Penyakit Ginjal',
        selected: state.form.hasKidneyDisease,
      ),
      _DiseaseOption(
        keyName: 'hasLiverDisease',
        label: 'Penyakit Hati/Liver',
        selected: state.form.hasLiverDisease,
      ),
      _DiseaseOption(
        keyName: 'hasEpilepsy',
        label: 'Epilepsi/Kejang',
        selected: state.form.hasEpilepsy,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(UiSpacing.sm),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF6E8),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFFFE3B3)),
          ),
          child: Text(
            'Penting: centang semua penyakit yang pernah/sedang Anda alami.',
            style: UiTypography.bodySmall.copyWith(
              color: UiPalette.slate700,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const Gap(UiSpacing.sm),
        ...diseases.map(
          (item) => CheckboxListTile(
            value: item.selected,
            onChanged: (value) =>
                notifier.toggleDisease(item.keyName, value ?? false),
            title: Text(item.label, style: UiTypography.bodySmall),
            contentPadding: EdgeInsets.zero,
            controlAffinity: ListTileControlAffinity.leading,
          ),
        ),
        const Gap(UiSpacing.sm),
        TextFormField(
          key: const ValueKey('otherDiseases'),
          initialValue: state.form.otherDiseases,
          minLines: 2,
          maxLines: 3,
          onChanged: notifier.setOtherDiseases,
          decoration: const InputDecoration(
            hintText: 'Penyakit lain yang belum disebutkan (opsional)',
          ),
        ),
      ],
    );
  }
}

class _StepFour extends StatelessWidget {
  final PreOperativeAssessmentState state;
  final PreOperativeAssessmentController notifier;
  const _StepFour({required this.state, required this.notifier});

  @override
  Widget build(BuildContext context) {
    final diseases = state.form.selectedDiseaseLabels();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(UiSpacing.sm),
          decoration: BoxDecoration(
            color: const Color(0xFFECFDF3),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFBBF7D0)),
          ),
          child: Text(
            'Periksa kembali data Anda sebelum submit.',
            style: UiTypography.bodySmall.copyWith(
              color: const Color(0xFF166534),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const Gap(UiSpacing.sm),
        _SummaryItem(
          label: 'Riwayat Anestesi',
          value: state.form.hasAnesthesiaHistory.isEmpty
              ? '-'
              : state.form.hasAnesthesiaHistory,
        ),
        _SummaryItem(
          label: 'Alergi Obat',
          value: state.form.hasDrugAllergy == 'Ada'
              ? 'Ada (${state.form.allergyDetails})'
              : (state.form.hasDrugAllergy.isEmpty
                  ? '-'
                  : state.form.hasDrugAllergy),
        ),
        _SummaryItem(
          label: 'Obat Rutin',
          value: state.form.takingMedication == 'Ya'
              ? 'Ya (${state.form.medicationList.length} obat)'
              : (state.form.takingMedication.isEmpty
                  ? '-'
                  : state.form.takingMedication),
        ),
        _SummaryItem(
          label: 'Merokok',
          value:
              state.form.smokingStatus.isEmpty ? '-' : state.form.smokingStatus,
        ),
        _SummaryItem(
          label: 'Alkohol',
          value:
              state.form.alcoholStatus.isEmpty ? '-' : state.form.alcoholStatus,
        ),
        _SummaryItem(
          label: 'Riwayat Penyakit',
          value: diseases.isEmpty ? 'Tidak ada' : diseases.join(', '),
        ),
        const Gap(UiSpacing.sm),
        CheckboxListTile(
          value: state.form.confirmationChecked,
          onChanged: (value) => notifier.setConfirmationChecked(value ?? false),
          contentPadding: EdgeInsets.zero,
          controlAffinity: ListTileControlAffinity.leading,
          title: const Text(
            'Saya menyatakan data yang diisi sudah benar.',
            style: UiTypography.bodySmall,
          ),
        ),
        _ErrorText(state.errors['confirmationChecked']),
      ],
    );
  }
}

class _StepActions extends StatelessWidget {
  final PreOperativeAssessmentState state;
  final PreOperativeAssessmentController notifier;
  final String uid;
  final String asaStatusSnapshot;
  final VoidCallback onSuccess;

  const _StepActions({
    required this.state,
    required this.notifier,
    required this.uid,
    required this.asaStatusSnapshot,
    required this.onSuccess,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (state.currentStep > 1)
          Expanded(
            child: OutlinedButton.icon(
              onPressed: state.isSubmitting ? null : notifier.goToPreviousStep,
              icon: const Icon(Icons.arrow_back_rounded, size: 18),
              label: const Text(
                'Sebelumnya',
                maxLines: 1,
                softWrap: false,
                overflow: TextOverflow.fade,
              ),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                foregroundColor: UiPalette.slate700,
                side: const BorderSide(color: UiPalette.slate300),
                padding: const EdgeInsets.symmetric(horizontal: UiSpacing.xs),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        if (state.currentStep > 1) const Gap(UiSpacing.sm),
        Expanded(
          child: state.currentStep < 4
              ? ElevatedButton.icon(
                  onPressed: state.isSubmitting ? null : notifier.goToNextStep,
                  icon: const Icon(Icons.arrow_forward_rounded, size: 18),
                  label: const Text(
                    'Selanjutnya',
                    maxLines: 1,
                    softWrap: false,
                    overflow: TextOverflow.fade,
                  ),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                    backgroundColor: UiPalette.blue600,
                    foregroundColor: UiPalette.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: UiSpacing.xs),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                )
              : ElevatedButton.icon(
                  onPressed: state.isSubmitting
                      ? null
                      : () async {
                          final ok = await notifier.submit(
                            uid: uid,
                            asaStatusSnapshot: asaStatusSnapshot,
                          );
                          if (ok) onSuccess();
                        },
                  icon: state.isSubmitting
                      ? const SizedBox(
                          width: 14,
                          height: 14,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.check_circle_outline_rounded,
                          size: 18),
                  label: Text(
                    state.isSubmitting ? 'Menyimpan...' : 'Submit Asesmen',
                    maxLines: 1,
                    softWrap: false,
                    overflow: TextOverflow.fade,
                  ),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                    backgroundColor: const Color(0xFF16A34A),
                    foregroundColor: UiPalette.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: UiSpacing.xs),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
        ),
      ],
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: UiSpacing.xs, top: 2),
      child: Text(
        text,
        style: UiTypography.title.copyWith(
          fontSize: 17,
          color: UiPalette.slate900,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _RadioOption extends StatelessWidget {
  final String label;
  final String value;
  final String groupValue;
  final ValueChanged<String> onChanged;

  const _RadioOption({
    required this.label,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = groupValue == value;
    return Container(
      margin: const EdgeInsets.only(bottom: UiSpacing.xs),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? UiPalette.blue500 : UiPalette.slate200,
        ),
        color: isSelected ? UiPalette.blue50 : UiPalette.white,
      ),
      child: RadioListTile<String>(
        value: value,
        groupValue: groupValue,
        onChanged: (val) {
          if (val != null) onChanged(val);
        },
        dense: true,
        title: Text(
          label,
          style: UiTypography.body.copyWith(
            color: UiPalette.slate700,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: UiSpacing.xs,
          vertical: 2,
        ),
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final String label;
  final String value;
  const _SummaryItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: UiSpacing.xs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(
              '$label:',
              style: UiTypography.bodySmall.copyWith(
                color: UiPalette.slate600,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: UiTypography.bodySmall.copyWith(
                color: UiPalette.slate900,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorText extends StatelessWidget {
  final String? message;
  const _ErrorText(this.message);

  @override
  Widget build(BuildContext context) {
    if (message == null || message!.isEmpty) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.only(top: 2, bottom: UiSpacing.xs),
      child: Text(
        message!,
        style: UiTypography.caption.copyWith(color: UiPalette.red600),
      ),
    );
  }
}
