// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fetch_unviewed_recommendations_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$fetchUnviewedRecommendationsHash() =>
    r'c3000d8074f8e5036e9df9ed7b1d7af703e5f0b7';

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

abstract class _$FetchUnviewedRecommendations
    extends BuildlessAutoDisposeAsyncNotifier<List<AIRecommendationModel>?> {
  late final String pasienId;

  FutureOr<List<AIRecommendationModel>?> build({
    required String pasienId,
  });
}

/// See also [FetchUnviewedRecommendations].
@ProviderFor(FetchUnviewedRecommendations)
const fetchUnviewedRecommendationsProvider =
    FetchUnviewedRecommendationsFamily();

/// See also [FetchUnviewedRecommendations].
class FetchUnviewedRecommendationsFamily
    extends Family<AsyncValue<List<AIRecommendationModel>?>> {
  /// See also [FetchUnviewedRecommendations].
  const FetchUnviewedRecommendationsFamily();

  /// See also [FetchUnviewedRecommendations].
  FetchUnviewedRecommendationsProvider call({
    required String pasienId,
  }) {
    return FetchUnviewedRecommendationsProvider(
      pasienId: pasienId,
    );
  }

  @override
  FetchUnviewedRecommendationsProvider getProviderOverride(
    covariant FetchUnviewedRecommendationsProvider provider,
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
  String? get name => r'fetchUnviewedRecommendationsProvider';
}

/// See also [FetchUnviewedRecommendations].
class FetchUnviewedRecommendationsProvider
    extends AutoDisposeAsyncNotifierProviderImpl<FetchUnviewedRecommendations,
        List<AIRecommendationModel>?> {
  /// See also [FetchUnviewedRecommendations].
  FetchUnviewedRecommendationsProvider({
    required String pasienId,
  }) : this._internal(
          () => FetchUnviewedRecommendations()..pasienId = pasienId,
          from: fetchUnviewedRecommendationsProvider,
          name: r'fetchUnviewedRecommendationsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$fetchUnviewedRecommendationsHash,
          dependencies: FetchUnviewedRecommendationsFamily._dependencies,
          allTransitiveDependencies:
              FetchUnviewedRecommendationsFamily._allTransitiveDependencies,
          pasienId: pasienId,
        );

  FetchUnviewedRecommendationsProvider._internal(
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
  FutureOr<List<AIRecommendationModel>?> runNotifierBuild(
    covariant FetchUnviewedRecommendations notifier,
  ) {
    return notifier.build(
      pasienId: pasienId,
    );
  }

  @override
  Override overrideWith(FetchUnviewedRecommendations Function() create) {
    return ProviderOverride(
      origin: this,
      override: FetchUnviewedRecommendationsProvider._internal(
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
  AutoDisposeAsyncNotifierProviderElement<FetchUnviewedRecommendations,
      List<AIRecommendationModel>?> createElement() {
    return _FetchUnviewedRecommendationsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FetchUnviewedRecommendationsProvider &&
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
mixin FetchUnviewedRecommendationsRef
    on AutoDisposeAsyncNotifierProviderRef<List<AIRecommendationModel>?> {
  /// The parameter `pasienId` of this provider.
  String get pasienId;
}

class _FetchUnviewedRecommendationsProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<
        FetchUnviewedRecommendations,
        List<AIRecommendationModel>?> with FetchUnviewedRecommendationsRef {
  _FetchUnviewedRecommendationsProviderElement(super.provider);

  @override
  String get pasienId =>
      (origin as FetchUnviewedRecommendationsProvider).pasienId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
