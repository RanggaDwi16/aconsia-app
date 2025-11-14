import 'package:aconsia_app/assignment/controllers/assignment_impl_provider.dart';
import 'package:aconsia_app/assignment/domain/usecases/get_assignments_by_pasien.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';


part 'get_assignments_by_pasien_provider.g.dart';

@riverpod
GetAssignmentsByPasien  getAssignmentsByPasien(GetAssignmentsByPasienRef ref) {
  return GetAssignmentsByPasien(
    repository: ref.read(assignmentRepositoryProvider),
  );
}