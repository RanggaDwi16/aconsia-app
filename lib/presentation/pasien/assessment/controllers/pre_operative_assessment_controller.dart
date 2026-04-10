import 'package:aconsia_app/core/main/data/models/pasien_profile_model.dart';
import 'package:aconsia_app/presentation/pasien/assessment/domain/usecases/submit_pre_operative_assessment.dart';
import 'package:aconsia_app/presentation/pasien/assessment/models/pre_operative_assessment_form_data.dart';
import 'package:aconsia_app/presentation/pasien/profile/controllers/pasien_profile_impl_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final submitPreOperativeAssessmentUsecaseProvider =
    Provider<SubmitPreOperativeAssessment>((ref) {
  return SubmitPreOperativeAssessment(
    repository: ref.read(pasienProfileRepositoryProvider),
  );
});

final preOperativeAssessmentControllerProvider = NotifierProvider.autoDispose<
    PreOperativeAssessmentController, PreOperativeAssessmentState>(
  PreOperativeAssessmentController.new,
);

class PreOperativeAssessmentState {
  final int currentStep;
  final PreOperativeAssessmentFormData form;
  final Map<String, String> errors;
  final bool isSubmitting;
  final String? submitError;
  final bool submitSuccess;
  final bool hasHydrated;

  const PreOperativeAssessmentState({
    required this.currentStep,
    required this.form,
    required this.errors,
    required this.isSubmitting,
    required this.submitError,
    required this.submitSuccess,
    required this.hasHydrated,
  });

  factory PreOperativeAssessmentState.initial() {
    return PreOperativeAssessmentState(
      currentStep: 1,
      form: PreOperativeAssessmentFormData.initial(),
      errors: const {},
      isSubmitting: false,
      submitError: null,
      submitSuccess: false,
      hasHydrated: false,
    );
  }

  PreOperativeAssessmentState copyWith({
    int? currentStep,
    PreOperativeAssessmentFormData? form,
    Map<String, String>? errors,
    bool? isSubmitting,
    String? submitError,
    bool clearSubmitError = false,
    bool? submitSuccess,
    bool? hasHydrated,
  }) {
    return PreOperativeAssessmentState(
      currentStep: currentStep ?? this.currentStep,
      form: form ?? this.form,
      errors: errors ?? this.errors,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      submitError: clearSubmitError ? null : (submitError ?? this.submitError),
      submitSuccess: submitSuccess ?? this.submitSuccess,
      hasHydrated: hasHydrated ?? this.hasHydrated,
    );
  }
}

