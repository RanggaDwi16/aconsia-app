// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fetch_konten_count_by_dokter_id_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$fetchKontenCountByDokterIdHash() =>
    r'752ae390bd393628f730a6770858e070e091fe40';

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

abstract class _$FetchKontenCountByDokterId
    extends BuildlessAutoDisposeAsyncNotifier<int?> {
  late final String dokterId;

  FutureOr<int?> build({
    required String dokterId,
  });
}

/// See also [FetchKontenCountByDokterId].
@ProviderFor(FetchKontenCountByDokterId)
const fetchKontenCountByDokterIdProvider = FetchKontenCountByDokterIdFamily();

/// See also [FetchKontenCountByDokterId].
class FetchKontenCountByDokterIdFamily extends Family<AsyncValue<int?>> {
  /// See also [FetchKontenCountByDokterId].
  const FetchKontenCountByDokterIdFamily();

  /// See also [FetchKontenCountByDokterId].
  FetchKontenCountByDokterIdProvider call({
    required String dokterId,
  }) {
    return FetchKontenCountByDokterIdProvider(
      dokterId: dokterId,
    );
  }

  @override
  FetchKontenCountByDokterIdProvider getProviderOverride(
    covariant FetchKontenCountByDokterIdProvider provider,
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
  String? get name => r'fetchKontenCountByDokterIdProvider';
}

/// See also [FetchKontenCountByDokterId].
class FetchKontenCountByDokterIdProvider
    extends AutoDisposeAsyncNotifierProviderImpl<FetchKontenCountByDokterId,
        int?> {
  /// See also [FetchKontenCountByDokterId].
  FetchKontenCountByDokterIdProvider({
    required String dokterId,
  }) : this._internal(
          () => FetchKontenCountByDokterId()..dokterId = dokterId,
          from: fetchKontenCountByDokterIdProvider,
          name: r'fetchKontenCountByDokterIdProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$fetchKontenCountByDokterIdHash,
          dependencies: FetchKontenCountByDokterIdFamily._dependencies,
          allTransitiveDependencies:
              FetchKontenCountByDokterIdFamily._allTransitiveDependencies,
          dokterId: dokterId,
        );

  FetchKontenCountByDokterIdProvider._internal(
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
    covariant FetchKontenCountByDokterId notifier,
  ) {
    return notifier.build(
      dokterId: dokterId,
    );
  }

  @override
  Override overrideWith(FetchKontenCountByDokterId Function() create) {
    return ProviderOverride(
      origin: this,
      override: FetchKontenCountByDokterIdProvider._internal(
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
  AutoDisposeAsyncNotifierProviderElement<FetchKontenCountByDokterId, int?>
      createElement() {
    return _FetchKontenCountByDokterIdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FetchKontenCountByDokterIdProvider &&
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
mixin FetchKontenCountByDokterIdRef
    on AutoDisposeAsyncNotifierProviderRef<int?> {
  /// The parameter `dokterId` of this provider.
  String get dokterId;
}

class _FetchKontenCountByDokterIdProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<FetchKontenCountByDokterId,
        int?> with FetchKontenCountByDokterIdRef {
  _FetchKontenCountByDokterIdProviderElement(super.provider);

  @override
  String get dokterId =>
      (origin as FetchKontenCountByDokterIdProvider).dokterId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
