// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fetch_incomplete_assignments_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$fetchIncompleteAssignmentsHash() =>
    r'1fd12ae07530b71c94690c45d62943683b2993c2';

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

abstract class _$FetchIncompleteAssignments
    extends BuildlessAutoDisposeAsyncNotifier<List<KontenAssignmentModel>?> {
  late final String pasienId;

  FutureOr<List<KontenAssignmentModel>?> build({
    required String pasienId,
  });
}

/// See also [FetchIncompleteAssignments].
@ProviderFor(FetchIncompleteAssignments)
const fetchIncompleteAssignmentsProvider = FetchIncompleteAssignmentsFamily();

/// See also [FetchIncompleteAssignments].
class FetchIncompleteAssignmentsFamily
    extends Family<AsyncValue<List<KontenAssignmentModel>?>> {
  /// See also [FetchIncompleteAssignments].
  const FetchIncompleteAssignmentsFamily();

  /// See also [FetchIncompleteAssignments].
  FetchIncompleteAssignmentsProvider call({
    required String pasienId,
  }) {
    return FetchIncompleteAssignmentsProvider(
      pasienId: pasienId,
    );
  }

  @override
  FetchIncompleteAssignmentsProvider getProviderOverride(
    covariant FetchIncompleteAssignmentsProvider provider,
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
  String? get name => r'fetchIncompleteAssignmentsProvider';
}

/// See also [FetchIncompleteAssignments].
class FetchIncompleteAssignmentsProvider
    extends AutoDisposeAsyncNotifierProviderImpl<FetchIncompleteAssignments,
        List<KontenAssignmentModel>?> {
  /// See also [FetchIncompleteAssignments].
  FetchIncompleteAssignmentsProvider({
    required String pasienId,
  }) : this._internal(
          () => FetchIncompleteAssignments()..pasienId = pasienId,
          from: fetchIncompleteAssignmentsProvider,
          name: r'fetchIncompleteAssignmentsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$fetchIncompleteAssignmentsHash,
          dependencies: FetchIncompleteAssignmentsFamily._dependencies,
          allTransitiveDependencies:
              FetchIncompleteAssignmentsFamily._allTransitiveDependencies,
          pasienId: pasienId,
        );

  FetchIncompleteAssignmentsProvider._internal(
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
    covariant FetchIncompleteAssignments notifier,
  ) {
    return notifier.build(
      pasienId: pasienId,
    );
  }

  @override
  Override overrideWith(FetchIncompleteAssignments Function() create) {
    return ProviderOverride(
      origin: this,
      override: FetchIncompleteAssignmentsProvider._internal(
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
  AutoDisposeAsyncNotifierProviderElement<FetchIncompleteAssignments,
      List<KontenAssignmentModel>?> createElement() {
    return _FetchIncompleteAssignmentsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FetchIncompleteAssignmentsProvider &&
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
mixin FetchIncompleteAssignmentsRef
    on AutoDisposeAsyncNotifierProviderRef<List<KontenAssignmentModel>?> {
  /// The parameter `pasienId` of this provider.
  String get pasienId;
}

class _FetchIncompleteAssignmentsProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<FetchIncompleteAssignments,
        List<KontenAssignmentModel>?> with FetchIncompleteAssignmentsRef {
  _FetchIncompleteAssignmentsProviderElement(super.provider);

  @override
  String get pasienId =>
      (origin as FetchIncompleteAssignmentsProvider).pasienId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
