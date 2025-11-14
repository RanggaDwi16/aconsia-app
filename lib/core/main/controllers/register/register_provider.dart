import 'package:aconsia_app/core/main/controllers/authentciation_impl_provider.dart';
import 'package:aconsia_app/core/main/domain/usecases/register_dokter.dart';
import 'package:aconsia_app/core/main/domain/usecases/register_pasien.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'register_provider.g.dart';

@riverpod
RegisterDokter registerDokter(RegisterDokterRef ref) {
  return RegisterDokter(
    repository: ref.watch(authenticationRepositoryProvider),
  );
}

@riverpod
RegisterPasien registerPasien(RegisterPasienRef ref) {
  return RegisterPasien(
    repository: ref.watch(authenticationRepositoryProvider),
  );
}
