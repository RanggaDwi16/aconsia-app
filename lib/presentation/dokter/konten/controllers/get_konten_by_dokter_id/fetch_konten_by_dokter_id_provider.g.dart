// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fetch_konten_by_dokter_id_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$fetchKontenByDokterIdHash() =>
    r'6e155f95e6727f861641d1b5fd4fe0c9f2887ef4';

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

abstract class _$FetchKontenByDokterId
    extends BuildlessAutoDisposeAsyncNotifier<List<KontenModel>?> {
  late final String dokterId;

  FutureOr<List<KontenModel>?> build({
    required String dokterId,
  });
}

/// See also [FetchKontenByDokterId].
@ProviderFor(FetchKontenByDokterId)
const fetchKontenByDokterIdProvider = FetchKontenByDokterIdFamily();

/// See also [FetchKontenByDokterId].
class FetchKontenByDokterIdFamily
    extends Family<AsyncValue<List<KontenModel>?>> {
  /// See also [FetchKontenByDokterId].
  const FetchKontenByDokterIdFamily();

  /// See also [FetchKontenByDokterId].
  FetchKontenByDokterIdProvider call({
    required String dokterId,
  }) {
    return FetchKontenByDokterIdProvider(
      dokterId: dokterId,
    );
  }

  @override
  FetchKontenByDokterIdProvider getProviderOverride(
    covariant FetchKontenByDokterIdProvider provider,
  ) {
    return call(
      dokterId: provider.dokterId,
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
  String? get name => r'fetchKontenByDokterIdProvider';
}

/// See also [FetchKontenByDokterId].
class FetchKontenByDokterIdProvider
    extends AutoDisposeAsyncNotifierProviderImpl<FetchKontenByDokterId,
        List<KontenModel>?> {
  /// See also [FetchKontenByDokterId].
  FetchKontenByDokterIdProvider({
    required String dokterId,
  }) : this._internal(
          () => FetchKontenByDokterId()..dokterId = dokterId,
          from: fetchKontenByDokterIdProvider,
          name: r'fetchKontenByDokterIdProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$fetchKontenByDokterIdHash,
          dependencies: FetchKontenByDokterIdFamily._dependencies,
          allTransitiveDependencies:
              FetchKontenByDokterIdFamily._allTransitiveDependencies,
          dokterId: dokterId,
        );

  FetchKontenByDokterIdProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.dokterId,
  }) : super.internal();

  final String dokterId;

  @override
  FutureOr<List<KontenModel>?> runNotifierBuild(
    covariant FetchKontenByDokterId notifier,
  ) {
    return notifier.build(
      dokterId: dokterId,
    );
  }

  @override
  Override overrideWith(FetchKontenByDokterId Function() create) {
    return ProviderOverride(
      origin: this,
      override: FetchKontenByDokterIdProvider._internal(
        () => create()..dokterId = dokterId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        dokterId: dokterId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<FetchKontenByDokterId,
      List<KontenModel>?> createElement() {
    return _FetchKontenByDokterIdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FetchKontenByDokterIdProvider && other.dokterId == dokterId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, dokterId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin FetchKontenByDokterIdRef
    on AutoDisposeAsyncNotifierProviderRef<List<KontenModel>?> {
  /// The parameter `dokterId` of this provider.
  String get dokterId;
}

class _FetchKontenByDokterIdProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<FetchKontenByDokterId,
        List<KontenModel>?> with FetchKontenByDokterIdRef {
  _FetchKontenByDokterIdProviderElement(super.provider);

  @override
  String get dokterId => (origin as FetchKontenByDokterIdProvider).dokterId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
