// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fetch_is_konten_assigned_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$fetchIsKontenAssignedHash() =>
    r'45c4f88c29529499c8cc1830dd6586f44f269c25';

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

abstract class _$FetchIsKontenAssigned
    extends BuildlessAutoDisposeAsyncNotifier<bool?> {
  late final String pasienId;
  late final String kontenId;

  FutureOr<bool?> build({
    required String pasienId,
    required String kontenId,
  });
}

/// See also [FetchIsKontenAssigned].
@ProviderFor(FetchIsKontenAssigned)
const fetchIsKontenAssignedProvider = FetchIsKontenAssignedFamily();

/// See also [FetchIsKontenAssigned].
class FetchIsKontenAssignedFamily extends Family<AsyncValue<bool?>> {
  /// See also [FetchIsKontenAssigned].
  const FetchIsKontenAssignedFamily();

  /// See also [FetchIsKontenAssigned].
  FetchIsKontenAssignedProvider call({
    required String pasienId,
    required String kontenId,
  }) {
    return FetchIsKontenAssignedProvider(
      pasienId: pasienId,
      kontenId: kontenId,
    );
  }

  @override
  FetchIsKontenAssignedProvider getProviderOverride(
    covariant FetchIsKontenAssignedProvider provider,
  ) {
    return call(
      pasienId: provider.pasienId,
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
  String? get name => r'fetchIsKontenAssignedProvider';
}

/// See also [FetchIsKontenAssigned].
class FetchIsKontenAssignedProvider
    extends AutoDisposeAsyncNotifierProviderImpl<FetchIsKontenAssigned, bool?> {
  /// See also [FetchIsKontenAssigned].
  FetchIsKontenAssignedProvider({
    required String pasienId,
    required String kontenId,
  }) : this._internal(
          () => FetchIsKontenAssigned()
            ..pasienId = pasienId
            ..kontenId = kontenId,
          from: fetchIsKontenAssignedProvider,
          name: r'fetchIsKontenAssignedProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$fetchIsKontenAssignedHash,
          dependencies: FetchIsKontenAssignedFamily._dependencies,
          allTransitiveDependencies:
              FetchIsKontenAssignedFamily._allTransitiveDependencies,
          pasienId: pasienId,
          kontenId: kontenId,
        );

  FetchIsKontenAssignedProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.pasienId,
    required this.kontenId,
  }) : super.internal();

  final String pasienId;
  final String kontenId;

  @override
  FutureOr<bool?> runNotifierBuild(
    covariant FetchIsKontenAssigned notifier,
  ) {
    return notifier.build(
      pasienId: pasienId,
      kontenId: kontenId,
    );
  }

  @override
  Override overrideWith(FetchIsKontenAssigned Function() create) {
    return ProviderOverride(
      origin: this,
      override: FetchIsKontenAssignedProvider._internal(
        () => create()
          ..pasienId = pasienId
          ..kontenId = kontenId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        pasienId: pasienId,
        kontenId: kontenId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<FetchIsKontenAssigned, bool?>
      createElement() {
    return _FetchIsKontenAssignedProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FetchIsKontenAssignedProvider &&
        other.pasienId == pasienId &&
        other.kontenId == kontenId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, pasienId.hashCode);
    hash = _SystemHash.combine(hash, kontenId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin FetchIsKontenAssignedRef on AutoDisposeAsyncNotifierProviderRef<bool?> {
  /// The parameter `pasienId` of this provider.
  String get pasienId;

  /// The parameter `kontenId` of this provider.
  String get kontenId;
}

class _FetchIsKontenAssignedProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<FetchIsKontenAssigned,
        bool?> with FetchIsKontenAssignedRef {
  _FetchIsKontenAssignedProviderElement(super.provider);

  @override
  String get pasienId => (origin as FetchIsKontenAssignedProvider).pasienId;
  @override
  String get kontenId => (origin as FetchIsKontenAssignedProvider).kontenId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
