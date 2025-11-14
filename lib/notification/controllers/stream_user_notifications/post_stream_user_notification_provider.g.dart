// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_stream_user_notification_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$postStreamUserNotificationsHash() =>
    r'9e5bfb5abc5bdebb628e8ff5a7fb7793f9591b6a';

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

/// See also [postStreamUserNotifications].
@ProviderFor(postStreamUserNotifications)
const postStreamUserNotificationsProvider = PostStreamUserNotificationsFamily();

/// See also [postStreamUserNotifications].
class PostStreamUserNotificationsFamily
    extends Family<AsyncValue<List<NotificationModel>>> {
  /// See also [postStreamUserNotifications].
  const PostStreamUserNotificationsFamily();

  /// See also [postStreamUserNotifications].
  PostStreamUserNotificationsProvider call({
    required String userId,
  }) {
    return PostStreamUserNotificationsProvider(
      userId: userId,
    );
  }

  @override
  PostStreamUserNotificationsProvider getProviderOverride(
    covariant PostStreamUserNotificationsProvider provider,
  ) {
    return call(
      userId: provider.userId,
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
  String? get name => r'postStreamUserNotificationsProvider';
}

/// See also [postStreamUserNotifications].
class PostStreamUserNotificationsProvider
    extends AutoDisposeStreamProvider<List<NotificationModel>> {
  /// See also [postStreamUserNotifications].
  PostStreamUserNotificationsProvider({
    required String userId,
  }) : this._internal(
          (ref) => postStreamUserNotifications(
            ref as PostStreamUserNotificationsRef,
            userId: userId,
          ),
          from: postStreamUserNotificationsProvider,
          name: r'postStreamUserNotificationsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$postStreamUserNotificationsHash,
          dependencies: PostStreamUserNotificationsFamily._dependencies,
          allTransitiveDependencies:
              PostStreamUserNotificationsFamily._allTransitiveDependencies,
          userId: userId,
        );

  PostStreamUserNotificationsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.userId,
  }) : super.internal();

  final String userId;

  @override
  Override overrideWith(
    Stream<List<NotificationModel>> Function(
            PostStreamUserNotificationsRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: PostStreamUserNotificationsProvider._internal(
        (ref) => create(ref as PostStreamUserNotificationsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        userId: userId,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<NotificationModel>> createElement() {
    return _PostStreamUserNotificationsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PostStreamUserNotificationsProvider &&
        other.userId == userId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, userId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin PostStreamUserNotificationsRef
    on AutoDisposeStreamProviderRef<List<NotificationModel>> {
  /// The parameter `userId` of this provider.
  String get userId;
}

class _PostStreamUserNotificationsProviderElement
    extends AutoDisposeStreamProviderElement<List<NotificationModel>>
    with PostStreamUserNotificationsRef {
  _PostStreamUserNotificationsProviderElement(super.provider);

  @override
  String get userId => (origin as PostStreamUserNotificationsProvider).userId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
