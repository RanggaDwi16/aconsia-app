// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fetch_assignments_by_pasien_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$fetchAssignmentsByPasienHash() =>
    r'd7d7c4e1328e2d28ee76dca4c95d51f3264ed6a0';

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

abstract class _$FetchAssignmentsByPasien
    extends BuildlessAutoDisposeAsyncNotifier<List<KontenAssignmentModel>?> {
  late final String pasienId;

  FutureOr<List<KontenAssignmentModel>?> build({
    required String pasienId,
  });
}

/// See also [FetchAssignmentsByPasien].
@ProviderFor(FetchAssignmentsByPasien)
const fetchAssignmentsByPasienProvider = FetchAssignmentsByPasienFamily();

/// See also [FetchAssignmentsByPasien].
class FetchAssignmentsByPasienFamily
    extends Family<AsyncValue<List<KontenAssignmentModel>?>> {
  /// See also [FetchAssignmentsByPasien].
  const FetchAssignmentsByPasienFamily();

  /// See also [FetchAssignmentsByPasien].
  FetchAssignmentsByPasienProvider call({
    required String pasienId,
  }) {
    return FetchAssignmentsByPasienProvider(
      pasienId: pasienId,
    );
  }

  @override
  FetchAssignmentsByPasienProvider getProviderOverride(
    covariant FetchAssignmentsByPasienProvider provider,
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
  String? get name => r'fetchAssignmentsByPasienProvider';
}

/// See also [FetchAssignmentsByPasien].
class FetchAssignmentsByPasienProvider
    extends AutoDisposeAsyncNotifierProviderImpl<FetchAssignmentsByPasien,
        List<KontenAssignmentModel>?> {
  /// See also [FetchAssignmentsByPasien].
  FetchAssignmentsByPasienProvider({
    required String pasienId,
  }) : this._internal(
          () => FetchAssignmentsByPasien()..pasienId = pasienId,
          from: fetchAssignmentsByPasienProvider,
          name: r'fetchAssignmentsByPasienProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$fetchAssignmentsByPasienHash,
          dependencies: FetchAssignmentsByPasienFamily._dependencies,
          allTransitiveDependencies:
              FetchAssignmentsByPasienFamily._allTransitiveDependencies,
          pasienId: pasienId,
        );

  FetchAssignmentsByPasienProvider._internal(
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
  FutureOr<List<KontenAssignmentModel>?> runNotifierBuild(
    covariant FetchAssignmentsByPasien notifier,
  ) {
    return notifier.build(
      pasienId: pasienId,
    );
  }

  @override
  Override overrideWith(FetchAssignmentsByPasien Function() create) {
    return ProviderOverride(
      origin: this,
      override: FetchAssignmentsByPasienProvider._internal(
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
  AutoDisposeAsyncNotifierProviderElement<FetchAssignmentsByPasien,
      List<KontenAssignmentModel>?> createElement() {
    return _FetchAssignmentsByPasienProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FetchAssignmentsByPasienProvider &&
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
mixin FetchAssignmentsByPasienRef
    on AutoDisposeAsyncNotifierProviderRef<List<KontenAssignmentModel>?> {
  /// The parameter `pasienId` of this provider.
  String get pasienId;
}

class _FetchAssignmentsByPasienProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<FetchAssignmentsByPasien,
        List<KontenAssignmentModel>?> with FetchAssignmentsByPasienRef {
  _FetchAssignmentsByPasienProviderElement(super.provider);

  @override
  String get pasienId => (origin as FetchAssignmentsByPasienProvider).pasienId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
