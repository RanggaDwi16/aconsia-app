import 'package:aconsia_app/presentation/pasien/assessment/models/pre_operative_assessment_form_data.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PreOperativeAssessmentFormData', () {
    test('should parse stored nested assessment data correctly', () {
      final form = PreOperativeAssessmentFormData.fromStoredAssessment({
        'version': 1,
        'data': {
          'hasAnesthesiaHistory': 'Pernah, ada masalah',
          'anesthesiaComplications': 'Mual berat',
          'hasDrugAllergy': 'Ada',
          'allergyDetails': 'Penisilin',
          'allergyReaction': 'Ruam',
          'takingMedication': 'Ya',
          'medicationList': [
            {'name': 'Metformin', 'dose': '500mg', 'frequency': '2x sehari'},
          ],
          'smokingStatus': 'Merokok aktif',
          'cigarettesPerDay': '8',
          'alcoholStatus': 'Jarang (1-2x/bulan)',
          'drugUse': 'Tidak',
          'hasDiabetes': true,
          'hasHypertension': false,
          'hasAsthma': true,
          'hasHeartDisease': false,
          'hasStroke': false,
          'hasKidneyDisease': false,
          'hasLiverDisease': false,
          'hasEpilepsy': false,
          'otherDiseases': 'GERD',
        },
      });

      expect(form.hasAnesthesiaHistory, 'Pernah, ada masalah');
      expect(form.allergyDetails, 'Penisilin');
      expect(form.medicationList, hasLength(1));
      expect(form.medicationList.first.name, 'Metformin');
      expect(form.hasDiabetes, isTrue);
      expect(form.hasAsthma, isTrue);
      expect(form.otherDiseases, 'GERD');
      expect(form.confirmationChecked, isTrue);
    });

    test('toDataMap should keep medication list shape', () {
      final form = PreOperativeAssessmentFormData.initial().copyWith(
        takingMedication: 'Ya',
        medicationList: const [
          MedicationEntry(name: 'Amlodipine', dose: '5mg', frequency: '1x'),
        ],
      );

      final map = form.toDataMap();
      expect(map['takingMedication'], 'Ya');
      expect(map['medicationList'], isA<List<dynamic>>());
      final meds = map['medicationList'] as List<dynamic>;
      expect(meds, hasLength(1));
      expect((meds.first as Map<String, dynamic>)['name'], 'Amlodipine');
    });
  });
}
