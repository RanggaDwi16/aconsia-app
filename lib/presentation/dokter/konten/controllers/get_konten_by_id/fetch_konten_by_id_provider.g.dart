// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fetch_konten_by_id_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$fetchKontenByIdHash() => r'59406e3c0f86b4ff294075d7b7b77a2e235be3b9';

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

abstract class _$FetchKontenById
    extends BuildlessAutoDisposeAsyncNotifier<KontenModel?> {
  late final String kontenId;

  FutureOr<KontenModel?> build({
    required String kontenId,
  });
}

/// See also [FetchKontenById].
@ProviderFor(FetchKontenById)
const fetchKontenByIdProvider = FetchKontenByIdFamily();

/// See also [FetchKontenById].
class FetchKontenByIdFamily extends Family<AsyncValue<KontenModel?>> {
  /// See also [FetchKontenById].
  const FetchKontenByIdFamily();

  /// See also [FetchKontenById].
  FetchKontenByIdProvider call({
    required String kontenId,
  }) {
    return FetchKontenByIdProvider(
      kontenId: kontenId,
    );
  }

  @override
  FetchKontenByIdProvider getProviderOverride(
    covariant FetchKontenByIdProvider provider,
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
  String? get name => r'fetchKontenByIdProvider';
}

/// See also [FetchKontenById].
class FetchKontenByIdProvider extends AutoDisposeAsyncNotifierProviderImpl<
    FetchKontenById, KontenModel?> {
  /// See also [FetchKontenById].
  FetchKontenByIdProvider({
    required String kontenId,
  }) : this._internal(
          () => FetchKontenById()..kontenId = kontenId,
          from: fetchKontenByIdProvider,
          name: r'fetchKontenByIdProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$fetchKontenByIdHash,
          dependencies: FetchKontenByIdFamily._dependencies,
          allTransitiveDependencies:
              FetchKontenByIdFamily._allTransitiveDependencies,
          kontenId: kontenId,
        );

  FetchKontenByIdProvider._internal(
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
  FutureOr<KontenModel?> runNotifierBuild(
    covariant FetchKontenById notifier,
  ) {
    return notifier.build(
      kontenId: kontenId,
    );
  }

  @override
  Override overrideWith(FetchKontenById Function() create) {
    return ProviderOverride(
      origin: this,
      override: FetchKontenByIdProvider._internal(
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
  AutoDisposeAsyncNotifierProviderElement<FetchKontenById, KontenModel?>
      createElement() {
    return _FetchKontenByIdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FetchKontenByIdProvider && other.kontenId == kontenId;
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
mixin FetchKontenByIdRef on AutoDisposeAsyncNotifierProviderRef<KontenModel?> {
  /// The parameter `kontenId` of this provider.
  String get kontenId;
}

class _FetchKontenByIdProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<FetchKontenById,
        KontenModel?> with FetchKontenByIdRef {
  _FetchKontenByIdProviderElement(super.provider);

  @override
  String get kontenId => (origin as FetchKontenByIdProvider).kontenId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
