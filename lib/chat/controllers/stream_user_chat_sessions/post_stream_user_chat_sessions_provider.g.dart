// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_stream_user_chat_sessions_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$postStreamUserChatSessionsHash() =>
    r'5a8d70840e3f99eb84bb22e6fe410d583e3285c9';

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

/// See also [postStreamUserChatSessions].
@ProviderFor(postStreamUserChatSessions)
const postStreamUserChatSessionsProvider = PostStreamUserChatSessionsFamily();

/// See also [postStreamUserChatSessions].
class PostStreamUserChatSessionsFamily
    extends Family<AsyncValue<List<ChatSessionModel>>> {
  /// See also [postStreamUserChatSessions].
  const PostStreamUserChatSessionsFamily();

  /// See also [postStreamUserChatSessions].
  PostStreamUserChatSessionsProvider call({
    required String userId,
    required String role,
  }) {
    return PostStreamUserChatSessionsProvider(
      userId: userId,
      role: role,
    );
  }

  @override
  PostStreamUserChatSessionsProvider getProviderOverride(
    covariant PostStreamUserChatSessionsProvider provider,
  ) {
    return call(
      userId: provider.userId,
      role: provider.role,
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
  String? get name => r'postStreamUserChatSessionsProvider';
}

/// See also [postStreamUserChatSessions].
class PostStreamUserChatSessionsProvider
    extends StreamProvider<List<ChatSessionModel>> {
  /// See also [postStreamUserChatSessions].
  PostStreamUserChatSessionsProvider({
    required String userId,
    required String role,
  }) : this._internal(
          (ref) => postStreamUserChatSessions(
            ref as PostStreamUserChatSessionsRef,
            userId: userId,
            role: role,
          ),
          from: postStreamUserChatSessionsProvider,
          name: r'postStreamUserChatSessionsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$postStreamUserChatSessionsHash,
          dependencies: PostStreamUserChatSessionsFamily._dependencies,
          allTransitiveDependencies:
              PostStreamUserChatSessionsFamily._allTransitiveDependencies,
          userId: userId,
          role: role,
        );

  PostStreamUserChatSessionsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.userId,
    required this.role,
  }) : super.internal();

  final String userId;
  final String role;

  @override
  Override overrideWith(
    Stream<List<ChatSessionModel>> Function(
            PostStreamUserChatSessionsRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: PostStreamUserChatSessionsProvider._internal(
        (ref) => create(ref as PostStreamUserChatSessionsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        userId: userId,
        role: role,
      ),
    );
  }

  @override
  StreamProviderElement<List<ChatSessionModel>> createElement() {
    return _PostStreamUserChatSessionsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PostStreamUserChatSessionsProvider &&
        other.userId == userId &&
        other.role == role;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, userId.hashCode);
    hash = _SystemHash.combine(hash, role.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin PostStreamUserChatSessionsRef
    on StreamProviderRef<List<ChatSessionModel>> {
  /// The parameter `userId` of this provider.
  String get userId;

  /// The parameter `role` of this provider.
  String get role;
}

class _PostStreamUserChatSessionsProviderElement
    extends StreamProviderElement<List<ChatSessionModel>>
    with PostStreamUserChatSessionsRef {
  _PostStreamUserChatSessionsProviderElement(super.provider);

  @override
  String get userId => (origin as PostStreamUserChatSessionsProvider).userId;
  @override
  String get role => (origin as PostStreamUserChatSessionsProvider).role;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
