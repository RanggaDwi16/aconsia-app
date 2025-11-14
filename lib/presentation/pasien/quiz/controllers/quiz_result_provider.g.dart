// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quiz_result_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$saveQuizResultHash() => r'8069335b99882b393edfdcb23c153d510fa0a057';

/// Save quiz result to Firestore
///
/// Copied from [SaveQuizResult].
@ProviderFor(SaveQuizResult)
final saveQuizResultProvider =
    AsyncNotifierProvider<SaveQuizResult, String?>.internal(
  SaveQuizResult.new,
  name: r'saveQuizResultProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$saveQuizResultHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SaveQuizResult = AsyncNotifier<String?>;
String _$fetchQuizResultByKontenHash() =>
    r'6f2e0091506cd2538870e9bffdf9ac0e6e5a722a';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$FetchQuizResultByKonten
    extends BuildlessAutoDisposeAsyncNotifier<QuizResultModel?> {
  late final String pasienId;
  late final String kontenId;

  FutureOr<QuizResultModel?> build({
    required String pasienId,
    required String kontenId,
  });
}

/// Fetch quiz result by konten + pasien
///
/// Copied from [FetchQuizResultByKonten].
@ProviderFor(FetchQuizResultByKonten)
const fetchQuizResultByKontenProvider = FetchQuizResultByKontenFamily();

/// Fetch quiz result by konten + pasien
///
/// Copied from [FetchQuizResultByKonten].
class FetchQuizResultByKontenFamily
    extends Family<AsyncValue<QuizResultModel?>> {
  /// Fetch quiz result by konten + pasien
  ///
  /// Copied from [FetchQuizResultByKonten].
  const FetchQuizResultByKontenFamily();

  /// Fetch quiz result by konten + pasien
  ///
  /// Copied from [FetchQuizResultByKonten].
  FetchQuizResultByKontenProvider call({
    required String pasienId,
    required String kontenId,
  }) {
    return FetchQuizResultByKontenProvider(
      pasienId: pasienId,
      kontenId: kontenId,
    );
  }

  @override
  FetchQuizResultByKontenProvider getProviderOverride(
    covariant FetchQuizResultByKontenProvider provider,
  ) {
    return call(
      pasienId: provider.pasienId,
      kontenId: provider.kontenId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'fetchQuizResultByKontenProvider';
}

/// Fetch quiz result by konten + pasien
///
/// Copied from [FetchQuizResultByKonten].
class FetchQuizResultByKontenProvider
    extends AutoDisposeAsyncNotifierProviderImpl<FetchQuizResultByKonten,
        QuizResultModel?> {
  /// Fetch quiz result by konten + pasien
  ///
  /// Copied from [FetchQuizResultByKonten].
  FetchQuizResultByKontenProvider({
    required String pasienId,
    required String kontenId,
  }) : this._internal(
          () => FetchQuizResultByKonten()
            ..pasienId = pasienId
            ..kontenId = kontenId,
          from: fetchQuizResultByKontenProvider,
          name: r'fetchQuizResultByKontenProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$fetchQuizResultByKontenHash,
          dependencies: FetchQuizResultByKontenFamily._dependencies,
          allTransitiveDependencies:
              FetchQuizResultByKontenFamily._allTransitiveDependencies,
          pasienId: pasienId,
          kontenId: kontenId,
        );

  FetchQuizResultByKontenProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.pasienId,
    required this.kontenId,
  }) : super.internal();

  final String pasienId;
  final String kontenId;

  @override
  FutureOr<QuizResultModel?> runNotifierBuild(
    covariant FetchQuizResultByKonten notifier,
  ) {
    return notifier.build(
      pasienId: pasienId,
      kontenId: kontenId,
    );
  }

  @override
  Override overrideWith(FetchQuizResultByKonten Function() create) {
    return ProviderOverride(
      origin: this,
      override: FetchQuizResultByKontenProvider._internal(
        () => create()
          ..pasienId = pasienId
          ..kontenId = kontenId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        pasienId: pasienId,
        kontenId: kontenId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<FetchQuizResultByKonten,
      QuizResultModel?> createElement() {
    return _FetchQuizResultByKontenProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FetchQuizResultByKontenProvider &&
        other.pasienId == pasienId &&
        other.kontenId == kontenId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, pasienId.hashCode);
    hash = _SystemHash.combine(hash, kontenId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin FetchQuizResultByKontenRef
    on AutoDisposeAsyncNotifierProviderRef<QuizResultModel?> {
  /// The parameter `pasienId` of this provider.
  String get pasienId;

  /// The parameter `kontenId` of this provider.
  String get kontenId;
}

class _FetchQuizResultByKontenProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<FetchQuizResultByKonten,
        QuizResultModel?> with FetchQuizResultByKontenRef {
  _FetchQuizResultByKontenProviderElement(super.provider);

  @override
  String get pasienId => (origin as FetchQuizResultByKontenProvider).pasienId;
  @override
  String get kontenId => (origin as FetchQuizResultByKontenProvider).kontenId;
}

String _$fetchAllQuizResultsHash() =>
    r'6887c0ec88ae8025d01909dbd27cf76b16672ac3';

abstract class _$FetchAllQuizResults
    extends BuildlessAutoDisposeAsyncNotifier<List<QuizResultModel>> {
  late final String pasienId;

  FutureOr<List<QuizResultModel>> build({
    required String pasienId,
  });
}

/// Fetch all quiz results for pasien
///
/// Copied from [FetchAllQuizResults].
@ProviderFor(FetchAllQuizResults)
const fetchAllQuizResultsProvider = FetchAllQuizResultsFamily();

/// Fetch all quiz results for pasien
///
/// Copied from [FetchAllQuizResults].
class FetchAllQuizResultsFamily
    extends Family<AsyncValue<List<QuizResultModel>>> {
  /// Fetch all quiz results for pasien
  ///
  /// Copied from [FetchAllQuizResults].
  const FetchAllQuizResultsFamily();

  /// Fetch all quiz results for pasien
  ///
  /// Copied from [FetchAllQuizResults].
  FetchAllQuizResultsProvider call({
    required String pasienId,
  }) {
    return FetchAllQuizResultsProvider(
      pasienId: pasienId,
    );
  }

  @override
  FetchAllQuizResultsProvider getProviderOverride(
    covariant FetchAllQuizResultsProvider provider,
  ) {
    return call(
      pasienId: provider.pasienId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'fetchAllQuizResultsProvider';
}

/// Fetch all quiz results for pasien
///
/// Copied from [FetchAllQuizResults].
class FetchAllQuizResultsProvider extends AutoDisposeAsyncNotifierProviderImpl<
    FetchAllQuizResults, List<QuizResultModel>> {
  /// Fetch all quiz results for pasien
  ///
  /// Copied from [FetchAllQuizResults].
  FetchAllQuizResultsProvider({
    required String pasienId,
  }) : this._internal(
          () => FetchAllQuizResults()..pasienId = pasienId,
          from: fetchAllQuizResultsProvider,
          name: r'fetchAllQuizResultsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$fetchAllQuizResultsHash,
          dependencies: FetchAllQuizResultsFamily._dependencies,
          allTransitiveDependencies:
              FetchAllQuizResultsFamily._allTransitiveDependencies,
          pasienId: pasienId,
        );

  FetchAllQuizResultsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.pasienId,
  }) : super.internal();

  final String pasienId;

  @override
  FutureOr<List<QuizResultModel>> runNotifierBuild(
    covariant FetchAllQuizResults notifier,
  ) {
    return notifier.build(
      pasienId: pasienId,
    );
  }

  @override
  Override overrideWith(FetchAllQuizResults Function() create) {
    return ProviderOverride(
      origin: this,
      override: FetchAllQuizResultsProvider._internal(
        () => create()..pasienId = pasienId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        pasienId: pasienId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<FetchAllQuizResults,
      List<QuizResultModel>> createElement() {
    return _FetchAllQuizResultsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FetchAllQuizResultsProvider && other.pasienId == pasienId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, pasienId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin FetchAllQuizResultsRef
    on AutoDisposeAsyncNotifierProviderRef<List<QuizResultModel>> {
  /// The parameter `pasienId` of this provider.
  String get pasienId;
}

class _FetchAllQuizResultsProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<FetchAllQuizResults,
        List<QuizResultModel>> with FetchAllQuizResultsRef {
  _FetchAllQuizResultsProviderElement(super.provider);

  @override
  String get pasienId => (origin as FetchAllQuizResultsProvider).pasienId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
