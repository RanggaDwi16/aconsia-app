// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fetch_pasien_list_by_dokter_id_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$fetchPasienListByDokterIdHash() =>
    r'406d5fec241e09f81eb43993bb6b65d692fe8244';

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

abstract class _$FetchPasienListByDokterId
    extends BuildlessAutoDisposeAsyncNotifier<List<PasienProfileModel>?> {
  late final String dokterId;

  FutureOr<List<PasienProfileModel>?> build({
    required String dokterId,
  });
}

/// See also [FetchPasienListByDokterId].
@ProviderFor(FetchPasienListByDokterId)
const fetchPasienListByDokterIdProvider = FetchPasienListByDokterIdFamily();

/// See also [FetchPasienListByDokterId].
class FetchPasienListByDokterIdFamily
    extends Family<AsyncValue<List<PasienProfileModel>?>> {
  /// See also [FetchPasienListByDokterId].
  const FetchPasienListByDokterIdFamily();

  /// See also [FetchPasienListByDokterId].
  FetchPasienListByDokterIdProvider call({
    required String dokterId,
  }) {
    return FetchPasienListByDokterIdProvider(
      dokterId: dokterId,
    );
  }

  @override
  FetchPasienListByDokterIdProvider getProviderOverride(
    covariant FetchPasienListByDokterIdProvider provider,
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
  String? get name => r'fetchPasienListByDokterIdProvider';
}

/// See also [FetchPasienListByDokterId].
class FetchPasienListByDokterIdProvider
    extends AutoDisposeAsyncNotifierProviderImpl<FetchPasienListByDokterId,
        List<PasienProfileModel>?> {
  /// See also [FetchPasienListByDokterId].
  FetchPasienListByDokterIdProvider({
    required String dokterId,
  }) : this._internal(
          () => FetchPasienListByDokterId()..dokterId = dokterId,
          from: fetchPasienListByDokterIdProvider,
          name: r'fetchPasienListByDokterIdProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$fetchPasienListByDokterIdHash,
          dependencies: FetchPasienListByDokterIdFamily._dependencies,
          allTransitiveDependencies:
              FetchPasienListByDokterIdFamily._allTransitiveDependencies,
          dokterId: dokterId,
        );

  FetchPasienListByDokterIdProvider._internal(
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
  FutureOr<List<PasienProfileModel>?> runNotifierBuild(
    covariant FetchPasienListByDokterId notifier,
  ) {
    return notifier.build(
      dokterId: dokterId,
    );
  }

  @override
  Override overrideWith(FetchPasienListByDokterId Function() create) {
    return ProviderOverride(
      origin: this,
      override: FetchPasienListByDokterIdProvider._internal(
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
  AutoDisposeAsyncNotifierProviderElement<FetchPasienListByDokterId,
      List<PasienProfileModel>?> createElement() {
    return _FetchPasienListByDokterIdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FetchPasienListByDokterIdProvider &&
        other.dokterId == dokterId;
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
mixin FetchPasienListByDokterIdRef
    on AutoDisposeAsyncNotifierProviderRef<List<PasienProfileModel>?> {
  /// The parameter `dokterId` of this provider.
  String get dokterId;
}

class _FetchPasienListByDokterIdProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<FetchPasienListByDokterId,
        List<PasienProfileModel>?> with FetchPasienListByDokterIdRef {
  _FetchPasienListByDokterIdProviderElement(super.provider);

  @override
  String get dokterId => (origin as FetchPasienListByDokterIdProvider).dokterId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
