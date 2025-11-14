// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fetch_completion_percentage_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$fetchCompletionPercentageHash() =>
    r'dfacdfe755b7aeeffdc93000fe655441bd24a67e';

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

abstract class _$FetchCompletionPercentage
    extends BuildlessAutoDisposeAsyncNotifier<double?> {
  late final String pasienId;

  FutureOr<double?> build({
    required String pasienId,
  });
}

/// See also [FetchCompletionPercentage].
@ProviderFor(FetchCompletionPercentage)
const fetchCompletionPercentageProvider = FetchCompletionPercentageFamily();

/// See also [FetchCompletionPercentage].
class FetchCompletionPercentageFamily extends Family<AsyncValue<double?>> {
  /// See also [FetchCompletionPercentage].
  const FetchCompletionPercentageFamily();

  /// See also [FetchCompletionPercentage].
  FetchCompletionPercentageProvider call({
    required String pasienId,
  }) {
    return FetchCompletionPercentageProvider(
      pasienId: pasienId,
    );
  }

  @override
  FetchCompletionPercentageProvider getProviderOverride(
    covariant FetchCompletionPercentageProvider provider,
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
  String? get name => r'fetchCompletionPercentageProvider';
}

/// See also [FetchCompletionPercentage].
class FetchCompletionPercentageProvider
    extends AutoDisposeAsyncNotifierProviderImpl<FetchCompletionPercentage,
        double?> {
  /// See also [FetchCompletionPercentage].
  FetchCompletionPercentageProvider({
    required String pasienId,
  }) : this._internal(
          () => FetchCompletionPercentage()..pasienId = pasienId,
          from: fetchCompletionPercentageProvider,
          name: r'fetchCompletionPercentageProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$fetchCompletionPercentageHash,
          dependencies: FetchCompletionPercentageFamily._dependencies,
          allTransitiveDependencies:
              FetchCompletionPercentageFamily._allTransitiveDependencies,
          pasienId: pasienId,
        );

  FetchCompletionPercentageProvider._internal(
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
  FutureOr<double?> runNotifierBuild(
    covariant FetchCompletionPercentage notifier,
  ) {
    return notifier.build(
      pasienId: pasienId,
    );
  }

  @override
  Override overrideWith(FetchCompletionPercentage Function() create) {
    return ProviderOverride(
      origin: this,
      override: FetchCompletionPercentageProvider._internal(
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
  AutoDisposeAsyncNotifierProviderElement<FetchCompletionPercentage, double?>
      createElement() {
    return _FetchCompletionPercentageProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FetchCompletionPercentageProvider &&
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
mixin FetchCompletionPercentageRef
    on AutoDisposeAsyncNotifierProviderRef<double?> {
  /// The parameter `pasienId` of this provider.
  String get pasienId;
}

class _FetchCompletionPercentageProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<FetchCompletionPercentage,
        double?> with FetchCompletionPercentageRef {
  _FetchCompletionPercentageProviderElement(super.provider);

  @override
  String get pasienId => (origin as FetchCompletionPercentageProvider).pasienId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
