import 'package:aconsia_app/ai/data/datasources/ai_remote_data_source.dart';
import 'package:aconsia_app/ai/data/repositories/ai_repository_impl.dart';
import 'package:aconsia_app/ai/domain/repository/ai_repository.dart';
import 'package:aconsia_app/core/providers/firebase_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ai_impl_provider.g.dart';

@riverpod
AiRepository aiRepository(AiRepositoryRef ref) {
  return AiRepositoryImpl(
    remoteDataSource: AiRemoteDataSourceImpl(
      firestore: ref.read(firebaseFirestoreProvider),
    ),
  );
}