class PreOperativeAssessmentController
    extends AutoDisposeNotifier<PreOperativeAssessmentState> {
  @override
  PreOperativeAssessmentState build() {
    return PreOperativeAssessmentState.initial();
  }

  void hydrateFromProfile(PasienProfileModel profile) {
    if (state.hasHydrated) return;
    final form = PreOperativeAssessmentFormData.fromStoredAssessment(
      profile.preOperativeAssessment,
    );
    state = state.copyWith(
      form: form,
      hasHydrated: true,
      errors: const {},
    );
  }

  void setAnesthesiaHistory(String value) {
    final updated = state.form.copyWith(
      hasAnesthesiaHistory: value,
      anesthesiaComplications: value == 'Pernah, ada masalah'
          ? state.form.anesthesiaComplications
          : '',
    );
    _updateForm(updated);
  }

  void setAnesthesiaComplications(String value) {
    _updateForm(state.form.copyWith(anesthesiaComplications: value));
  }

  void setDrugAllergy(String value) {
    final updated = state.form.copyWith(
      hasDrugAllergy: value,
      allergyDetails: value == 'Ada' ? state.form.allergyDetails : '',
      allergyReaction: value == 'Ada' ? state.form.allergyReaction : '',
    );
    _updateForm(updated);
  }

  void setAllergyDetails(String value) {
    _updateForm(state.form.copyWith(allergyDetails: value));
  }

  void setAllergyReaction(String value) {
    _updateForm(state.form.copyWith(allergyReaction: value));
  }

  void setTakingMedication(String value) {
    final updated = state.form.copyWith(
      takingMedication: value,
      medicationList: value == 'Ya' ? state.form.medicationList : const [],
    );
    _updateForm(updated);
  }

  void addMedication() {
    final meds = [...state.form.medicationList, MedicationEntry.empty()];
    _updateForm(state.form.copyWith(medicationList: meds));
  }

  void removeMedication(int index) {
    final meds = [...state.form.medicationList];
    if (index < 0 || index >= meds.length) return;
    meds.removeAt(index);
    _updateForm(state.form.copyWith(medicationList: meds));
  }

  void updateMedication(int index, MedicationEntry entry) {
    final meds = [...state.form.medicationList];
    if (index < 0 || index >= meds.length) return;
    meds[index] = entry;
    _updateForm(state.form.copyWith(medicationList: meds));
  }

  void setSmokingStatus(String value) {
    final updated = state.form.copyWith(
      smokingStatus: value,
      cigarettesPerDay:
          value == 'Merokok aktif' ? state.form.cigarettesPerDay : '',
    );
    _updateForm(updated);
  }

  void setCigarettesPerDay(String value) {
    _updateForm(state.form.copyWith(cigarettesPerDay: value));
  }

  void setAlcoholStatus(String value) {
    _updateForm(state.form.copyWith(alcoholStatus: value));
  }

  void setDrugUse(String value) {
    _updateForm(state.form.copyWith(drugUse: value));
  }

  void toggleDisease(String key, bool value) {
    switch (key) {
      case 'hasDiabetes':
        _updateForm(state.form.copyWith(hasDiabetes: value));
        return;
      case 'hasHypertension':
        _updateForm(state.form.copyWith(hasHypertension: value));
        return;
      case 'hasAsthma':
        _updateForm(state.form.copyWith(hasAsthma: value));
        return;
      case 'hasHeartDisease':
        _updateForm(state.form.copyWith(hasHeartDisease: value));
        return;
      case 'hasStroke':
        _updateForm(state.form.copyWith(hasStroke: value));
        return;
      case 'hasKidneyDisease':
        _updateForm(state.form.copyWith(hasKidneyDisease: value));
        return;
      case 'hasLiverDisease':
        _updateForm(state.form.copyWith(hasLiverDisease: value));
        return;
      case 'hasEpilepsy':
        _updateForm(state.form.copyWith(hasEpilepsy: value));
        return;
      default:
        return;
    }
  }

  void setOtherDiseases(String value) {
    _updateForm(state.form.copyWith(otherDiseases: value));
  }

  void setConfirmationChecked(bool value) {
    _updateForm(state.form.copyWith(confirmationChecked: value));
  }

  bool goToNextStep() {
    final errors = validateStep(state.currentStep);
    if (errors.isNotEmpty) {
      state = state.copyWith(errors: errors);
      return false;
    }

    if (state.currentStep < 4) {
      state =
          state.copyWith(currentStep: state.currentStep + 1, errors: const {});
    }
    return true;
  }

  void goToPreviousStep() {
    if (state.currentStep > 1) {
      state = state.copyWith(
        currentStep: state.currentStep - 1,
        errors: const {},
      );
    }
  }

  void jumpToStep(int step) {
    if (step < 1 || step > 4) return;
    state = state.copyWith(currentStep: step, errors: const {});
  }

  Future<bool> submit({
    required String uid,
    required String asaStatusSnapshot,
  }) async {
    final errors = validateStep(4);
    if (errors.isNotEmpty) {
      state = state.copyWith(errors: errors, submitSuccess: false);
      return false;
    }

    state = state.copyWith(
      isSubmitting: true,
      clearSubmitError: true,
      submitSuccess: false,
    );

    final usecase = ref.read(submitPreOperativeAssessmentUsecaseProvider);
    final result = await usecase(
      SubmitPreOperativeAssessmentParams(
        uid: uid,
        asaStatusSnapshot: asaStatusSnapshot,
        assessmentData: state.form.toDataMap(),
      ),
    );

    return result.fold(
      (failure) {
        state = state.copyWith(
          isSubmitting: false,
          submitError: failure,
          submitSuccess: false,
        );
        return false;
      },
      (_) {
        state = state.copyWith(
          isSubmitting: false,
          submitError: null,
          submitSuccess: true,
          hasHydrated: true,
          errors: const {},
        );
        return true;
      },
    );
  }

  Map<String, String> validateStep(int step) {
    final errors = <String, String>{};
    final form = state.form;

    if (step == 1 || step == 4) {
      if (form.hasAnesthesiaHistory.trim().isEmpty) {
        errors['hasAnesthesiaHistory'] =
            'Pilih riwayat anestesi sebelum melanjutkan.';
      }

      if (form.hasAnesthesiaHistory == 'Pernah, ada masalah' &&
          form.anesthesiaComplications.trim().isEmpty) {
        errors['anesthesiaComplications'] =
            'Jelaskan masalah anestesi yang pernah terjadi.';
      }

      if (form.hasDrugAllergy.trim().isEmpty) {
        errors['hasDrugAllergy'] = 'Pilih status alergi obat terlebih dahulu.';
      }

      if (form.hasDrugAllergy == 'Ada' && form.allergyDetails.trim().isEmpty) {
        errors['allergyDetails'] =
            'Nama obat penyebab alergi wajib diisi jika memilih Ada.';
      }

      if (form.hasDrugAllergy == 'Ada' && form.allergyReaction.trim().isEmpty) {
        errors['allergyReaction'] =
            'Reaksi alergi wajib diisi jika memilih Ada.';
      }
    }

    if (step == 2 || step == 4) {
      if (form.takingMedication.trim().isEmpty) {
        errors['takingMedication'] = 'Pilih status konsumsi obat rutin.';
      }

      if (form.takingMedication == 'Ya') {
        if (form.medicationList.isEmpty) {
          errors['medicationList'] =
              'Tambahkan minimal satu obat rutin yang dikonsumsi.';
        } else {
          final hasInvalid = form.medicationList.any((item) => !item.isValid);
          if (hasInvalid) {
            errors['medicationList'] =
                'Lengkapi nama, dosis, dan frekuensi untuk semua obat.';
          }
        }
      }

      if (form.smokingStatus.trim().isEmpty) {
        errors['smokingStatus'] = 'Pilih status merokok.';
      }

      if (form.smokingStatus == 'Merokok aktif') {
        final count = int.tryParse(form.cigarettesPerDay.trim());
        if (count == null || count <= 0) {
          errors['cigarettesPerDay'] =
              'Jumlah batang rokok per hari harus berupa angka > 0.';
        }
      }

      if (form.alcoholStatus.trim().isEmpty) {
        errors['alcoholStatus'] = 'Pilih status konsumsi alkohol.';
      }
    }

    if (step == 4 && !form.confirmationChecked) {
      errors['confirmationChecked'] =
          'Centang konfirmasi bahwa data yang diisi sudah benar.';
    }

    return errors;
  }

  void _updateForm(PreOperativeAssessmentFormData updated) {
    state = state.copyWith(
      form: updated,
      errors: const {},
      clearSubmitError: true,
      submitSuccess: false,
    );
  }
}
