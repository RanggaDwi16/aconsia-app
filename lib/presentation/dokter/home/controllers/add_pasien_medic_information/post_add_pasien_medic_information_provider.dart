import 'package:aconsia_app/core/main/data/models/pasien_profile_model.dart';
import 'package:aconsia_app/presentation/dokter/home/controllers/add_pasien_medic_information/add_pasien_medic_information_provider.dart';
import 'package:aconsia_app/presentation/dokter/home/domain/usecases/add_pasien_medic_information.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'post_add_pasien_medic_information_provider.g.dart';

@Riverpod(keepAlive: true)
class PostAddPasienMedicInformation extends _$PostAddPasienMedicInformation {
  @override
  FutureOr<String?> build() {
    return null;
  }

  Future<void> postAddPasienMedicInformation({
    required String pasienId,
    required PasienProfileModel profile,
    required Function(String message) onSuccess,
    required Function(String error) onError,
  }) async {
    state = const AsyncLoading();

    final addPasienMedicInformation =
        ref.read(addPasienMedicInformationProvider);

    final result = await addPasienMedicInformation(
      AddPasienMedicInformationParams(
        pasienId: pasienId,
        profile: profile,
      ),
    );

    result.fold(
      (failure) {
        state = AsyncError(failure, StackTrace.current);
        onError(failure);
      },
      (message) {
        state = AsyncData(message);
        onSuccess(message);
      },
    );
  }
}
