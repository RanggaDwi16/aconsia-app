// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fetch_unread_notifications_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$fetchUnreadNotificationsHash() =>
    r'92ccf905d33d47dc64310da928b000feea03b913';

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

abstract class _$FetchUnreadNotifications
    extends BuildlessAutoDisposeAsyncNotifier<List<NotificationModel>?> {
  late final GetUnreadNotificationsParams params;

  FutureOr<List<NotificationModel>?> build({
    required GetUnreadNotificationsParams params,
  });
}

/// See also [FetchUnreadNotifications].
@ProviderFor(FetchUnreadNotifications)
const fetchUnreadNotificationsProvider = FetchUnreadNotificationsFamily();

/// See also [FetchUnreadNotifications].
class FetchUnreadNotificationsFamily
    extends Family<AsyncValue<List<NotificationModel>?>> {
  /// See also [FetchUnreadNotifications].
  const FetchUnreadNotificationsFamily();

  /// See also [FetchUnreadNotifications].
  FetchUnreadNotificationsProvider call({
    required GetUnreadNotificationsParams params,
  }) {
    return FetchUnreadNotificationsProvider(
      params: params,
    );
  }

  @override
  FetchUnreadNotificationsProvider getProviderOverride(
    covariant FetchUnreadNotificationsProvider provider,
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
  String? get name => r'fetchUnreadNotificationsProvider';
}

/// See also [FetchUnreadNotifications].
class FetchUnreadNotificationsProvider
    extends AutoDisposeAsyncNotifierProviderImpl<FetchUnreadNotifications,
        List<NotificationModel>?> {
  /// See also [FetchUnreadNotifications].
  FetchUnreadNotificationsProvider({
    required GetUnreadNotificationsParams params,
  }) : this._internal(
          () => FetchUnreadNotifications()..params = params,
          from: fetchUnreadNotificationsProvider,
          name: r'fetchUnreadNotificationsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$fetchUnreadNotificationsHash,
          dependencies: FetchUnreadNotificationsFamily._dependencies,
          allTransitiveDependencies:
              FetchUnreadNotificationsFamily._allTransitiveDependencies,
          params: params,
        );

  FetchUnreadNotificationsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.params,
  }) : super.internal();

  final GetUnreadNotificationsParams params;

  @override
  FutureOr<List<NotificationModel>?> runNotifierBuild(
    covariant FetchUnreadNotifications notifier,
  ) {
    return notifier.build(
      params: params,
    );
  }

  @override
  Override overrideWith(FetchUnreadNotifications Function() create) {
    return ProviderOverride(
      origin: this,
      override: FetchUnreadNotificationsProvider._internal(
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
  AutoDisposeAsyncNotifierProviderElement<FetchUnreadNotifications,
      List<NotificationModel>?> createElement() {
    return _FetchUnreadNotificationsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FetchUnreadNotificationsProvider && other.params == params;
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
mixin FetchUnreadNotificationsRef
    on AutoDisposeAsyncNotifierProviderRef<List<NotificationModel>?> {
  /// The parameter `params` of this provider.
  GetUnreadNotificationsParams get params;
}

class _FetchUnreadNotificationsProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<FetchUnreadNotifications,
        List<NotificationModel>?> with FetchUnreadNotificationsRef {
  _FetchUnreadNotificationsProviderElement(super.provider);

  @override
  GetUnreadNotificationsParams get params =>
      (origin as FetchUnreadNotificationsProvider).params;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
