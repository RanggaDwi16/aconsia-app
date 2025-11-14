// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reading_session_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$readingSessionRemoteDataSourceHash() =>
    r'7872966e5ed06d520379a1835816d54aafcfa029';

/// See also [readingSessionRemoteDataSource].
@ProviderFor(readingSessionRemoteDataSource)
final readingSessionRemoteDataSourceProvider =
    AutoDisposeProvider<ReadingSessionRemoteDataSource>.internal(
  readingSessionRemoteDataSource,
  name: r'readingSessionRemoteDataSourceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$readingSessionRemoteDataSourceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ReadingSessionRemoteDataSourceRef
    = AutoDisposeProviderRef<ReadingSessionRemoteDataSource>;
String _$readingSessionRepositoryHash() =>
    r'ff88188b8895ca3fa2f8e40ad6b11db155d189d2';

/// See also [readingSessionRepository].
@ProviderFor(readingSessionRepository)
final readingSessionRepositoryProvider =
    AutoDisposeProvider<ReadingSessionRepository>.internal(
  readingSessionRepository,
  name: r'readingSessionRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$readingSessionRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ReadingSessionRepositoryRef
    = AutoDisposeProviderRef<ReadingSessionRepository>;
String _$getActiveReadingSessionsHash() =>
    r'2cff3d9ee209b745f555985c049c2e4f13dba047';

/// See also [getActiveReadingSessions].
@ProviderFor(getActiveReadingSessions)
final getActiveReadingSessionsProvider =
    AutoDisposeProvider<GetActiveReadingSessions>.internal(
  getActiveReadingSessions,
  name: r'getActiveReadingSessionsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$getActiveReadingSessionsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GetActiveReadingSessionsRef
    = AutoDisposeProviderRef<GetActiveReadingSessions>;
String _$streamActiveReadingSessionsHash() =>
    r'404274e6725e27bc8bf1daa0b2d67cd4ec58b4ef';

/// See also [streamActiveReadingSessions].
@ProviderFor(streamActiveReadingSessions)
final streamActiveReadingSessionsProvider =
    AutoDisposeProvider<StreamActiveReadingSessions>.internal(
  streamActiveReadingSessions,
  name: r'streamActiveReadingSessionsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$streamActiveReadingSessionsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef StreamActiveReadingSessionsRef
    = AutoDisposeProviderRef<StreamActiveReadingSessions>;
String _$activeReadingSessionsStreamHash() =>
    r'4f51142842c9c67e51c7f85e10e5e0bc4cfa0132';

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

/// Real-time stream provider untuk active reading sessions
///
/// Copied from [activeReadingSessionsStream].
@ProviderFor(activeReadingSessionsStream)
const activeReadingSessionsStreamProvider = ActiveReadingSessionsStreamFamily();

/// Real-time stream provider untuk active reading sessions
///
/// Copied from [activeReadingSessionsStream].
class ActiveReadingSessionsStreamFamily
    extends Family<AsyncValue<List<ReadingSessionModel>>> {
  /// Real-time stream provider untuk active reading sessions
  ///
  /// Copied from [activeReadingSessionsStream].
  const ActiveReadingSessionsStreamFamily();

  /// Real-time stream provider untuk active reading sessions
  ///
  /// Copied from [activeReadingSessionsStream].
  ActiveReadingSessionsStreamProvider call(
    String dokterId,
  ) {
    return ActiveReadingSessionsStreamProvider(
      dokterId,
    );
  }

  @override
  ActiveReadingSessionsStreamProvider getProviderOverride(
    covariant ActiveReadingSessionsStreamProvider provider,
  ) {
    return call(
      provider.dokterId,
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
  String? get name => r'activeReadingSessionsStreamProvider';
}

/// Real-time stream provider untuk active reading sessions
///
/// Copied from [activeReadingSessionsStream].
class ActiveReadingSessionsStreamProvider
    extends AutoDisposeStreamProvider<List<ReadingSessionModel>> {
  /// Real-time stream provider untuk active reading sessions
  ///
  /// Copied from [activeReadingSessionsStream].
  ActiveReadingSessionsStreamProvider(
    String dokterId,
  ) : this._internal(
          (ref) => activeReadingSessionsStream(
            ref as ActiveReadingSessionsStreamRef,
            dokterId,
          ),
          from: activeReadingSessionsStreamProvider,
          name: r'activeReadingSessionsStreamProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$activeReadingSessionsStreamHash,
          dependencies: ActiveReadingSessionsStreamFamily._dependencies,
          allTransitiveDependencies:
              ActiveReadingSessionsStreamFamily._allTransitiveDependencies,
          dokterId: dokterId,
        );

  ActiveReadingSessionsStreamProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.dokterId,
  }) : super.internal();

  final String dokterId;

  @override
  Override overrideWith(
    Stream<List<ReadingSessionModel>> Function(
            ActiveReadingSessionsStreamRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ActiveReadingSessionsStreamProvider._internal(
        (ref) => create(ref as ActiveReadingSessionsStreamRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        dokterId: dokterId,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<ReadingSessionModel>> createElement() {
    return _ActiveReadingSessionsStreamProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ActiveReadingSessionsStreamProvider &&
        other.dokterId == dokterId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, dokterId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ActiveReadingSessionsStreamRef
    on AutoDisposeStreamProviderRef<List<ReadingSessionModel>> {
  /// The parameter `dokterId` of this provider.
  String get dokterId;
}

class _ActiveReadingSessionsStreamProviderElement
    extends AutoDisposeStreamProviderElement<List<ReadingSessionModel>>
    with ActiveReadingSessionsStreamRef {
  _ActiveReadingSessionsStreamProviderElement(super.provider);

  @override
  String get dokterId =>
      (origin as ActiveReadingSessionsStreamProvider).dokterId;
}

String _$activeReadersCountHash() =>
    r'660177c5bcf26dde319264800fe87386aa19d2eb';

/// Provider untuk count active readers (simplified)
/// Counts UNIQUE pasien (not total documents)
///
/// Copied from [activeReadersCount].
@ProviderFor(activeReadersCount)
const activeReadersCountProvider = ActiveReadersCountFamily();

/// Provider untuk count active readers (simplified)
/// Counts UNIQUE pasien (not total documents)
///
/// Copied from [activeReadersCount].
class ActiveReadersCountFamily extends Family<int> {
  /// Provider untuk count active readers (simplified)
  /// Counts UNIQUE pasien (not total documents)
  ///
  /// Copied from [activeReadersCount].
  const ActiveReadersCountFamily();

  /// Provider untuk count active readers (simplified)
  /// Counts UNIQUE pasien (not total documents)
  ///
  /// Copied from [activeReadersCount].
  ActiveReadersCountProvider call(
    String dokterId,
  ) {
    return ActiveReadersCountProvider(
      dokterId,
    );
  }

  @override
  ActiveReadersCountProvider getProviderOverride(
    covariant ActiveReadersCountProvider provider,
  ) {
    return call(
      provider.dokterId,
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
  String? get name => r'activeReadersCountProvider';
}

/// Provider untuk count active readers (simplified)
/// Counts UNIQUE pasien (not total documents)
///
/// Copied from [activeReadersCount].
class ActiveReadersCountProvider extends AutoDisposeProvider<int> {
  /// Provider untuk count active readers (simplified)
  /// Counts UNIQUE pasien (not total documents)
  ///
  /// Copied from [activeReadersCount].
  ActiveReadersCountProvider(
    String dokterId,
  ) : this._internal(
          (ref) => activeReadersCount(
            ref as ActiveReadersCountRef,
            dokterId,
          ),
          from: activeReadersCountProvider,
          name: r'activeReadersCountProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$activeReadersCountHash,
          dependencies: ActiveReadersCountFamily._dependencies,
          allTransitiveDependencies:
              ActiveReadersCountFamily._allTransitiveDependencies,
          dokterId: dokterId,
        );

  ActiveReadersCountProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.dokterId,
  }) : super.internal();

  final String dokterId;

  @override
  Override overrideWith(
    int Function(ActiveReadersCountRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ActiveReadersCountProvider._internal(
        (ref) => create(ref as ActiveReadersCountRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        dokterId: dokterId,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<int> createElement() {
    return _ActiveReadersCountProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ActiveReadersCountProvider && other.dokterId == dokterId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, dokterId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ActiveReadersCountRef on AutoDisposeProviderRef<int> {
  /// The parameter `dokterId` of this provider.
  String get dokterId;
}

class _ActiveReadersCountProviderElement extends AutoDisposeProviderElement<int>
    with ActiveReadersCountRef {
  _ActiveReadersCountProviderElement(super.provider);

  @override
  String get dokterId => (origin as ActiveReadersCountProvider).dokterId;
}

String _$createOrUpdateReadingSessionHash() =>
    r'ebda2514d7d7a969417345e5c6f031feada50bde';

/// Provider untuk create or update reading session
///
/// Copied from [CreateOrUpdateReadingSession].
@ProviderFor(CreateOrUpdateReadingSession)
final createOrUpdateReadingSessionProvider = AutoDisposeAsyncNotifierProvider<
    CreateOrUpdateReadingSession, ReadingSessionModel?>.internal(
  CreateOrUpdateReadingSession.new,
  name: r'createOrUpdateReadingSessionProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$createOrUpdateReadingSessionHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$CreateOrUpdateReadingSession
    = AutoDisposeAsyncNotifier<ReadingSessionModel?>;
String _$endReadingSessionHash() => r'009bf3a8c8e7009c8540298eb62b9775f0240768';

/// Provider untuk end reading session
///
/// Copied from [EndReadingSession].
@ProviderFor(EndReadingSession)
final endReadingSessionProvider =
    AutoDisposeAsyncNotifierProvider<EndReadingSession, bool>.internal(
  EndReadingSession.new,
  name: r'endReadingSessionProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$endReadingSessionHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$EndReadingSession = AutoDisposeAsyncNotifier<bool>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
