// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fetch_user_chat_sessions_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$fetchUserChatSessionsHash() =>
    r'7a2b314894df99f012717a6cc6fd11dd6a9b211d';

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

abstract class _$FetchUserChatSessions
    extends BuildlessAutoDisposeAsyncNotifier<List<ChatSessionModel>?> {
  late final GetUserChatSessionsParams params;

  FutureOr<List<ChatSessionModel>?> build({
    required GetUserChatSessionsParams params,
  });
}

/// See also [FetchUserChatSessions].
@ProviderFor(FetchUserChatSessions)
const fetchUserChatSessionsProvider = FetchUserChatSessionsFamily();

/// See also [FetchUserChatSessions].
class FetchUserChatSessionsFamily
    extends Family<AsyncValue<List<ChatSessionModel>?>> {
  /// See also [FetchUserChatSessions].
  const FetchUserChatSessionsFamily();

  /// See also [FetchUserChatSessions].
  FetchUserChatSessionsProvider call({
    required GetUserChatSessionsParams params,
  }) {
    return FetchUserChatSessionsProvider(
      params: params,
    );
  }

  @override
  FetchUserChatSessionsProvider getProviderOverride(
    covariant FetchUserChatSessionsProvider provider,
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
  String? get name => r'fetchUserChatSessionsProvider';
}

/// See also [FetchUserChatSessions].
class FetchUserChatSessionsProvider
    extends AutoDisposeAsyncNotifierProviderImpl<FetchUserChatSessions,
        List<ChatSessionModel>?> {
  /// See also [FetchUserChatSessions].
  FetchUserChatSessionsProvider({
    required GetUserChatSessionsParams params,
  }) : this._internal(
          () => FetchUserChatSessions()..params = params,
          from: fetchUserChatSessionsProvider,
          name: r'fetchUserChatSessionsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$fetchUserChatSessionsHash,
          dependencies: FetchUserChatSessionsFamily._dependencies,
          allTransitiveDependencies:
              FetchUserChatSessionsFamily._allTransitiveDependencies,
          params: params,
        );

  FetchUserChatSessionsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.params,
  }) : super.internal();

  final GetUserChatSessionsParams params;

  @override
  FutureOr<List<ChatSessionModel>?> runNotifierBuild(
    covariant FetchUserChatSessions notifier,
  ) {
    return notifier.build(
      params: params,
    );
  }

  @override
  Override overrideWith(FetchUserChatSessions Function() create) {
    return ProviderOverride(
      origin: this,
      override: FetchUserChatSessionsProvider._internal(
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
  AutoDisposeAsyncNotifierProviderElement<FetchUserChatSessions,
      List<ChatSessionModel>?> createElement() {
    return _FetchUserChatSessionsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FetchUserChatSessionsProvider && other.params == params;
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
mixin FetchUserChatSessionsRef
    on AutoDisposeAsyncNotifierProviderRef<List<ChatSessionModel>?> {
  /// The parameter `params` of this provider.
  GetUserChatSessionsParams get params;
}

class _FetchUserChatSessionsProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<FetchUserChatSessions,
        List<ChatSessionModel>?> with FetchUserChatSessionsRef {
  _FetchUserChatSessionsProviderElement(super.provider);

  @override
  GetUserChatSessionsParams get params =>
      (origin as FetchUserChatSessionsProvider).params;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
