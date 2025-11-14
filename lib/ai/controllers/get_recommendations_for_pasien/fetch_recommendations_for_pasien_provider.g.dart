// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fetch_recommendations_for_pasien_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$fetchRecommendationsForPasienHash() =>
    r'c77d20909f2bda4e7e693dc45e0e929b4904dc2a';

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

abstract class _$FetchRecommendationsForPasien
    extends BuildlessAutoDisposeAsyncNotifier<List<AIRecommendationModel>?> {
  late final String pasienId;
  late final int limit;

  FutureOr<List<AIRecommendationModel>?> build({
    required String pasienId,
    int limit = 10,
  });
}

/// See also [FetchRecommendationsForPasien].
@ProviderFor(FetchRecommendationsForPasien)
const fetchRecommendationsForPasienProvider =
    FetchRecommendationsForPasienFamily();

/// See also [FetchRecommendationsForPasien].
class FetchRecommendationsForPasienFamily
    extends Family<AsyncValue<List<AIRecommendationModel>?>> {
  /// See also [FetchRecommendationsForPasien].
  const FetchRecommendationsForPasienFamily();

  /// See also [FetchRecommendationsForPasien].
  FetchRecommendationsForPasienProvider call({
    required String pasienId,
    int limit = 10,
  }) {
    return FetchRecommendationsForPasienProvider(
      pasienId: pasienId,
      limit: limit,
    );
  }

  @override
  FetchRecommendationsForPasienProvider getProviderOverride(
    covariant FetchRecommendationsForPasienProvider provider,
  ) {
    return call(
      pasienId: provider.pasienId,
      limit: provider.limit,
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
  String? get name => r'fetchRecommendationsForPasienProvider';
}

/// See also [FetchRecommendationsForPasien].
class FetchRecommendationsForPasienProvider
    extends AutoDisposeAsyncNotifierProviderImpl<FetchRecommendationsForPasien,
        List<AIRecommendationModel>?> {
  /// See also [FetchRecommendationsForPasien].
  FetchRecommendationsForPasienProvider({
    required String pasienId,
    int limit = 10,
  }) : this._internal(
          () => FetchRecommendationsForPasien()
            ..pasienId = pasienId
            ..limit = limit,
          from: fetchRecommendationsForPasienProvider,
          name: r'fetchRecommendationsForPasienProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$fetchRecommendationsForPasienHash,
          dependencies: FetchRecommendationsForPasienFamily._dependencies,
          allTransitiveDependencies:
              FetchRecommendationsForPasienFamily._allTransitiveDependencies,
          pasienId: pasienId,
          limit: limit,
        );

  FetchRecommendationsForPasienProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.pasienId,
    required this.limit,
  }) : super.internal();

  final String pasienId;
  final int limit;

  @override
  FutureOr<List<AIRecommendationModel>?> runNotifierBuild(
    covariant FetchRecommendationsForPasien notifier,
  ) {
    return notifier.build(
      pasienId: pasienId,
      limit: limit,
    );
  }

  @override
  Override overrideWith(FetchRecommendationsForPasien Function() create) {
    return ProviderOverride(
      origin: this,
      override: FetchRecommendationsForPasienProvider._internal(
        () => create()
          ..pasienId = pasienId
          ..limit = limit,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        pasienId: pasienId,
        limit: limit,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<FetchRecommendationsForPasien,
      List<AIRecommendationModel>?> createElement() {
    return _FetchRecommendationsForPasienProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FetchRecommendationsForPasienProvider &&
        other.pasienId == pasienId &&
        other.limit == limit;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, pasienId.hashCode);
    hash = _SystemHash.combine(hash, limit.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin FetchRecommendationsForPasienRef
    on AutoDisposeAsyncNotifierProviderRef<List<AIRecommendationModel>?> {
  /// The parameter `pasienId` of this provider.
  String get pasienId;

  /// The parameter `limit` of this provider.
  int get limit;
}

class _FetchRecommendationsForPasienProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<
        FetchRecommendationsForPasien,
        List<AIRecommendationModel>?> with FetchRecommendationsForPasienRef {
  _FetchRecommendationsForPasienProviderElement(super.provider);

  @override
  String get pasienId =>
      (origin as FetchRecommendationsForPasienProvider).pasienId;
  @override
  int get limit => (origin as FetchRecommendationsForPasienProvider).limit;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
