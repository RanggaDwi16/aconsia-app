// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fetch_sections_by_konten_id_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$fetchSectionsByKontenIdHash() =>
    r'0ba10664e7c2dcd53d209fd660f79c155308de17';

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

abstract class _$FetchSectionsByKontenId
    extends BuildlessAutoDisposeAsyncNotifier<List<KontenSectionModel>?> {
  late final String kontenId;

  FutureOr<List<KontenSectionModel>?> build({
    required String kontenId,
  });
}

/// See also [FetchSectionsByKontenId].
@ProviderFor(FetchSectionsByKontenId)
const fetchSectionsByKontenIdProvider = FetchSectionsByKontenIdFamily();

/// See also [FetchSectionsByKontenId].
class FetchSectionsByKontenIdFamily
    extends Family<AsyncValue<List<KontenSectionModel>?>> {
  /// See also [FetchSectionsByKontenId].
  const FetchSectionsByKontenIdFamily();

  /// See also [FetchSectionsByKontenId].
  FetchSectionsByKontenIdProvider call({
    required String kontenId,
  }) {
    return FetchSectionsByKontenIdProvider(
      kontenId: kontenId,
    );
  }

  @override
  FetchSectionsByKontenIdProvider getProviderOverride(
    covariant FetchSectionsByKontenIdProvider provider,
  ) {
    return call(
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
  String? get name => r'fetchSectionsByKontenIdProvider';
}

/// See also [FetchSectionsByKontenId].
class FetchSectionsByKontenIdProvider
    extends AutoDisposeAsyncNotifierProviderImpl<FetchSectionsByKontenId,
        List<KontenSectionModel>?> {
  /// See also [FetchSectionsByKontenId].
  FetchSectionsByKontenIdProvider({
    required String kontenId,
  }) : this._internal(
          () => FetchSectionsByKontenId()..kontenId = kontenId,
          from: fetchSectionsByKontenIdProvider,
          name: r'fetchSectionsByKontenIdProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$fetchSectionsByKontenIdHash,
          dependencies: FetchSectionsByKontenIdFamily._dependencies,
          allTransitiveDependencies:
              FetchSectionsByKontenIdFamily._allTransitiveDependencies,
          kontenId: kontenId,
        );

  FetchSectionsByKontenIdProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.kontenId,
  }) : super.internal();

  final String kontenId;

  @override
  FutureOr<List<KontenSectionModel>?> runNotifierBuild(
    covariant FetchSectionsByKontenId notifier,
  ) {
    return notifier.build(
      kontenId: kontenId,
    );
  }

  @override
  Override overrideWith(FetchSectionsByKontenId Function() create) {
    return ProviderOverride(
      origin: this,
      override: FetchSectionsByKontenIdProvider._internal(
        () => create()..kontenId = kontenId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        kontenId: kontenId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<FetchSectionsByKontenId,
      List<KontenSectionModel>?> createElement() {
    return _FetchSectionsByKontenIdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FetchSectionsByKontenIdProvider &&
        other.kontenId == kontenId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, kontenId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin FetchSectionsByKontenIdRef
    on AutoDisposeAsyncNotifierProviderRef<List<KontenSectionModel>?> {
  /// The parameter `kontenId` of this provider.
  String get kontenId;
}

class _FetchSectionsByKontenIdProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<FetchSectionsByKontenId,
        List<KontenSectionModel>?> with FetchSectionsByKontenIdRef {
  _FetchSectionsByKontenIdProviderElement(super.provider);

  @override
  String get kontenId => (origin as FetchSectionsByKontenIdProvider).kontenId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
