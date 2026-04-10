import 'package:aconsia_app/core/main/data/models/pasien_profile_model.dart';
import 'package:aconsia_app/presentation/pasien/profile/controllers/pasien_profile_impl_provider.dart';
import 'package:aconsia_app/presentation/pasien/profile/domain/entities/pasien_profile_failure.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'fetch_pasien_profile_provider.g.dart';

@riverpod
class FetchPasienProfile extends _$FetchPasienProfile {
  @override
  FutureOr<PasienProfileModel?> build({required String pasienId}) async {
    state = const AsyncLoading();

    final pasienProfileRepository = ref.read(pasienProfileRepositoryProvider);

    final result =
        await pasienProfileRepository.getPasienProfile(uid: pasienId);

    return result.fold(
      (failure) {
        final parsedFailure = PasienProfileFailure.fromRaw(failure);
        debugPrint(
          '[PasienProfile] fetch failed | code=${parsedFailure.code.name} | pasienId=$pasienId | message=${parsedFailure.message}',
        );
        state = AsyncError(parsedFailure, StackTrace.current);
        return null;
      },
      (pasienProfile) {
        state = AsyncData(pasienProfile);
        return pasienProfile;
      },
    );
  }
}
