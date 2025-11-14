import 'package:aconsia_app/assignment/data/datasources/assignment_remote_data_source.dart';
import 'package:aconsia_app/assignment/data/repositories/assignment_repository_impl.dart';
import 'package:aconsia_app/assignment/domain/repository/assignment_repository.dart';
import 'package:aconsia_app/core/providers/firebase_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'assignment_impl_provider.g.dart';

@riverpod
AssignmentRepository assignmentRepository(AssignmentRepositoryRef ref) {
  return AssignmentRepositoryImpl(
    remoteDataSource: AssignmentRemoteDataSourceImpl(
      firestore: ref.read(firebaseFirestoreProvider),
    ),
  );
}
