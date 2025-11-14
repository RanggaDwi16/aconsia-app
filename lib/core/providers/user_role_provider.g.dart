// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_role_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$userRoleHash() => r'751c736a76865b619bef76582ac692a6e59f0c18';

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

/// See also [userRole].
@ProviderFor(userRole)
const userRoleProvider = UserRoleFamily();

/// See also [userRole].
class UserRoleFamily extends Family<AsyncValue<String>> {
  /// See also [userRole].
  const UserRoleFamily();

  /// See also [userRole].
  UserRoleProvider call(
    String uid,
  ) {
    return UserRoleProvider(
      uid,
    );
  }

  @override
  UserRoleProvider getProviderOverride(
    covariant UserRoleProvider provider,
  ) {
    return call(
      provider.uid,
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
  String? get name => r'userRoleProvider';
}

/// See also [userRole].
class UserRoleProvider extends AutoDisposeFutureProvider<String> {
  /// See also [userRole].
  UserRoleProvider(
    String uid,
  ) : this._internal(
          (ref) => userRole(
            ref as UserRoleRef,
            uid,
          ),
          from: userRoleProvider,
          name: r'userRoleProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$userRoleHash,
          dependencies: UserRoleFamily._dependencies,
          allTransitiveDependencies: UserRoleFamily._allTransitiveDependencies,
          uid: uid,
        );

  UserRoleProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.uid,
  }) : super.internal();

  final String uid;

  @override
  Override overrideWith(
    FutureOr<String> Function(UserRoleRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: UserRoleProvider._internal(
        (ref) => create(ref as UserRoleRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        uid: uid,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<String> createElement() {
    return _UserRoleProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UserRoleProvider && other.uid == uid;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, uid.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin UserRoleRef on AutoDisposeFutureProviderRef<String> {
  /// The parameter `uid` of this provider.
  String get uid;
}

class _UserRoleProviderElement extends AutoDisposeFutureProviderElement<String>
    with UserRoleRef {
  _UserRoleProviderElement(super.provider);

  @override
  String get uid => (origin as UserRoleProvider).uid;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
