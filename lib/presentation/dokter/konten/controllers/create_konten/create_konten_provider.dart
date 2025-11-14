import 'package:aconsia_app/presentation/dokter/konten/controllers/dokter_konten_impl_provider.dart';
import 'package:aconsia_app/presentation/dokter/konten/domain/usecases/create_konten.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'create_konten_provider.g.dart';

@riverpod
CreateKonten createKonten(CreateKontenRef ref) {
  return CreateKonten(
    repository: ref.read(dokterKontenRepositoryProvider),
  );
}
