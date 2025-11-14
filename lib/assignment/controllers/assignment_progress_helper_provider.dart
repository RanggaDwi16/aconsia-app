import 'package:aconsia_app/assignment/controllers/assignment_impl_provider.dart';
import 'package:aconsia_app/assignment/controllers/get_assignments_by_pasien/fetch_assignments_by_pasien_provider.dart';
import 'package:aconsia_app/assignment/controllers/update_current_bagian/post_update_current_bagian_provider.dart';
import 'package:aconsia_app/assignment/domain/usecases/update_current_bagian.dart';
import 'package:aconsia_app/core/main/data/models/konten_assignment_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'assignment_progress_helper_provider.g.dart';

/// Provider to check if konten is assigned and get assignment
@riverpod
Future<KontenAssignmentModel?> checkKontenAssignment(
  CheckKontenAssignmentRef ref, {
  required String pasienId,
  required String kontenId,
}) async {
  final repository = ref.read(assignmentRepositoryProvider);
  final result = await repository.isKontenAssigned(
    pasienId: pasienId,
    kontenId: kontenId,
  );

  return result.fold(
    (error) => null,
    (isAssigned) async {
      if (isAssigned) {
        // Get all assignments for this pasien
        final assignmentsResult = await repository.getAssignmentsByPasien(
          pasienId: pasienId,
        );

        return assignmentsResult.fold(
          (error) => null,
          (assignments) {
            // Find assignment for this konten
            try {
              return assignments.firstWhere(
                (assignment) => assignment.kontenId == kontenId,
              );
            } catch (e) {
              return null;
            }
          },
        );
      }
      return null;
    },
  );
}

/// Provider to update assignment progress
@riverpod
class UpdateAssignmentProgress extends _$UpdateAssignmentProgress {
  @override
  FutureOr<String?> build() {
    return null;
  }

  Future<void> updateProgress({
    required String assignmentId,
    required int newBagian,
    required String pasienId,
  }) async {
    state = const AsyncLoading();

    try {
      await ref
          .read(postUpdateCurrentBagianProvider.notifier)
          .postUpdateCurrentBagian(
            params: UpdateCurrentBagianParams(
              assignmentId: assignmentId,
              bagianNumber: newBagian,
            ),
            onSuccess: (message) {
              state = AsyncData(message);
              // Invalidate assignments list to refresh UI
              ref.invalidate(
                  fetchAssignmentsByPasienProvider(pasienId: pasienId));
            },
            onError: (error) {
              state = AsyncError(error, StackTrace.current);
            },
          );
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }
}
