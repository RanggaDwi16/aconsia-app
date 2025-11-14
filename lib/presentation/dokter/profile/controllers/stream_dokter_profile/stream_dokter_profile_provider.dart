import 'package:aconsia_app/presentation/dokter/profile/controllers/dokter_profile_impl_provider.dart';
import 'package:aconsia_app/presentation/dokter/profile/domain/usecases/stream_dokter_profile.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'stream_dokter_profile_provider.g.dart';

@riverpod
StreamDokterProfile streamDokterProfile(StreamDokterProfileRef ref) {
  return StreamDokterProfile(
    repository: ref.watch(dokterProfileRepositoryProvider),
  );
}
