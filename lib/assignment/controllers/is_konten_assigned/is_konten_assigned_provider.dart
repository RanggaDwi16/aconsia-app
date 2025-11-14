import 'package:aconsia_app/assignment/controllers/assignment_impl_provider.dart';
import 'package:aconsia_app/assignment/domain/usecases/is_konten_assigned.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'is_konten_assigned_provider.g.dart';

@riverpod
IsKontenAssigned isKontenAssigned  (IsKontenAssignedRef ref) {
  return IsKontenAssigned(
    repository: ref.read(assignmentRepositoryProvider),
  );
}