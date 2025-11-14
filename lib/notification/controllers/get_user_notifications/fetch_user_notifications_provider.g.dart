// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fetch_user_notifications_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$fetchUserNotificationsHash() =>
    r'25e6b67ddc9c58c55569504f32e280ccb2ee773f';

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

abstract class _$FetchUserNotifications
    extends BuildlessAutoDisposeAsyncNotifier<List<NotificationModel>?> {
  late final GetUserNotificationsParams params;

  FutureOr<List<NotificationModel>?> build({
    required GetUserNotificationsParams params,
  });
}

/// See also [FetchUserNotifications].
@ProviderFor(FetchUserNotifications)
const fetchUserNotificationsProvider = FetchUserNotificationsFamily();

/// See also [FetchUserNotifications].
class FetchUserNotificationsFamily
    extends Family<AsyncValue<List<NotificationModel>?>> {
  /// See also [FetchUserNotifications].
  const FetchUserNotificationsFamily();

  /// See also [FetchUserNotifications].
  FetchUserNotificationsProvider call({
    required GetUserNotificationsParams params,
  }) {
    return FetchUserNotificationsProvider(
      params: params,
    );
  }

  @override
  FetchUserNotificationsProvider getProviderOverride(
    covariant FetchUserNotificationsProvider provider,
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
  String? get name => r'fetchUserNotificationsProvider';
}

/// See also [FetchUserNotifications].
class FetchUserNotificationsProvider
    extends AutoDisposeAsyncNotifierProviderImpl<FetchUserNotifications,
        List<NotificationModel>?> {
  /// See also [FetchUserNotifications].
  FetchUserNotificationsProvider({
    required GetUserNotificationsParams params,
  }) : this._internal(
          () => FetchUserNotifications()..params = params,
          from: fetchUserNotificationsProvider,
          name: r'fetchUserNotificationsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$fetchUserNotificationsHash,
          dependencies: FetchUserNotificationsFamily._dependencies,
          allTransitiveDependencies:
              FetchUserNotificationsFamily._allTransitiveDependencies,
          params: params,
        );

  FetchUserNotificationsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.params,
  }) : super.internal();

  final GetUserNotificationsParams params;

  @override
  FutureOr<List<NotificationModel>?> runNotifierBuild(
    covariant FetchUserNotifications notifier,
  ) {
    return notifier.build(
      params: params,
    );
  }

  @override
  Override overrideWith(FetchUserNotifications Function() create) {
    return ProviderOverride(
      origin: this,
      override: FetchUserNotificationsProvider._internal(
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
  AutoDisposeAsyncNotifierProviderElement<FetchUserNotifications,
      List<NotificationModel>?> createElement() {
    return _FetchUserNotificationsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FetchUserNotificationsProvider && other.params == params;
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
mixin FetchUserNotificationsRef
    on AutoDisposeAsyncNotifierProviderRef<List<NotificationModel>?> {
  /// The parameter `params` of this provider.
  GetUserNotificationsParams get params;
}

class _FetchUserNotificationsProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<FetchUserNotifications,
        List<NotificationModel>?> with FetchUserNotificationsRef {
  _FetchUserNotificationsProviderElement(super.provider);

  @override
  GetUserNotificationsParams get params =>
      (origin as FetchUserNotificationsProvider).params;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
