// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'match_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$matchRemoteDataSourceHash() =>
    r'ef71a2aefc48785bb05a9d860e9d10d8de8892ba';

/// Provides Match remote data source
///
/// Copied from [matchRemoteDataSource].
@ProviderFor(matchRemoteDataSource)
final matchRemoteDataSourceProvider =
    AutoDisposeProvider<MatchRemoteDataSource>.internal(
  matchRemoteDataSource,
  name: r'matchRemoteDataSourceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$matchRemoteDataSourceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MatchRemoteDataSourceRef
    = AutoDisposeProviderRef<MatchRemoteDataSource>;
String _$matchRepositoryHash() => r'0439df540f4ed67454a684dbc52074bc1f0f977d';

/// Provides Match repository
///
/// Copied from [matchRepository].
@ProviderFor(matchRepository)
final matchRepositoryProvider = AutoDisposeProvider<MatchRepository>.internal(
  matchRepository,
  name: r'matchRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$matchRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MatchRepositoryRef = AutoDisposeProviderRef<MatchRepository>;
String _$userMatchesHash() => r'bf726504823c07de464ef8a9000eeebe6fccb249';

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

/// Fetches all matches for a user
///
/// Copied from [userMatches].
@ProviderFor(userMatches)
const userMatchesProvider = UserMatchesFamily();

/// Fetches all matches for a user
///
/// Copied from [userMatches].
class UserMatchesFamily extends Family<AsyncValue<List<MatchEntity>>> {
  /// Fetches all matches for a user
  ///
  /// Copied from [userMatches].
  const UserMatchesFamily();

  /// Fetches all matches for a user
  ///
  /// Copied from [userMatches].
  UserMatchesProvider call(
    String userId,
  ) {
    return UserMatchesProvider(
      userId,
    );
  }

  @override
  UserMatchesProvider getProviderOverride(
    covariant UserMatchesProvider provider,
  ) {
    return call(
      provider.userId,
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
  String? get name => r'userMatchesProvider';
}

/// Fetches all matches for a user
///
/// Copied from [userMatches].
class UserMatchesProvider extends AutoDisposeFutureProvider<List<MatchEntity>> {
  /// Fetches all matches for a user
  ///
  /// Copied from [userMatches].
  UserMatchesProvider(
    String userId,
  ) : this._internal(
          (ref) => userMatches(
            ref as UserMatchesRef,
            userId,
          ),
          from: userMatchesProvider,
          name: r'userMatchesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$userMatchesHash,
          dependencies: UserMatchesFamily._dependencies,
          allTransitiveDependencies:
              UserMatchesFamily._allTransitiveDependencies,
          userId: userId,
        );

  UserMatchesProvider._internal(
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
    FutureOr<List<MatchEntity>> Function(UserMatchesRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: UserMatchesProvider._internal(
        (ref) => create(ref as UserMatchesRef),
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
  AutoDisposeFutureProviderElement<List<MatchEntity>> createElement() {
    return _UserMatchesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UserMatchesProvider && other.userId == userId;
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
mixin UserMatchesRef on AutoDisposeFutureProviderRef<List<MatchEntity>> {
  /// The parameter `userId` of this provider.
  String get userId;
}

class _UserMatchesProviderElement
    extends AutoDisposeFutureProviderElement<List<MatchEntity>>
    with UserMatchesRef {
  _UserMatchesProviderElement(super.provider);

  @override
  String get userId => (origin as UserMatchesProvider).userId;
}

String _$userMatchesBySportHash() =>
    r'0f7dc98521a47234f299222c89ccf50e87af4403';

/// Fetches matches for a user filtered by sport
///
/// Copied from [userMatchesBySport].
@ProviderFor(userMatchesBySport)
const userMatchesBySportProvider = UserMatchesBySportFamily();

/// Fetches matches for a user filtered by sport
///
/// Copied from [userMatchesBySport].
class UserMatchesBySportFamily extends Family<AsyncValue<List<MatchEntity>>> {
  /// Fetches matches for a user filtered by sport
  ///
  /// Copied from [userMatchesBySport].
  const UserMatchesBySportFamily();

  /// Fetches matches for a user filtered by sport
  ///
  /// Copied from [userMatchesBySport].
  UserMatchesBySportProvider call(
    String userId,
    String sport,
  ) {
    return UserMatchesBySportProvider(
      userId,
      sport,
    );
  }

  @override
  UserMatchesBySportProvider getProviderOverride(
    covariant UserMatchesBySportProvider provider,
  ) {
    return call(
      provider.userId,
      provider.sport,
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
  String? get name => r'userMatchesBySportProvider';
}

/// Fetches matches for a user filtered by sport
///
/// Copied from [userMatchesBySport].
class UserMatchesBySportProvider
    extends AutoDisposeFutureProvider<List<MatchEntity>> {
  /// Fetches matches for a user filtered by sport
  ///
  /// Copied from [userMatchesBySport].
  UserMatchesBySportProvider(
    String userId,
    String sport,
  ) : this._internal(
          (ref) => userMatchesBySport(
            ref as UserMatchesBySportRef,
            userId,
            sport,
          ),
          from: userMatchesBySportProvider,
          name: r'userMatchesBySportProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$userMatchesBySportHash,
          dependencies: UserMatchesBySportFamily._dependencies,
          allTransitiveDependencies:
              UserMatchesBySportFamily._allTransitiveDependencies,
          userId: userId,
          sport: sport,
        );

  UserMatchesBySportProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.userId,
    required this.sport,
  }) : super.internal();

  final String userId;
  final String sport;

  @override
  Override overrideWith(
    FutureOr<List<MatchEntity>> Function(UserMatchesBySportRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: UserMatchesBySportProvider._internal(
        (ref) => create(ref as UserMatchesBySportRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        userId: userId,
        sport: sport,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<MatchEntity>> createElement() {
    return _UserMatchesBySportProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UserMatchesBySportProvider &&
        other.userId == userId &&
        other.sport == sport;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, userId.hashCode);
    hash = _SystemHash.combine(hash, sport.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin UserMatchesBySportRef on AutoDisposeFutureProviderRef<List<MatchEntity>> {
  /// The parameter `userId` of this provider.
  String get userId;

  /// The parameter `sport` of this provider.
  String get sport;
}

class _UserMatchesBySportProviderElement
    extends AutoDisposeFutureProviderElement<List<MatchEntity>>
    with UserMatchesBySportRef {
  _UserMatchesBySportProviderElement(super.provider);

  @override
  String get userId => (origin as UserMatchesBySportProvider).userId;
  @override
  String get sport => (origin as UserMatchesBySportProvider).sport;
}

String _$matchByIdHash() => r'2c99ffea9fde9b27dc1ebb1dbb810ce82990ff2a';

/// Fetches a single match by ID
///
/// Copied from [matchById].
@ProviderFor(matchById)
const matchByIdProvider = MatchByIdFamily();

/// Fetches a single match by ID
///
/// Copied from [matchById].
class MatchByIdFamily extends Family<AsyncValue<MatchEntity>> {
  /// Fetches a single match by ID
  ///
  /// Copied from [matchById].
  const MatchByIdFamily();

  /// Fetches a single match by ID
  ///
  /// Copied from [matchById].
  MatchByIdProvider call(
    String matchId,
  ) {
    return MatchByIdProvider(
      matchId,
    );
  }

  @override
  MatchByIdProvider getProviderOverride(
    covariant MatchByIdProvider provider,
  ) {
    return call(
      provider.matchId,
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
  String? get name => r'matchByIdProvider';
}

/// Fetches a single match by ID
///
/// Copied from [matchById].
class MatchByIdProvider extends AutoDisposeFutureProvider<MatchEntity> {
  /// Fetches a single match by ID
  ///
  /// Copied from [matchById].
  MatchByIdProvider(
    String matchId,
  ) : this._internal(
          (ref) => matchById(
            ref as MatchByIdRef,
            matchId,
          ),
          from: matchByIdProvider,
          name: r'matchByIdProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$matchByIdHash,
          dependencies: MatchByIdFamily._dependencies,
          allTransitiveDependencies: MatchByIdFamily._allTransitiveDependencies,
          matchId: matchId,
        );

  MatchByIdProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.matchId,
  }) : super.internal();

  final String matchId;

  @override
  Override overrideWith(
    FutureOr<MatchEntity> Function(MatchByIdRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: MatchByIdProvider._internal(
        (ref) => create(ref as MatchByIdRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        matchId: matchId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<MatchEntity> createElement() {
    return _MatchByIdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MatchByIdProvider && other.matchId == matchId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, matchId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin MatchByIdRef on AutoDisposeFutureProviderRef<MatchEntity> {
  /// The parameter `matchId` of this provider.
  String get matchId;
}

class _MatchByIdProviderElement
    extends AutoDisposeFutureProviderElement<MatchEntity> with MatchByIdRef {
  _MatchByIdProviderElement(super.provider);

  @override
  String get matchId => (origin as MatchByIdProvider).matchId;
}

String _$watchUserMatchesHash() => r'4be6428f019213453178d8b1b9e6f344a54e4365';

/// Watches user matches in real-time
///
/// Copied from [watchUserMatches].
@ProviderFor(watchUserMatches)
const watchUserMatchesProvider = WatchUserMatchesFamily();

/// Watches user matches in real-time
///
/// Copied from [watchUserMatches].
class WatchUserMatchesFamily extends Family<AsyncValue<List<MatchEntity>>> {
  /// Watches user matches in real-time
  ///
  /// Copied from [watchUserMatches].
  const WatchUserMatchesFamily();

  /// Watches user matches in real-time
  ///
  /// Copied from [watchUserMatches].
  WatchUserMatchesProvider call(
    String userId,
  ) {
    return WatchUserMatchesProvider(
      userId,
    );
  }

  @override
  WatchUserMatchesProvider getProviderOverride(
    covariant WatchUserMatchesProvider provider,
  ) {
    return call(
      provider.userId,
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
  String? get name => r'watchUserMatchesProvider';
}

/// Watches user matches in real-time
///
/// Copied from [watchUserMatches].
class WatchUserMatchesProvider
    extends AutoDisposeStreamProvider<List<MatchEntity>> {
  /// Watches user matches in real-time
  ///
  /// Copied from [watchUserMatches].
  WatchUserMatchesProvider(
    String userId,
  ) : this._internal(
          (ref) => watchUserMatches(
            ref as WatchUserMatchesRef,
            userId,
          ),
          from: watchUserMatchesProvider,
          name: r'watchUserMatchesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$watchUserMatchesHash,
          dependencies: WatchUserMatchesFamily._dependencies,
          allTransitiveDependencies:
              WatchUserMatchesFamily._allTransitiveDependencies,
          userId: userId,
        );

  WatchUserMatchesProvider._internal(
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
    Stream<List<MatchEntity>> Function(WatchUserMatchesRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: WatchUserMatchesProvider._internal(
        (ref) => create(ref as WatchUserMatchesRef),
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
  AutoDisposeStreamProviderElement<List<MatchEntity>> createElement() {
    return _WatchUserMatchesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is WatchUserMatchesProvider && other.userId == userId;
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
mixin WatchUserMatchesRef on AutoDisposeStreamProviderRef<List<MatchEntity>> {
  /// The parameter `userId` of this provider.
  String get userId;
}

class _WatchUserMatchesProviderElement
    extends AutoDisposeStreamProviderElement<List<MatchEntity>>
    with WatchUserMatchesRef {
  _WatchUserMatchesProviderElement(super.provider);

  @override
  String get userId => (origin as WatchUserMatchesProvider).userId;
}

String _$userMatchStatsHash() => r'cb63abf3f55e4c118bba2da3818ecdd2b86589d6';

/// Computes match statistics for a user
///
/// Copied from [userMatchStats].
@ProviderFor(userMatchStats)
const userMatchStatsProvider = UserMatchStatsFamily();

/// Computes match statistics for a user
///
/// Copied from [userMatchStats].
class UserMatchStatsFamily extends Family<AsyncValue<MatchStats>> {
  /// Computes match statistics for a user
  ///
  /// Copied from [userMatchStats].
  const UserMatchStatsFamily();

  /// Computes match statistics for a user
  ///
  /// Copied from [userMatchStats].
  UserMatchStatsProvider call(
    String userId,
  ) {
    return UserMatchStatsProvider(
      userId,
    );
  }

  @override
  UserMatchStatsProvider getProviderOverride(
    covariant UserMatchStatsProvider provider,
  ) {
    return call(
      provider.userId,
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
  String? get name => r'userMatchStatsProvider';
}

/// Computes match statistics for a user
///
/// Copied from [userMatchStats].
class UserMatchStatsProvider extends AutoDisposeFutureProvider<MatchStats> {
  /// Computes match statistics for a user
  ///
  /// Copied from [userMatchStats].
  UserMatchStatsProvider(
    String userId,
  ) : this._internal(
          (ref) => userMatchStats(
            ref as UserMatchStatsRef,
            userId,
          ),
          from: userMatchStatsProvider,
          name: r'userMatchStatsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$userMatchStatsHash,
          dependencies: UserMatchStatsFamily._dependencies,
          allTransitiveDependencies:
              UserMatchStatsFamily._allTransitiveDependencies,
          userId: userId,
        );

  UserMatchStatsProvider._internal(
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
    FutureOr<MatchStats> Function(UserMatchStatsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: UserMatchStatsProvider._internal(
        (ref) => create(ref as UserMatchStatsRef),
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
  AutoDisposeFutureProviderElement<MatchStats> createElement() {
    return _UserMatchStatsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UserMatchStatsProvider && other.userId == userId;
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
mixin UserMatchStatsRef on AutoDisposeFutureProviderRef<MatchStats> {
  /// The parameter `userId` of this provider.
  String get userId;
}

class _UserMatchStatsProviderElement
    extends AutoDisposeFutureProviderElement<MatchStats>
    with UserMatchStatsRef {
  _UserMatchStatsProviderElement(super.provider);

  @override
  String get userId => (origin as UserMatchStatsProvider).userId;
}

String _$userMatchStatsBySportHash() =>
    r'2ec9073b7c14361837ba80658dcb297005efc6fb';

/// Computes match statistics by sport
///
/// Copied from [userMatchStatsBySport].
@ProviderFor(userMatchStatsBySport)
const userMatchStatsBySportProvider = UserMatchStatsBySportFamily();

/// Computes match statistics by sport
///
/// Copied from [userMatchStatsBySport].
class UserMatchStatsBySportFamily extends Family<AsyncValue<MatchStats>> {
  /// Computes match statistics by sport
  ///
  /// Copied from [userMatchStatsBySport].
  const UserMatchStatsBySportFamily();

  /// Computes match statistics by sport
  ///
  /// Copied from [userMatchStatsBySport].
  UserMatchStatsBySportProvider call(
    String userId,
    String sport,
  ) {
    return UserMatchStatsBySportProvider(
      userId,
      sport,
    );
  }

  @override
  UserMatchStatsBySportProvider getProviderOverride(
    covariant UserMatchStatsBySportProvider provider,
  ) {
    return call(
      provider.userId,
      provider.sport,
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
  String? get name => r'userMatchStatsBySportProvider';
}

/// Computes match statistics by sport
///
/// Copied from [userMatchStatsBySport].
class UserMatchStatsBySportProvider
    extends AutoDisposeFutureProvider<MatchStats> {
  /// Computes match statistics by sport
  ///
  /// Copied from [userMatchStatsBySport].
  UserMatchStatsBySportProvider(
    String userId,
    String sport,
  ) : this._internal(
          (ref) => userMatchStatsBySport(
            ref as UserMatchStatsBySportRef,
            userId,
            sport,
          ),
          from: userMatchStatsBySportProvider,
          name: r'userMatchStatsBySportProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$userMatchStatsBySportHash,
          dependencies: UserMatchStatsBySportFamily._dependencies,
          allTransitiveDependencies:
              UserMatchStatsBySportFamily._allTransitiveDependencies,
          userId: userId,
          sport: sport,
        );

  UserMatchStatsBySportProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.userId,
    required this.sport,
  }) : super.internal();

  final String userId;
  final String sport;

  @override
  Override overrideWith(
    FutureOr<MatchStats> Function(UserMatchStatsBySportRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: UserMatchStatsBySportProvider._internal(
        (ref) => create(ref as UserMatchStatsBySportRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        userId: userId,
        sport: sport,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<MatchStats> createElement() {
    return _UserMatchStatsBySportProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UserMatchStatsBySportProvider &&
        other.userId == userId &&
        other.sport == sport;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, userId.hashCode);
    hash = _SystemHash.combine(hash, sport.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin UserMatchStatsBySportRef on AutoDisposeFutureProviderRef<MatchStats> {
  /// The parameter `userId` of this provider.
  String get userId;

  /// The parameter `sport` of this provider.
  String get sport;
}

class _UserMatchStatsBySportProviderElement
    extends AutoDisposeFutureProviderElement<MatchStats>
    with UserMatchStatsBySportRef {
  _UserMatchStatsBySportProviderElement(super.provider);

  @override
  String get userId => (origin as UserMatchStatsBySportProvider).userId;
  @override
  String get sport => (origin as UserMatchStatsBySportProvider).sport;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
