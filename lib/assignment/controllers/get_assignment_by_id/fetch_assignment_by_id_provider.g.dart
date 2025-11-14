// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fetch_assignment_by_id_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$fetchAssignmentByIdHash() =>
    r'238b5a78af2eb3369c26d1498c0d9efbde2d7164';

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

abstract class _$FetchAssignmentById
    extends BuildlessAutoDisposeAsyncNotifier<KontenAssignmentModel?> {
  late final String assignmentId;

  FutureOr<KontenAssignmentModel?> build({
    required String assignmentId,
  });
}

/// See also [FetchAssignmentById].
@ProviderFor(FetchAssignmentById)
const fetchAssignmentByIdProvider = FetchAssignmentByIdFamily();

/// See also [FetchAssignmentById].
class FetchAssignmentByIdFamily
    extends Family<AsyncValue<KontenAssignmentModel?>> {
  /// See also [FetchAssignmentById].
  const FetchAssignmentByIdFamily();

  /// See also [FetchAssignmentById].
  FetchAssignmentByIdProvider call({
    required String assignmentId,
  }) {
    return FetchAssignmentByIdProvider(
      assignmentId: assignmentId,
    );
  }

  @override
  FetchAssignmentByIdProvider getProviderOverride(
    covariant FetchAssignmentByIdProvider provider,
  ) {
    return call(
      assignmentId: provider.assignmentId,
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
  String? get name => r'fetchAssignmentByIdProvider';
}

/// See also [FetchAssignmentById].
class FetchAssignmentByIdProvider extends AutoDisposeAsyncNotifierProviderImpl<
    FetchAssignmentById, KontenAssignmentModel?> {
  /// See also [FetchAssignmentById].
  FetchAssignmentByIdProvider({
    required String assignmentId,
  }) : this._internal(
          () => FetchAssignmentById()..assignmentId = assignmentId,
          from: fetchAssignmentByIdProvider,
          name: r'fetchAssignmentByIdProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$fetchAssignmentByIdHash,
          dependencies: FetchAssignmentByIdFamily._dependencies,
          allTransitiveDependencies:
              FetchAssignmentByIdFamily._allTransitiveDependencies,
          assignmentId: assignmentId,
        );

  FetchAssignmentByIdProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.assignmentId,
  }) : super.internal();

  final String assignmentId;

  @override
  FutureOr<KontenAssignmentModel?> runNotifierBuild(
    covariant FetchAssignmentById notifier,
  ) {
    return notifier.build(
      assignmentId: assignmentId,
    );
  }

  @override
  Override overrideWith(FetchAssignmentById Function() create) {
    return ProviderOverride(
      origin: this,
      override: FetchAssignmentByIdProvider._internal(
        () => create()..assignmentId = assignmentId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        assignmentId: assignmentId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<FetchAssignmentById,
      KontenAssignmentModel?> createElement() {
    return _FetchAssignmentByIdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FetchAssignmentByIdProvider &&
        other.assignmentId == assignmentId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, assignmentId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin FetchAssignmentByIdRef
    on AutoDisposeAsyncNotifierProviderRef<KontenAssignmentModel?> {
  /// The parameter `assignmentId` of this provider.
  String get assignmentId;
}

class _FetchAssignmentByIdProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<FetchAssignmentById,
        KontenAssignmentModel?> with FetchAssignmentByIdRef {
  _FetchAssignmentByIdProviderElement(super.provider);

  @override
  String get assignmentId =>
      (origin as FetchAssignmentByIdProvider).assignmentId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
