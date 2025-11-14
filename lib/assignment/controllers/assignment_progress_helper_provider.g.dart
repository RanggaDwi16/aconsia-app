// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'assignment_progress_helper_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$checkKontenAssignmentHash() =>
    r'b578dd1d8ee4120c9d11bb354b212ae1f72aeea4';

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

/// Provider to check if konten is assigned and get assignment
///
/// Copied from [checkKontenAssignment].
@ProviderFor(checkKontenAssignment)
const checkKontenAssignmentProvider = CheckKontenAssignmentFamily();

/// Provider to check if konten is assigned and get assignment
///
/// Copied from [checkKontenAssignment].
class CheckKontenAssignmentFamily
    extends Family<AsyncValue<KontenAssignmentModel?>> {
  /// Provider to check if konten is assigned and get assignment
  ///
  /// Copied from [checkKontenAssignment].
  const CheckKontenAssignmentFamily();

  /// Provider to check if konten is assigned and get assignment
  ///
  /// Copied from [checkKontenAssignment].
  CheckKontenAssignmentProvider call({
    required String pasienId,
    required String kontenId,
  }) {
    return CheckKontenAssignmentProvider(
      pasienId: pasienId,
      kontenId: kontenId,
    );
  }

  @override
  CheckKontenAssignmentProvider getProviderOverride(
    covariant CheckKontenAssignmentProvider provider,
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
  String? get name => r'checkKontenAssignmentProvider';
}

/// Provider to check if konten is assigned and get assignment
///
/// Copied from [checkKontenAssignment].
class CheckKontenAssignmentProvider
    extends AutoDisposeFutureProvider<KontenAssignmentModel?> {
  /// Provider to check if konten is assigned and get assignment
  ///
  /// Copied from [checkKontenAssignment].
  CheckKontenAssignmentProvider({
    required String pasienId,
    required String kontenId,
  }) : this._internal(
          (ref) => checkKontenAssignment(
            ref as CheckKontenAssignmentRef,
            pasienId: pasienId,
            kontenId: kontenId,
          ),
          from: checkKontenAssignmentProvider,
          name: r'checkKontenAssignmentProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$checkKontenAssignmentHash,
          dependencies: CheckKontenAssignmentFamily._dependencies,
          allTransitiveDependencies:
              CheckKontenAssignmentFamily._allTransitiveDependencies,
          pasienId: pasienId,
          kontenId: kontenId,
        );

  CheckKontenAssignmentProvider._internal(
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
  Override overrideWith(
    FutureOr<KontenAssignmentModel?> Function(CheckKontenAssignmentRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CheckKontenAssignmentProvider._internal(
        (ref) => create(ref as CheckKontenAssignmentRef),
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
  AutoDisposeFutureProviderElement<KontenAssignmentModel?> createElement() {
    return _CheckKontenAssignmentProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CheckKontenAssignmentProvider &&
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
mixin CheckKontenAssignmentRef
    on AutoDisposeFutureProviderRef<KontenAssignmentModel?> {
  /// The parameter `pasienId` of this provider.
  String get pasienId;

  /// The parameter `kontenId` of this provider.
  String get kontenId;
}

class _CheckKontenAssignmentProviderElement
    extends AutoDisposeFutureProviderElement<KontenAssignmentModel?>
    with CheckKontenAssignmentRef {
  _CheckKontenAssignmentProviderElement(super.provider);

  @override
  String get pasienId => (origin as CheckKontenAssignmentProvider).pasienId;
  @override
  String get kontenId => (origin as CheckKontenAssignmentProvider).kontenId;
}

String _$updateAssignmentProgressHash() =>
    r'efb28936a9432df5402a4551854be8870190bc99';

/// Provider to update assignment progress
///
/// Copied from [UpdateAssignmentProgress].
@ProviderFor(UpdateAssignmentProgress)
final updateAssignmentProgressProvider = AutoDisposeAsyncNotifierProvider<
    UpdateAssignmentProgress, String?>.internal(
  UpdateAssignmentProgress.new,
  name: r'updateAssignmentProgressProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$updateAssignmentProgressHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$UpdateAssignmentProgress = AutoDisposeAsyncNotifier<String?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
