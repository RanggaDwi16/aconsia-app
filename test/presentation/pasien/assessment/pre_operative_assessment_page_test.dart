import 'dart:async';

import 'package:aconsia_app/core/main/data/models/pasien_profile_model.dart';
import 'package:aconsia_app/presentation/pasien/assessment/pages/pre_operative_assessment_page.dart';
import 'package:aconsia_app/presentation/pasien/profile/controllers/get_pasien_profile/fetch_pasien_profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeFetchPasienProfile extends FetchPasienProfile {
  @override
  FutureOr<PasienProfileModel?> build({required String pasienId}) {
    return PasienProfileModel(
      uid: pasienId,
      namaLengkap: 'Pasien Test',
      klasifikasiAsa: 'ASA II',
    );
  }
}

void main() {
  testWidgets('render step awal asesmen pra-operasi', (tester) async {
    const uid = 'pasien-test-1';

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          currentPasienUidProvider.overrideWithValue(uid),
          fetchPasienProfileProvider(
            pasienId: uid,
          ).overrideWith(_FakeFetchPasienProfile.new),
        ],
        child: const MaterialApp(
          home: PreOperativeAssessmentPage(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Asesmen Pra-Operasi'), findsWidgets);
    expect(find.text('Langkah 1 dari 4'), findsOneWidget);
    expect(
      find.text('Apakah Anda pernah menjalani anestesi sebelumnya? *'),
      findsOneWidget,
    );
  });
}
