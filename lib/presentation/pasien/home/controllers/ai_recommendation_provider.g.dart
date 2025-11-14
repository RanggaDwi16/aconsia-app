// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_recommendation_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$fetchAiRecommendationsHash() =>
    r'0ffba27bee275c2096bcce8dc5f209f6b156e096';

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

abstract class _$FetchAiRecommendations
    extends BuildlessAutoDisposeAsyncNotifier<List<RecommendationItem>> {
  late final String pasienId;
  late final int limit;

  FutureOr<List<RecommendationItem>> build({
    required String pasienId,
    int limit = 3,
  });
}

/// Provider to get AI recommendations based on:
/// 1. Unread konten (belum ada quiz result)
/// 2. Keyword matching (pasien AI keywords vs konten AI keywords)
/// 3. Sorted by relevance score
///
/// Copied from [FetchAiRecommendations].
@ProviderFor(FetchAiRecommendations)
const fetchAiRecommendationsProvider = FetchAiRecommendationsFamily();

/// Provider to get AI recommendations based on:
/// 1. Unread konten (belum ada quiz result)
/// 2. Keyword matching (pasien AI keywords vs konten AI keywords)
/// 3. Sorted by relevance score
///
/// Copied from [FetchAiRecommendations].
class FetchAiRecommendationsFamily
    extends Family<AsyncValue<List<RecommendationItem>>> {
  /// Provider to get AI recommendations based on:
  /// 1. Unread konten (belum ada quiz result)
  /// 2. Keyword matching (pasien AI keywords vs konten AI keywords)
  /// 3. Sorted by relevance score
  ///
  /// Copied from [FetchAiRecommendations].
  const FetchAiRecommendationsFamily();

  /// Provider to get AI recommendations based on:
  /// 1. Unread konten (belum ada quiz result)
  /// 2. Keyword matching (pasien AI keywords vs konten AI keywords)
  /// 3. Sorted by relevance score
  ///
  /// Copied from [FetchAiRecommendations].
  FetchAiRecommendationsProvider call({
    required String pasienId,
    int limit = 3,
  }) {
    return FetchAiRecommendationsProvider(
      pasienId: pasienId,
      limit: limit,
    );
  }

  @override
  FetchAiRecommendationsProvider getProviderOverride(
    covariant FetchAiRecommendationsProvider provider,
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
  String? get name => r'fetchAiRecommendationsProvider';
}

/// Provider to get AI recommendations based on:
/// 1. Unread konten (belum ada quiz result)
/// 2. Keyword matching (pasien AI keywords vs konten AI keywords)
/// 3. Sorted by relevance score
///
/// Copied from [FetchAiRecommendations].
class FetchAiRecommendationsProvider
    extends AutoDisposeAsyncNotifierProviderImpl<FetchAiRecommendations,
        List<RecommendationItem>> {
  /// Provider to get AI recommendations based on:
  /// 1. Unread konten (belum ada quiz result)
  /// 2. Keyword matching (pasien AI keywords vs konten AI keywords)
  /// 3. Sorted by relevance score
  ///
  /// Copied from [FetchAiRecommendations].
  FetchAiRecommendationsProvider({
    required String pasienId,
    int limit = 3,
  }) : this._internal(
          () => FetchAiRecommendations()
            ..pasienId = pasienId
            ..limit = limit,
          from: fetchAiRecommendationsProvider,
          name: r'fetchAiRecommendationsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$fetchAiRecommendationsHash,
          dependencies: FetchAiRecommendationsFamily._dependencies,
          allTransitiveDependencies:
              FetchAiRecommendationsFamily._allTransitiveDependencies,
          pasienId: pasienId,
          limit: limit,
        );

  FetchAiRecommendationsProvider._internal(
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
  FutureOr<List<RecommendationItem>> runNotifierBuild(
    covariant FetchAiRecommendations notifier,
  ) {
    return notifier.build(
      pasienId: pasienId,
      limit: limit,
    );
  }

  @override
  Override overrideWith(FetchAiRecommendations Function() create) {
    return ProviderOverride(
      origin: this,
      override: FetchAiRecommendationsProvider._internal(
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
  AutoDisposeAsyncNotifierProviderElement<FetchAiRecommendations,
      List<RecommendationItem>> createElement() {
    return _FetchAiRecommendationsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FetchAiRecommendationsProvider &&
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
mixin FetchAiRecommendationsRef
    on AutoDisposeAsyncNotifierProviderRef<List<RecommendationItem>> {
  /// The parameter `pasienId` of this provider.
  String get pasienId;

  /// The parameter `limit` of this provider.
  int get limit;
}

class _FetchAiRecommendationsProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<FetchAiRecommendations,
        List<RecommendationItem>> with FetchAiRecommendationsRef {
  _FetchAiRecommendationsProviderElement(super.provider);

  @override
  String get pasienId => (origin as FetchAiRecommendationsProvider).pasienId;
  @override
  int get limit => (origin as FetchAiRecommendationsProvider).limit;
}

String _$fetchAllUnreadKontenHash() =>
    r'592ba77a664b8ce9426ed818abe5e472a0bae255';

abstract class _$FetchAllUnreadKonten
    extends BuildlessAutoDisposeAsyncNotifier<List<RecommendationItem>> {
  late final String pasienId;

  FutureOr<List<RecommendationItem>> build({
    required String pasienId,
  });
}

/// Provider to get all unread konten (for All Recommendations page)
///
/// Copied from [FetchAllUnreadKonten].
@ProviderFor(FetchAllUnreadKonten)
const fetchAllUnreadKontenProvider = FetchAllUnreadKontenFamily();

/// Provider to get all unread konten (for All Recommendations page)
///
/// Copied from [FetchAllUnreadKonten].
class FetchAllUnreadKontenFamily
    extends Family<AsyncValue<List<RecommendationItem>>> {
  /// Provider to get all unread konten (for All Recommendations page)
  ///
  /// Copied from [FetchAllUnreadKonten].
  const FetchAllUnreadKontenFamily();

  /// Provider to get all unread konten (for All Recommendations page)
  ///
  /// Copied from [FetchAllUnreadKonten].
  FetchAllUnreadKontenProvider call({
    required String pasienId,
  }) {
    return FetchAllUnreadKontenProvider(
      pasienId: pasienId,
    );
  }

  @override
  FetchAllUnreadKontenProvider getProviderOverride(
    covariant FetchAllUnreadKontenProvider provider,
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
  String? get name => r'fetchAllUnreadKontenProvider';
}

/// Provider to get all unread konten (for All Recommendations page)
///
/// Copied from [FetchAllUnreadKonten].
class FetchAllUnreadKontenProvider extends AutoDisposeAsyncNotifierProviderImpl<
    FetchAllUnreadKonten, List<RecommendationItem>> {
  /// Provider to get all unread konten (for All Recommendations page)
  ///
  /// Copied from [FetchAllUnreadKonten].
  FetchAllUnreadKontenProvider({
    required String pasienId,
  }) : this._internal(
          () => FetchAllUnreadKonten()..pasienId = pasienId,
          from: fetchAllUnreadKontenProvider,
          name: r'fetchAllUnreadKontenProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$fetchAllUnreadKontenHash,
          dependencies: FetchAllUnreadKontenFamily._dependencies,
          allTransitiveDependencies:
              FetchAllUnreadKontenFamily._allTransitiveDependencies,
          pasienId: pasienId,
        );

  FetchAllUnreadKontenProvider._internal(
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
  FutureOr<List<RecommendationItem>> runNotifierBuild(
    covariant FetchAllUnreadKonten notifier,
  ) {
    return notifier.build(
      pasienId: pasienId,
    );
  }

  @override
  Override overrideWith(FetchAllUnreadKonten Function() create) {
    return ProviderOverride(
      origin: this,
      override: FetchAllUnreadKontenProvider._internal(
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
  AutoDisposeAsyncNotifierProviderElement<FetchAllUnreadKonten,
      List<RecommendationItem>> createElement() {
    return _FetchAllUnreadKontenProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FetchAllUnreadKontenProvider && other.pasienId == pasienId;
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
mixin FetchAllUnreadKontenRef
    on AutoDisposeAsyncNotifierProviderRef<List<RecommendationItem>> {
  /// The parameter `pasienId` of this provider.
  String get pasienId;
}

class _FetchAllUnreadKontenProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<FetchAllUnreadKonten,
        List<RecommendationItem>> with FetchAllUnreadKontenRef {
  _FetchAllUnreadKontenProviderElement(super.provider);

  @override
  String get pasienId => (origin as FetchAllUnreadKontenProvider).pasienId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
