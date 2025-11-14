// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fetch_pasien_profile_by_id_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$fetchPasienProfileByIdHash() =>
    r'a29343c5077d93a9372401ce07eb7a396b1f8909';

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

abstract class _$FetchPasienProfileById
    extends BuildlessAutoDisposeAsyncNotifier<PasienProfileModel?> {
  late final String pasienId;

  FutureOr<PasienProfileModel?> build({
    required String pasienId,
  });
}

/// See also [FetchPasienProfileById].
@ProviderFor(FetchPasienProfileById)
const fetchPasienProfileByIdProvider = FetchPasienProfileByIdFamily();

/// See also [FetchPasienProfileById].
class FetchPasienProfileByIdFamily
    extends Family<AsyncValue<PasienProfileModel?>> {
  /// See also [FetchPasienProfileById].
  const FetchPasienProfileByIdFamily();

  /// See also [FetchPasienProfileById].
  FetchPasienProfileByIdProvider call({
    required String pasienId,
  }) {
    return FetchPasienProfileByIdProvider(
      pasienId: pasienId,
    );
  }

  @override
  FetchPasienProfileByIdProvider getProviderOverride(
    covariant FetchPasienProfileByIdProvider provider,
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
  String? get name => r'fetchPasienProfileByIdProvider';
}

/// See also [FetchPasienProfileById].
class FetchPasienProfileByIdProvider
    extends AutoDisposeAsyncNotifierProviderImpl<FetchPasienProfileById,
        PasienProfileModel?> {
  /// See also [FetchPasienProfileById].
  FetchPasienProfileByIdProvider({
    required String pasienId,
  }) : this._internal(
          () => FetchPasienProfileById()..pasienId = pasienId,
          from: fetchPasienProfileByIdProvider,
          name: r'fetchPasienProfileByIdProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$fetchPasienProfileByIdHash,
          dependencies: FetchPasienProfileByIdFamily._dependencies,
          allTransitiveDependencies:
              FetchPasienProfileByIdFamily._allTransitiveDependencies,
          pasienId: pasienId,
        );

  FetchPasienProfileByIdProvider._internal(
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
  FutureOr<PasienProfileModel?> runNotifierBuild(
    covariant FetchPasienProfileById notifier,
  ) {
    return notifier.build(
      pasienId: pasienId,
    );
  }

  @override
  Override overrideWith(FetchPasienProfileById Function() create) {
    return ProviderOverride(
      origin: this,
      override: FetchPasienProfileByIdProvider._internal(
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
  AutoDisposeAsyncNotifierProviderElement<FetchPasienProfileById,
      PasienProfileModel?> createElement() {
    return _FetchPasienProfileByIdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FetchPasienProfileByIdProvider &&
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
mixin FetchPasienProfileByIdRef
    on AutoDisposeAsyncNotifierProviderRef<PasienProfileModel?> {
  /// The parameter `pasienId` of this provider.
  String get pasienId;
}

class _FetchPasienProfileByIdProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<FetchPasienProfileById,
        PasienProfileModel?> with FetchPasienProfileByIdRef {
  _FetchPasienProfileByIdProviderElement(super.provider);

  @override
  String get pasienId => (origin as FetchPasienProfileByIdProvider).pasienId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
