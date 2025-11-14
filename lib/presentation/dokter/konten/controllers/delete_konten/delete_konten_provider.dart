import 'package:aconsia_app/presentation/dokter/konten/controllers/dokter_konten_impl_provider.dart';
import 'package:aconsia_app/presentation/dokter/konten/domain/usecases/delete_konten.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'delete_konten_provider.g.dart';

@riverpod
DeleteKonten deleteKonten(DeleteKontenRef ref) {
  return DeleteKonten(
    repository: ref.read(dokterKontenRepositoryProvider),
  );
}
