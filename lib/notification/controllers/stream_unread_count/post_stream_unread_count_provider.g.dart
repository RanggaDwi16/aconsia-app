// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_stream_unread_count_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$postStreamUnreadCountHash() =>
    r'5ccd9f96bddfa82b168d6fa2ffbf832d8e3c317b';

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

/// See also [postStreamUnreadCount].
@ProviderFor(postStreamUnreadCount)
const postStreamUnreadCountProvider = PostStreamUnreadCountFamily();

/// See also [postStreamUnreadCount].
class PostStreamUnreadCountFamily extends Family<AsyncValue<int>> {
  /// See also [postStreamUnreadCount].
  const PostStreamUnreadCountFamily();

  /// See also [postStreamUnreadCount].
  PostStreamUnreadCountProvider call({
    required String userId,
  }) {
    return PostStreamUnreadCountProvider(
      userId: userId,
    );
  }

  @override
  PostStreamUnreadCountProvider getProviderOverride(
    covariant PostStreamUnreadCountProvider provider,
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
  String? get name => r'postStreamUnreadCountProvider';
}

/// See also [postStreamUnreadCount].
class PostStreamUnreadCountProvider extends AutoDisposeStreamProvider<int> {
  /// See also [postStreamUnreadCount].
  PostStreamUnreadCountProvider({
    required String userId,
  }) : this._internal(
          (ref) => postStreamUnreadCount(
            ref as PostStreamUnreadCountRef,
            userId: userId,
          ),
          from: postStreamUnreadCountProvider,
          name: r'postStreamUnreadCountProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$postStreamUnreadCountHash,
          dependencies: PostStreamUnreadCountFamily._dependencies,
          allTransitiveDependencies:
              PostStreamUnreadCountFamily._allTransitiveDependencies,
          userId: userId,
        );

  PostStreamUnreadCountProvider._internal(
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
    Stream<int> Function(PostStreamUnreadCountRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: PostStreamUnreadCountProvider._internal(
        (ref) => create(ref as PostStreamUnreadCountRef),
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
  AutoDisposeStreamProviderElement<int> createElement() {
    return _PostStreamUnreadCountProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PostStreamUnreadCountProvider && other.userId == userId;
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
mixin PostStreamUnreadCountRef on AutoDisposeStreamProviderRef<int> {
  /// The parameter `userId` of this provider.
  String get userId;
}

class _PostStreamUnreadCountProviderElement
    extends AutoDisposeStreamProviderElement<int>
    with PostStreamUnreadCountRef {
  _PostStreamUnreadCountProviderElement(super.provider);

  @override
  String get userId => (origin as PostStreamUnreadCountProvider).userId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
