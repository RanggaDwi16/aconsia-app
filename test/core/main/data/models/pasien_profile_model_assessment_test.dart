import 'package:aconsia_app/core/main/data/models/pasien_profile_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PasienProfileModel assessment fields', () {
    test('fromJson should map assessment fields', () {
      final now = Timestamp.now();
      final model = PasienProfileModel.fromJson({
        'uid': 'u1',
        'assessmentCompleted': true,
        'preOperativeAssessment': {
          'version': 1,
          'data': {'hasDrugAllergy': 'Ada'}
        },
        'preOperativeAssessmentUpdatedAt': now,
      });

      expect(model.assessmentCompleted, isTrue);
      expect(model.preOperativeAssessment, isNotNull);
      expect(
        model.preOperativeAssessment?['data']['hasDrugAllergy'],
        'Ada',
      );
      expect(model.preOperativeAssessmentUpdatedAt, isNotNull);
    });
  });
}
