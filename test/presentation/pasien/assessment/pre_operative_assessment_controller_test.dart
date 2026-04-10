import 'package:aconsia_app/presentation/pasien/assessment/controllers/pre_operative_assessment_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PreOperativeAssessmentController Validation', () {
    late ProviderContainer container;
    late PreOperativeAssessmentController notifier;

    setUp(() {
      container = ProviderContainer();
      notifier =
          container.read(preOperativeAssessmentControllerProvider.notifier);
    });

    tearDown(() {
      container.dispose();
    });

    test('step 1 should require anesthesia and allergy fields', () {
      final errors = notifier.validateStep(1);
      expect(errors['hasAnesthesiaHistory'], isNotNull);
      expect(errors['hasDrugAllergy'], isNotNull);
    });

    test(
        'step 2 should require valid medication details when taking medication',
        () {
      notifier.setTakingMedication('Ya');
      notifier.addMedication();
      notifier.setSmokingStatus('Tidak merokok');
      notifier.setAlcoholStatus('Tidak pernah');

      final errors = notifier.validateStep(2);
      expect(errors['medicationList'], isNotNull);
    });

    test('step 2 should require cigarettes count for active smoker', () {
      notifier.setTakingMedication('Tidak');
      notifier.setSmokingStatus('Merokok aktif');
      notifier.setAlcoholStatus('Tidak pernah');
      notifier.setCigarettesPerDay('0');

      final errors = notifier.validateStep(2);
      expect(errors['cigarettesPerDay'], isNotNull);
    });

    test('step 4 should require confirmation checked', () {
      notifier.setAnesthesiaHistory('Belum pernah');
      notifier.setDrugAllergy('Tidak ada');
      notifier.setTakingMedication('Tidak');
      notifier.setSmokingStatus('Tidak merokok');
      notifier.setAlcoholStatus('Tidak pernah');
      notifier.setConfirmationChecked(false);

      final errors = notifier.validateStep(4);
      expect(errors['confirmationChecked'], isNotNull);
    });
  });
}
