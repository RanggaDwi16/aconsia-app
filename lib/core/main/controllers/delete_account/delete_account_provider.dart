import 'package:aconsia_app/core/main/controllers/authentciation_impl_provider.dart';
import 'package:aconsia_app/core/main/domain/usecases/delete_account.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'delete_account_provider.g.dart';

@riverpod
DeleteAccount deleteAccount(DeleteAccountRef ref) {
  return DeleteAccount(repository: ref.watch(authenticationRepositoryProvider));
}
