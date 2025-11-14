// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_stream_messages_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$postStreamMessagesHash() =>
    r'972a6d62c9964a327ed01ab63c2254875644ebbe';

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

/// See also [postStreamMessages].
@ProviderFor(postStreamMessages)
const postStreamMessagesProvider = PostStreamMessagesFamily();

/// See also [postStreamMessages].
class PostStreamMessagesFamily
    extends Family<AsyncValue<List<ChatMessageModel>>> {
  /// See also [postStreamMessages].
  const PostStreamMessagesFamily();

  /// See also [postStreamMessages].
  PostStreamMessagesProvider call({
    required String sessionId,
  }) {
    return PostStreamMessagesProvider(
      sessionId: sessionId,
    );
  }

  @override
  PostStreamMessagesProvider getProviderOverride(
    covariant PostStreamMessagesProvider provider,
  ) {
    return call(
      sessionId: provider.sessionId,
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
  String? get name => r'postStreamMessagesProvider';
}

/// See also [postStreamMessages].
class PostStreamMessagesProvider
    extends StreamProvider<List<ChatMessageModel>> {
  /// See also [postStreamMessages].
  PostStreamMessagesProvider({
    required String sessionId,
  }) : this._internal(
          (ref) => postStreamMessages(
            ref as PostStreamMessagesRef,
            sessionId: sessionId,
          ),
          from: postStreamMessagesProvider,
          name: r'postStreamMessagesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$postStreamMessagesHash,
          dependencies: PostStreamMessagesFamily._dependencies,
          allTransitiveDependencies:
              PostStreamMessagesFamily._allTransitiveDependencies,
          sessionId: sessionId,
        );

  PostStreamMessagesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.sessionId,
  }) : super.internal();

  final String sessionId;

  @override
  Override overrideWith(
    Stream<List<ChatMessageModel>> Function(PostStreamMessagesRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: PostStreamMessagesProvider._internal(
        (ref) => create(ref as PostStreamMessagesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        sessionId: sessionId,
      ),
    );
  }

  @override
  StreamProviderElement<List<ChatMessageModel>> createElement() {
    return _PostStreamMessagesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PostStreamMessagesProvider && other.sessionId == sessionId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, sessionId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin PostStreamMessagesRef on StreamProviderRef<List<ChatMessageModel>> {
  /// The parameter `sessionId` of this provider.
  String get sessionId;
}

class _PostStreamMessagesProviderElement
    extends StreamProviderElement<List<ChatMessageModel>>
    with PostStreamMessagesRef {
  _PostStreamMessagesProviderElement(super.provider);

  @override
  String get sessionId => (origin as PostStreamMessagesProvider).sessionId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
