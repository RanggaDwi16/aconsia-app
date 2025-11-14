import 'package:aconsia_app/assignment/controllers/assignment_impl_provider.dart';
import 'package:aconsia_app/assignment/domain/usecases/update_current_bagian.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'update_current_bagian_provider.g.dart';

@riverpod
UpdateCurrentBagian updateCurrentBagian (UpdateCurrentBagianRef ref) {
  return UpdateCurrentBagian(
    repository: ref.read(assignmentRepositoryProvider),
  );
}