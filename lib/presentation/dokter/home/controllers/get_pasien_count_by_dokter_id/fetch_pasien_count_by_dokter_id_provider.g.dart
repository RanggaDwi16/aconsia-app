// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fetch_pasien_count_by_dokter_id_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$fetchPasienCountByDokterIdHash() =>
    r'e337f7dd4c10c6b2ef27a6b107d36fe8531415f5';

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

abstract class _$FetchPasienCountByDokterId
    extends BuildlessAutoDisposeAsyncNotifier<int?> {
  late final String dokterId;

  FutureOr<int?> build({
    required String dokterId,
  });
}

/// See also [FetchPasienCountByDokterId].
@ProviderFor(FetchPasienCountByDokterId)
const fetchPasienCountByDokterIdProvider = FetchPasienCountByDokterIdFamily();

/// See also [FetchPasienCountByDokterId].
class FetchPasienCountByDokterIdFamily extends Family<AsyncValue<int?>> {
  /// See also [FetchPasienCountByDokterId].
  const FetchPasienCountByDokterIdFamily();

  /// See also [FetchPasienCountByDokterId].
  FetchPasienCountByDokterIdProvider call({
    required String dokterId,
  }) {
    return FetchPasienCountByDokterIdProvider(
      dokterId: dokterId,
    );
  }

  @override
  FetchPasienCountByDokterIdProvider getProviderOverride(
    covariant FetchPasienCountByDokterIdProvider provider,
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
  String? get name => r'fetchPasienCountByDokterIdProvider';
}

/// See also [FetchPasienCountByDokterId].
class FetchPasienCountByDokterIdProvider
    extends AutoDisposeAsyncNotifierProviderImpl<FetchPasienCountByDokterId,
        int?> {
  /// See also [FetchPasienCountByDokterId].
  FetchPasienCountByDokterIdProvider({
    required String dokterId,
  }) : this._internal(
          () => FetchPasienCountByDokterId()..dokterId = dokterId,
          from: fetchPasienCountByDokterIdProvider,
          name: r'fetchPasienCountByDokterIdProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$fetchPasienCountByDokterIdHash,
          dependencies: FetchPasienCountByDokterIdFamily._dependencies,
          allTransitiveDependencies:
              FetchPasienCountByDokterIdFamily._allTransitiveDependencies,
          dokterId: dokterId,
        );

  FetchPasienCountByDokterIdProvider._internal(
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
  FutureOr<int?> runNotifierBuild(
    covariant FetchPasienCountByDokterId notifier,
  ) {
    return notifier.build(
      dokterId: dokterId,
    );
  }

  @override
  Override overrideWith(FetchPasienCountByDokterId Function() create) {
    return ProviderOverride(
      origin: this,
      override: FetchPasienCountByDokterIdProvider._internal(
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
  AutoDisposeAsyncNotifierProviderElement<FetchPasienCountByDokterId, int?>
      createElement() {
    return _FetchPasienCountByDokterIdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FetchPasienCountByDokterIdProvider &&
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
mixin FetchPasienCountByDokterIdRef
    on AutoDisposeAsyncNotifierProviderRef<int?> {
  /// The parameter `dokterId` of this provider.
  String get dokterId;
}

class _FetchPasienCountByDokterIdProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<FetchPasienCountByDokterId,
        int?> with FetchPasienCountByDokterIdRef {
  _FetchPasienCountByDokterIdProviderElement(super.provider);

  @override
  String get dokterId =>
      (origin as FetchPasienCountByDokterIdProvider).dokterId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
