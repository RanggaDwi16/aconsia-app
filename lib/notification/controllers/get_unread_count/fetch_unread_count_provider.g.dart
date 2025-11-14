// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fetch_unread_count_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$fetchUnreadCountHash() => r'b6045baf469dcbcccf261320f4c5ad28d9e5fd9a';

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

abstract class _$FetchUnreadCount
    extends BuildlessAutoDisposeAsyncNotifier<int?> {
  late final GetUnreadCountParams params;

  FutureOr<int?> build({
    required GetUnreadCountParams params,
  });
}

/// See also [FetchUnreadCount].
@ProviderFor(FetchUnreadCount)
const fetchUnreadCountProvider = FetchUnreadCountFamily();

/// See also [FetchUnreadCount].
class FetchUnreadCountFamily extends Family<AsyncValue<int?>> {
  /// See also [FetchUnreadCount].
  const FetchUnreadCountFamily();

  /// See also [FetchUnreadCount].
  FetchUnreadCountProvider call({
    required GetUnreadCountParams params,
  }) {
    return FetchUnreadCountProvider(
      params: params,
    );
  }

  @override
  FetchUnreadCountProvider getProviderOverride(
    covariant FetchUnreadCountProvider provider,
  ) {
    return call(
      params: provider.params,
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
  String? get name => r'fetchUnreadCountProvider';
}

/// See also [FetchUnreadCount].
class FetchUnreadCountProvider
    extends AutoDisposeAsyncNotifierProviderImpl<FetchUnreadCount, int?> {
  /// See also [FetchUnreadCount].
  FetchUnreadCountProvider({
    required GetUnreadCountParams params,
  }) : this._internal(
          () => FetchUnreadCount()..params = params,
          from: fetchUnreadCountProvider,
          name: r'fetchUnreadCountProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$fetchUnreadCountHash,
          dependencies: FetchUnreadCountFamily._dependencies,
          allTransitiveDependencies:
              FetchUnreadCountFamily._allTransitiveDependencies,
          params: params,
        );

  FetchUnreadCountProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.params,
  }) : super.internal();

  final GetUnreadCountParams params;

  @override
  FutureOr<int?> runNotifierBuild(
    covariant FetchUnreadCount notifier,
  ) {
    return notifier.build(
      params: params,
    );
  }

  @override
  Override overrideWith(FetchUnreadCount Function() create) {
    return ProviderOverride(
      origin: this,
      override: FetchUnreadCountProvider._internal(
        () => create()..params = params,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        params: params,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<FetchUnreadCount, int?>
      createElement() {
    return _FetchUnreadCountProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FetchUnreadCountProvider && other.params == params;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, params.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin FetchUnreadCountRef on AutoDisposeAsyncNotifierProviderRef<int?> {
  /// The parameter `params` of this provider.
  GetUnreadCountParams get params;
}

class _FetchUnreadCountProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<FetchUnreadCount, int?>
    with FetchUnreadCountRef {
  _FetchUnreadCountProviderElement(super.provider);

  @override
  GetUnreadCountParams get params =>
      (origin as FetchUnreadCountProvider).params;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
