// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fetch_dokter_profile_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$fetchDokterProfileHash() =>
    r'b36f0528d046da37edf27b394f3948a9ae83fc5a';

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

abstract class _$FetchDokterProfile
    extends BuildlessAutoDisposeAsyncNotifier<DokterProfileModel?> {
  late final String uid;

  FutureOr<DokterProfileModel?> build({
    required String uid,
  });
}

/// See also [FetchDokterProfile].
@ProviderFor(FetchDokterProfile)
const fetchDokterProfileProvider = FetchDokterProfileFamily();

/// See also [FetchDokterProfile].
class FetchDokterProfileFamily extends Family<AsyncValue<DokterProfileModel?>> {
  /// See also [FetchDokterProfile].
  const FetchDokterProfileFamily();

  /// See also [FetchDokterProfile].
  FetchDokterProfileProvider call({
    required String uid,
  }) {
    return FetchDokterProfileProvider(
      uid: uid,
    );
  }

  @override
  FetchDokterProfileProvider getProviderOverride(
    covariant FetchDokterProfileProvider provider,
  ) {
    return call(
      uid: provider.uid,
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
  String? get name => r'fetchDokterProfileProvider';
}

/// See also [FetchDokterProfile].
class FetchDokterProfileProvider extends AutoDisposeAsyncNotifierProviderImpl<
    FetchDokterProfile, DokterProfileModel?> {
  /// See also [FetchDokterProfile].
  FetchDokterProfileProvider({
    required String uid,
  }) : this._internal(
          () => FetchDokterProfile()..uid = uid,
          from: fetchDokterProfileProvider,
          name: r'fetchDokterProfileProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$fetchDokterProfileHash,
          dependencies: FetchDokterProfileFamily._dependencies,
          allTransitiveDependencies:
              FetchDokterProfileFamily._allTransitiveDependencies,
          uid: uid,
        );

  FetchDokterProfileProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.uid,
  }) : super.internal();

  final String uid;

  @override
  FutureOr<DokterProfileModel?> runNotifierBuild(
    covariant FetchDokterProfile notifier,
  ) {
    return notifier.build(
      uid: uid,
    );
  }

  @override
  Override overrideWith(FetchDokterProfile Function() create) {
    return ProviderOverride(
      origin: this,
      override: FetchDokterProfileProvider._internal(
        () => create()..uid = uid,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        uid: uid,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<FetchDokterProfile,
      DokterProfileModel?> createElement() {
    return _FetchDokterProfileProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FetchDokterProfileProvider && other.uid == uid;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, uid.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin FetchDokterProfileRef
    on AutoDisposeAsyncNotifierProviderRef<DokterProfileModel?> {
  /// The parameter `uid` of this provider.
  String get uid;
}

class _FetchDokterProfileProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<FetchDokterProfile,
        DokterProfileModel?> with FetchDokterProfileRef {
  _FetchDokterProfileProviderElement(super.provider);

  @override
  String get uid => (origin as FetchDokterProfileProvider).uid;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
