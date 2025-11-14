import 'package:aconsia_app/assignment/controllers/assignment_impl_provider.dart';
import 'package:aconsia_app/assignment/controllers/get_completion_percentage/get_completion_percentage_provider.dart';
import 'package:aconsia_app/assignment/domain/usecases/get_completion_percentage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'fetch_completion_percentage_provider.g.dart';

@riverpod
class FetchCompletionPercentage extends _$FetchCompletionPercentage {
  @override
  FutureOr<double?> build({required String pasienId}) async {
    state = const AsyncLoading();

    GetCompletionPercentage getCompletionPercentageUseCase =
        ref.watch(getCompletionPercentageProvider);

    final result = await getCompletionPercentageUseCase
        .call(GetCompletionPercentageParams(pasienId: pasienId));

    return result.fold(
      (error) {
        state = AsyncError(error, StackTrace.current);
        return null;
      },
      (data) {
        state = AsyncData(data);
        return data;
      },
    );
  }
}
