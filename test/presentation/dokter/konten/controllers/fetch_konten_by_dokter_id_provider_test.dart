import 'package:aconsia_app/core/main/data/models/konten_model.dart';
import 'package:aconsia_app/presentation/dokter/konten/controllers/get_konten_by_dokter_id/fetch_konten_by_dokter_id_provider.dart';
import 'package:aconsia_app/presentation/dokter/konten/controllers/get_konten_by_dokter_id/get_konten_by_dokter_id_provider.dart';
import 'package:aconsia_app/presentation/dokter/konten/domain/repository/dokter_konten_repository.dart';
import 'package:aconsia_app/presentation/dokter/konten/domain/usecases/get_konten_by_dokter_id.dart';
import 'package:aconsia_app/core/main/data/models/konten_section_model.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _DummyRepo implements DokterKontenRepository {
  @override
  Future<Either<String, String>> createKonten({
    required KontenModel konten,
    required List<KontenSectionModel> sections,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<Either<String, String>> deleteKonten({required String kontenId}) {
    throw UnimplementedError();
  }

  @override
  Future<Either<String, List<KontenModel>>> getKontenByDokterId({
    required String dokterId,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<Either<String, KontenModel>> getKontenById({required String kontenId}) {
    throw UnimplementedError();
  }

  @override
  Future<Either<String, int>> getKontenCountByDokterId({
    required String dokterId,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<Either<String, List<KontenSectionModel>>> getSectionsByKontenId({
    required String kontenId,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<Either<String, String>> updateKonten({
    required KontenModel konten,
    required KontenSectionModel section,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<Either<String, String>> updateSection({
    required KontenSectionModel section,
  }) {
    throw UnimplementedError();
  }
}

class _SuccessUseCase extends GetKontenByDokterId {
  _SuccessUseCase() : super(repository: _DummyRepo());

  @override
  Future<Either<String, List<KontenModel>>> call(
    GetKontenByDokterIdParams params,
  ) async {
    return const Right([
      KontenModel(
        id: 'k1',
        dokterId: 'd1',
        judul: 'Konten Sukses',
      ),
    ]);
  }
}

class _FailureUseCase extends GetKontenByDokterId {
  _FailureUseCase() : super(repository: _DummyRepo());

  @override
  Future<Either<String, List<KontenModel>>> call(
    GetKontenByDokterIdParams params,
  ) async {
    return const Left('Gagal ambil konten');
  }
}

void main() {
  test('returns data on success', () async {
    final container = ProviderContainer(
      overrides: [
        getKontenByDokterIdProvider.overrideWithValue(_SuccessUseCase()),
      ],
    );
    addTearDown(container.dispose);

    final result = await container.read(
      fetchKontenByDokterIdProvider(dokterId: 'd1').future,
    );

    expect(result.length, 1);
    expect(result.first.judul, 'Konten Sukses');
  });

  test('throws on failure so UI receives AsyncError', () async {
    final container = ProviderContainer(
      overrides: [
        getKontenByDokterIdProvider.overrideWithValue(_FailureUseCase()),
      ],
    );
    addTearDown(container.dispose);

    expect(
      container.read(fetchKontenByDokterIdProvider(dokterId: 'd1').future),
      throwsA(isA<Exception>()),
    );
  });
}
