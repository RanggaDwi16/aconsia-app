// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fetch_messages_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$fetchMessagesHash() => r'3526faf3666705aad600828e5a27d386ceef755f';

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

abstract class _$FetchMessages
    extends BuildlessAutoDisposeAsyncNotifier<List<ChatMessageModel>?> {
  late final GetMessagesParams params;

  FutureOr<List<ChatMessageModel>?> build({
    required GetMessagesParams params,
  });
}

/// See also [FetchMessages].
@ProviderFor(FetchMessages)
const fetchMessagesProvider = FetchMessagesFamily();

/// See also [FetchMessages].
class FetchMessagesFamily extends Family<AsyncValue<List<ChatMessageModel>?>> {
  /// See also [FetchMessages].
  const FetchMessagesFamily();

  /// See also [FetchMessages].
  FetchMessagesProvider call({
    required GetMessagesParams params,
  }) {
    return FetchMessagesProvider(
      params: params,
    );
  }

  @override
  FetchMessagesProvider getProviderOverride(
    covariant FetchMessagesProvider provider,
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
  String? get name => r'fetchMessagesProvider';
}

/// See also [FetchMessages].
class FetchMessagesProvider extends AutoDisposeAsyncNotifierProviderImpl<
    FetchMessages, List<ChatMessageModel>?> {
  /// See also [FetchMessages].
  FetchMessagesProvider({
    required GetMessagesParams params,
  }) : this._internal(
          () => FetchMessages()..params = params,
          from: fetchMessagesProvider,
          name: r'fetchMessagesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$fetchMessagesHash,
          dependencies: FetchMessagesFamily._dependencies,
          allTransitiveDependencies:
              FetchMessagesFamily._allTransitiveDependencies,
          params: params,
        );

  FetchMessagesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.params,
  }) : super.internal();

  final GetMessagesParams params;

  @override
  FutureOr<List<ChatMessageModel>?> runNotifierBuild(
    covariant FetchMessages notifier,
  ) {
    return notifier.build(
      params: params,
    );
  }

  @override
  Override overrideWith(FetchMessages Function() create) {
    return ProviderOverride(
      origin: this,
      override: FetchMessagesProvider._internal(
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
  AutoDisposeAsyncNotifierProviderElement<FetchMessages,
      List<ChatMessageModel>?> createElement() {
    return _FetchMessagesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FetchMessagesProvider && other.params == params;
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
mixin FetchMessagesRef
    on AutoDisposeAsyncNotifierProviderRef<List<ChatMessageModel>?> {
  /// The parameter `params` of this provider.
  GetMessagesParams get params;
}

class _FetchMessagesProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<FetchMessages,
        List<ChatMessageModel>?> with FetchMessagesRef {
  _FetchMessagesProviderElement(super.provider);

  @override
  GetMessagesParams get params => (origin as FetchMessagesProvider).params;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
