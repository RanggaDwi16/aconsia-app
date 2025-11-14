import 'package:aconsia_app/presentation/dokter/home/controllers/home_impl_provider.dart';
import 'package:aconsia_app/presentation/dokter/home/domain/usecases/add_pasien_medic_information.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'add_pasien_medic_information_provider.g.dart';

@riverpod
AddPasienMedicInformation addPasienMedicInformation(
    AddPasienMedicInformationRef ref) {
  return AddPasienMedicInformation(
    repository: ref.read(homeRepositoryProvider),
  );
}
