// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fetch_recommendations_by_keywords_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$fetchRecommendationsByKeywordsHash() =>
    r'177d55b85fe8e76c3101c6598f39520c4eaca417';

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

abstract class _$FetchRecommendationsByKeywords
    extends BuildlessAutoDisposeAsyncNotifier<List<AIRecommendationModel>?> {
  late final String pasienId;
  late final List<String> keywords;

  FutureOr<List<AIRecommendationModel>?> build({
    required String pasienId,
    required List<String> keywords,
  });
}

/// See also [FetchRecommendationsByKeywords].
@ProviderFor(FetchRecommendationsByKeywords)
const fetchRecommendationsByKeywordsProvider =
    FetchRecommendationsByKeywordsFamily();

/// See also [FetchRecommendationsByKeywords].
class FetchRecommendationsByKeywordsFamily
    extends Family<AsyncValue<List<AIRecommendationModel>?>> {
  /// See also [FetchRecommendationsByKeywords].
  const FetchRecommendationsByKeywordsFamily();

  /// See also [FetchRecommendationsByKeywords].
  FetchRecommendationsByKeywordsProvider call({
    required String pasienId,
    required List<String> keywords,
  }) {
    return FetchRecommendationsByKeywordsProvider(
      pasienId: pasienId,
      keywords: keywords,
    );
  }

  @override
  FetchRecommendationsByKeywordsProvider getProviderOverride(
    covariant FetchRecommendationsByKeywordsProvider provider,
  ) {
    return call(
      pasienId: provider.pasienId,
      keywords: provider.keywords,
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
  String? get name => r'fetchRecommendationsByKeywordsProvider';
}

/// See also [FetchRecommendationsByKeywords].
class FetchRecommendationsByKeywordsProvider
    extends AutoDisposeAsyncNotifierProviderImpl<FetchRecommendationsByKeywords,
        List<AIRecommendationModel>?> {
  /// See also [FetchRecommendationsByKeywords].
  FetchRecommendationsByKeywordsProvider({
    required String pasienId,
    required List<String> keywords,
  }) : this._internal(
          () => FetchRecommendationsByKeywords()
            ..pasienId = pasienId
            ..keywords = keywords,
          from: fetchRecommendationsByKeywordsProvider,
          name: r'fetchRecommendationsByKeywordsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$fetchRecommendationsByKeywordsHash,
          dependencies: FetchRecommendationsByKeywordsFamily._dependencies,
          allTransitiveDependencies:
              FetchRecommendationsByKeywordsFamily._allTransitiveDependencies,
          pasienId: pasienId,
          keywords: keywords,
        );

  FetchRecommendationsByKeywordsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.pasienId,
    required this.keywords,
  }) : super.internal();

  final String pasienId;
  final List<String> keywords;

  @override
  FutureOr<List<AIRecommendationModel>?> runNotifierBuild(
    covariant FetchRecommendationsByKeywords notifier,
  ) {
    return notifier.build(
      pasienId: pasienId,
      keywords: keywords,
    );
  }

  @override
  Override overrideWith(FetchRecommendationsByKeywords Function() create) {
    return ProviderOverride(
      origin: this,
      override: FetchRecommendationsByKeywordsProvider._internal(
        () => create()
          ..pasienId = pasienId
          ..keywords = keywords,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        pasienId: pasienId,
        keywords: keywords,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<FetchRecommendationsByKeywords,
      List<AIRecommendationModel>?> createElement() {
    return _FetchRecommendationsByKeywordsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FetchRecommendationsByKeywordsProvider &&
        other.pasienId == pasienId &&
        other.keywords == keywords;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, pasienId.hashCode);
    hash = _SystemHash.combine(hash, keywords.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin FetchRecommendationsByKeywordsRef
    on AutoDisposeAsyncNotifierProviderRef<List<AIRecommendationModel>?> {
  /// The parameter `pasienId` of this provider.
  String get pasienId;

  /// The parameter `keywords` of this provider.
  List<String> get keywords;
}

class _FetchRecommendationsByKeywordsProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<
        FetchRecommendationsByKeywords,
        List<AIRecommendationModel>?> with FetchRecommendationsByKeywordsRef {
  _FetchRecommendationsByKeywordsProviderElement(super.provider);

  @override
  String get pasienId =>
      (origin as FetchRecommendationsByKeywordsProvider).pasienId;
  @override
  List<String> get keywords =>
      (origin as FetchRecommendationsByKeywordsProvider).keywords;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
