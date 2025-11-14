import 'package:aconsia_app/presentation/dokter/konten/controllers/dokter_konten_impl_provider.dart';
import 'package:aconsia_app/presentation/dokter/konten/domain/usecases/update_konten.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'update_konten_provider.g.dart';

@riverpod
UpdateKonten updateKonten (UpdateKontenRef ref) {
  return UpdateKonten(
    repository: ref.read(dokterKontenRepositoryProvider),
  );
}