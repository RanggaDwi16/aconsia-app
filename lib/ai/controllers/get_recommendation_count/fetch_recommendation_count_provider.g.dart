// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fetch_recommendation_count_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$fetchRecommendationCountHash() =>
    r'7afa9b60a36e4adb73b0cc702d007514671cb02c';

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

abstract class _$FetchRecommendationCount
    extends BuildlessAutoDisposeAsyncNotifier<int?> {
  late final String pasienId;

  FutureOr<int?> build({
    required String pasienId,
  });
}

/// See also [FetchRecommendationCount].
@ProviderFor(FetchRecommendationCount)
const fetchRecommendationCountProvider = FetchRecommendationCountFamily();

/// See also [FetchRecommendationCount].
class FetchRecommendationCountFamily extends Family<AsyncValue<int?>> {
  /// See also [FetchRecommendationCount].
  const FetchRecommendationCountFamily();

  /// See also [FetchRecommendationCount].
  FetchRecommendationCountProvider call({
    required String pasienId,
  }) {
    return FetchRecommendationCountProvider(
      pasienId: pasienId,
    );
  }

  @override
  FetchRecommendationCountProvider getProviderOverride(
    covariant FetchRecommendationCountProvider provider,
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
  String? get name => r'fetchRecommendationCountProvider';
}

/// See also [FetchRecommendationCount].
class FetchRecommendationCountProvider
    extends AutoDisposeAsyncNotifierProviderImpl<FetchRecommendationCount,
        int?> {
  /// See also [FetchRecommendationCount].
  FetchRecommendationCountProvider({
    required String pasienId,
  }) : this._internal(
          () => FetchRecommendationCount()..pasienId = pasienId,
          from: fetchRecommendationCountProvider,
          name: r'fetchRecommendationCountProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$fetchRecommendationCountHash,
          dependencies: FetchRecommendationCountFamily._dependencies,
          allTransitiveDependencies:
              FetchRecommendationCountFamily._allTransitiveDependencies,
          pasienId: pasienId,
        );

  FetchRecommendationCountProvider._internal(
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
  FutureOr<int?> runNotifierBuild(
    covariant FetchRecommendationCount notifier,
  ) {
    return notifier.build(
      pasienId: pasienId,
    );
  }

  @override
  Override overrideWith(FetchRecommendationCount Function() create) {
    return ProviderOverride(
      origin: this,
      override: FetchRecommendationCountProvider._internal(
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
  AutoDisposeAsyncNotifierProviderElement<FetchRecommendationCount, int?>
      createElement() {
    return _FetchRecommendationCountProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FetchRecommendationCountProvider &&
        other.pasienId == pasienId;
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
mixin FetchRecommendationCountRef on AutoDisposeAsyncNotifierProviderRef<int?> {
  /// The parameter `pasienId` of this provider.
  String get pasienId;
}

class _FetchRecommendationCountProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<FetchRecommendationCount,
        int?> with FetchRecommendationCountRef {
  _FetchRecommendationCountProviderElement(super.provider);

  @override
  String get pasienId => (origin as FetchRecommendationCountProvider).pasienId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
