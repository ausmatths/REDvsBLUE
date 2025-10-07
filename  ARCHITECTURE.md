# REDvsBLUE Architecture Documentation

This document provides a comprehensive explanation of the Clean Architecture pattern implemented in the REDvsBLUE mobile application.

## 📋 Table of Contents

- [Architecture Overview](#architecture-overview)
- [Clean Architecture Principles](#clean-architecture-principles)
- [Layer Breakdown](#layer-breakdown)
- [Data Flow](#data-flow)
- [Dependency Management](#dependency-management)
- [State Management](#state-management)
- [Error Handling Strategy](#error-handling-strategy)
- [Feature Module Structure](#feature-module-structure)
- [Design Patterns](#design-patterns)
- [Best Practices](#best-practices)
- [Common Pitfalls](#common-pitfalls)
- [Real-World Examples](#real-world-examples)

---

## 🏛️ Architecture Overview

REDvsBLUE follows **Clean Architecture** (also known as Onion Architecture or Hexagonal Architecture), a software design philosophy that emphasizes separation of concerns and independence of frameworks, UI, and external agencies.

### Why Clean Architecture?

**Benefits:**
- ✅ **Testability**: Easy to unit test business logic
- ✅ **Maintainability**: Clear separation makes changes easier
- ✅ **Scalability**: Easy to add new features without affecting existing code
- ✅ **Independence**: Business logic doesn't depend on UI or frameworks
- ✅ **Flexibility**: Easy to swap implementations (e.g., change from Firebase to REST API)
- ✅ **Team Collaboration**: Clear boundaries allow parallel development

**Trade-offs:**
- ⚠️ Initial setup requires more boilerplate code
- ⚠️ Steeper learning curve for new developers
- ⚠️ More files and folders to navigate
- ⚠️ May feel like overkill for very simple features

However, for a complex app like REDvsBLUE with multiple sports, matchmaking algorithms, tournaments, and real-time features, the benefits far outweigh the costs.

---

## 🎯 Clean Architecture Principles

### 1. The Dependency Rule

**The Golden Rule**: Dependencies should only point inward toward higher-level policies.

```
┌─────────────────────────────────────────────────────────────┐
│                                                               │
│    ┌───────────────────────────────────────────────────┐    │
│    │                                                     │    │
│    │   ┌────────────────────────────────────────┐      │    │
│    │   │                                          │      │    │
│    │   │   ┌─────────────────────────────┐      │      │    │
│    │   │   │                               │      │      │    │
│    │   │   │  DOMAIN (Entities, Use Cases) │      │      │    │
│    │   │   │  - Pure Business Logic        │      │      │    │
│    │   │   │  - No External Dependencies   │      │      │    │
│    │   │   │                               │      │      │    │
│    │   │   └─────────────────────────────┘      │      │    │
│    │   │                                          │      │    │
│    │   │   DATA LAYER                            │      │    │
│    │   │   - Repository Implementations          │      │    │
│    │   │   - Data Sources (API, DB)              │      │    │
│    │   │   - Models                               │      │    │
│    │   │                                          │      │    │
│    │   └────────────────────────────────────────┘      │    │
│    │                                                     │    │
│    │   PRESENTATION LAYER                               │    │
│    │   - UI (Screens, Widgets)                          │    │
│    │   - State Management (Providers)                   │    │
│    │   - View Logic                                     │    │
│    │                                                     │    │
│    └───────────────────────────────────────────────────┘    │
│                                                               │
│    EXTERNAL (Frameworks, Devices, Web)                       │
│                                                               │
└─────────────────────────────────────────────────────────────┘

     Inner layers don't know about outer layers
              ←←←← Dependencies flow inward ←←←←
```

### 2. Single Responsibility Principle (SRP)

Each class/module should have **one reason to change**.

**Example:**
```dart
// ❌ BAD: Class has multiple responsibilities
class User {
  String name;
  
  void saveToDatabase() { } // Database responsibility
  void sendEmail() { }       // Email responsibility
  void validateData() { }    // Validation responsibility
}

// ✅ GOOD: Each class has one responsibility
class User {
  final String name;
}

class UserRepository {
  void save(User user) { }
}

class EmailService {
  void sendEmail(User user) { }
}

class UserValidator {
  bool validate(User user) { }
}
```

### 3. Dependency Inversion Principle (DIP)

High-level modules should not depend on low-level modules. Both should depend on abstractions.

**Example:**
```dart
// ❌ BAD: Direct dependency on concrete implementation
class MatchmakingService {
  final FirebaseDataSource dataSource; // Coupled to Firebase
  
  MatchmakingService(this.dataSource);
}

// ✅ GOOD: Depends on abstraction
abstract class MatchDataSource {
  Future<List<Match>> getMatches();
}

class MatchmakingService {
  final MatchDataSource dataSource; // Can be any implementation
  
  MatchmakingService(this.dataSource);
}

// Implementations
class FirebaseMatchDataSource implements MatchDataSource { }
class RestApiMatchDataSource implements MatchDataSource { }
```

### 4. Interface Segregation Principle (ISP)

Clients should not be forced to depend on interfaces they don't use.

```dart
// ❌ BAD: Fat interface
abstract class UserRepository {
  Future<User> getUser(String id);
  Future<void> saveUser(User user);
  Future<void> deleteUser(String id);
  Future<void> sendPasswordReset(String email); // Not always needed
  Future<void> updateUserAvatar(String id, File image); // Not always needed
}

// ✅ GOOD: Segregated interfaces
abstract class UserReader {
  Future<User> getUser(String id);
}

abstract class UserWriter {
  Future<void> saveUser(User user);
  Future<void> deleteUser(String id);
}

abstract class UserAuthManager {
  Future<void> sendPasswordReset(String email);
}
```

### 5. Open/Closed Principle (OCP)

Software entities should be **open for extension** but **closed for modification**.

```dart
// ✅ GOOD: Can add new sports without modifying existing code
abstract class Sport {
  String get name;
  int get maxPlayers;
}

class Badminton implements Sport {
  @override
  String get name => 'Badminton';
  
  @override
  int get maxPlayers => 4;
}

class Football implements Sport {
  @override
  String get name => 'Football';
  
  @override
  int get maxPlayers => 22;
}

// New sport can be added without changing existing code
class Basketball implements Sport {
  @override
  String get name => 'Basketball';
  
  @override
  int get maxPlayers => 10;
}
```

---

## 📦 Layer Breakdown

### Domain Layer (Core Business Logic)

**Location**: `lib/features/[feature]/domain/`

**Purpose**: Contains enterprise-wide business rules and application business rules.

**Components**:

#### 1. Entities

Pure business objects representing core concepts.

```dart
// lib/features/matchmaking/domain/entities/match_entity.dart
import 'package:equatable/equatable.dart';

/// Represents a sports match in the system
/// 
/// This is a pure domain entity with no external dependencies
class MatchEntity extends Equatable {
  final String id;
  final String sport;
  final List<String> playerIds;
  final String venueId;
  final DateTime scheduledTime;
  final MatchStatus status;
  
  const MatchEntity({
    required this.id,
    required this.sport,
    required this.playerIds,
    required this.venueId,
    required this.scheduledTime,
    required this.status,
  });
  
  /// Business rule: Check if match is upcoming
  bool get isUpcoming {
    return status == MatchStatus.scheduled && 
           scheduledTime.isAfter(DateTime.now());
  }
  
  /// Business rule: Check if match can be cancelled
  bool get canBeCancelled {
    final hoursUntilMatch = scheduledTime.difference(DateTime.now()).inHours;
    return status == MatchStatus.scheduled && hoursUntilMatch > 2;
  }
  
  @override
  List<Object?> get props => [
    id,
    sport,
    playerIds,
    venueId,
    scheduledTime,
    status,
  ];
}

enum MatchStatus {
  scheduled,
  inProgress,
  completed,
  cancelled,
}
```

**Characteristics**:
- ✅ Pure Dart (no Flutter imports)
- ✅ Immutable (all fields `final`)
- ✅ Contains business logic (rules, validation)
- ✅ Uses `Equatable` for value comparison
- ✅ No external dependencies

#### 2. Repository Interfaces

Contracts defining how data operations should work.

```dart
// lib/features/matchmaking/domain/repositories/match_repository.dart
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/match_entity.dart';

/// Repository interface for match operations
/// 
/// Defines the contract without implementation details
/// Implementation is in the data layer
abstract class MatchRepository {
  /// Fetches upcoming matches for a player
  /// 
  /// Returns [Right] with list of matches on success
  /// Returns [Left] with [Failure] on error
  Future<Either<Failure, List<MatchEntity>>> getUpcomingMatches(
    String playerId,
  );
  
  /// Creates a new match
  /// 
  /// [match]: The match to create
  /// Returns the created match with generated ID
  Future<Either<Failure, MatchEntity>> createMatch(MatchEntity match);
  
  /// Updates match status
  /// 
  /// [matchId]: ID of the match to update
  /// [status]: New status
  Future<Either<Failure, MatchEntity>> updateMatchStatus(
    String matchId,
    MatchStatus status,
  );
  
  /// Cancels a match if allowed by business rules
  /// 
  /// [matchId]: ID of the match to cancel
  /// Returns error if match cannot be cancelled
  Future<Either<Failure, void>> cancelMatch(String matchId);
}
```

**Why `Either<Failure, T>`?**
- ✅ Forces explicit error handling
- ✅ Makes success and failure paths clear
- ✅ No exceptions for expected errors
- ✅ Composable and functional

#### 3. Use Cases

Single-purpose actions representing application business rules.

```dart
// lib/features/matchmaking/domain/usecases/get_upcoming_matches.dart
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/match_entity.dart';
import '../repositories/match_repository.dart';

/// Use case for retrieving upcoming matches for a player
/// 
/// Single Responsibility: Get upcoming matches
/// 
/// Example:
/// ```dart
/// final useCase = GetUpcomingMatches(repository);
/// final result = await useCase(playerId: 'user123');
/// 
/// result.fold(
///   (failure) => print('Error: ${failure.message}'),
///   (matches) => print('Found ${matches.length} matches'),
/// );
/// ```
class GetUpcomingMatches {
  final MatchRepository repository;
  
  GetUpcomingMatches(this.repository);
  
  /// Executes the use case
  /// 
  /// [playerId]: ID of the player to get matches for
  /// Returns list of upcoming matches or a failure
  Future<Either<Failure, List<MatchEntity>>> call({
    required String playerId,
  }) async {
    // Could add business logic here, e.g.:
    // - Validate player ID
    // - Filter matches by date range
    // - Sort matches by priority
    
    return await repository.getUpcomingMatches(playerId);
  }
}
```

```dart
// lib/features/matchmaking/domain/usecases/cancel_match.dart
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/match_repository.dart';

/// Use case for cancelling a match
/// 
/// Encapsulates the business logic for match cancellation
class CancelMatch {
  final MatchRepository repository;
  
  CancelMatch(this.repository);
  
  Future<Either<Failure, void>> call({
    required String matchId,
  }) async {
    // Business logic: Could add additional checks here
    // e.g., verify user permissions, check time limits, etc.
    
    return await repository.cancelMatch(matchId);
  }
}
```

**Use Case Characteristics**:
- ✅ One class per action
- ✅ Uses `call()` method for execution
- ✅ Orchestrates business logic
- ✅ Depends only on repository interfaces
- ✅ Easy to test in isolation

---

### Data Layer (Data Management)

**Location**: `lib/features/[feature]/data/`

**Purpose**: Handles data operations, API calls, and data transformations.

**Components**:

#### 1. Models

Data transfer objects that handle serialization/deserialization.

```dart
// lib/features/matchmaking/data/models/match_model.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/match_entity.dart';

part 'match_model.freezed.dart';
part 'match_model.g.dart';

/// Data model for [MatchEntity]
/// 
/// Handles JSON serialization and conversion to/from domain entity
@freezed
class MatchModel with _$MatchModel {
  const factory MatchModel({
    required String id,
    required String sport,
    required List<String> playerIds,
    required String venueId,
    required DateTime scheduledTime,
    required String status, // String in API, enum in domain
  }) = _MatchModel;
  
  /// Creates model from JSON (API response)
  factory MatchModel.fromJson(Map<String, dynamic> json) =>
      _$MatchModelFromJson(json);
}

/// Extension to convert model to entity
extension MatchModelX on MatchModel {
  MatchEntity toEntity() {
    return MatchEntity(
      id: id,
      sport: sport,
      playerIds: playerIds,
      venueId: venueId,
      scheduledTime: scheduledTime,
      status: _parseStatus(status),
    );
  }
  
  MatchStatus _parseStatus(String status) {
    switch (status.toLowerCase()) {
      case 'scheduled':
        return MatchStatus.scheduled;
      case 'in_progress':
        return MatchStatus.inProgress;
      case 'completed':
        return MatchStatus.completed;
      case 'cancelled':
        return MatchStatus.cancelled;
      default:
        return MatchStatus.scheduled;
    }
  }
}

/// Extension to convert entity to model
extension MatchEntityX on MatchEntity {
  MatchModel toModel() {
    return MatchModel(
      id: id,
      sport: sport,
      playerIds: playerIds,
      venueId: venueId,
      scheduledTime: scheduledTime,
      status: status.name,
    );
  }
}
```

**Model Characteristics**:
- ✅ Uses `@freezed` for immutability and code generation
- ✅ Handles JSON serialization
- ✅ Converts between domain entities and API formats
- ✅ Maps different data representations (e.g., string ↔ enum)

#### 2. Data Sources

Handle raw data operations (API calls, database queries).

```dart
// lib/features/matchmaking/data/datasources/match_remote_data_source.dart
import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/match_model.dart';

/// Remote data source for match operations
/// 
/// Handles all API calls related to matches
abstract class MatchRemoteDataSource {
  Future<List<MatchModel>> getUpcomingMatches(String playerId);
  Future<MatchModel> createMatch(MatchModel match);
  Future<MatchModel> updateMatchStatus(String matchId, String status);
  Future<void> cancelMatch(String matchId);
}

class MatchRemoteDataSourceImpl implements MatchRemoteDataSource {
  final DioClient dioClient;
  
  MatchRemoteDataSourceImpl(this.dioClient);
  
  @override
  Future<List<MatchModel>> getUpcomingMatches(String playerId) async {
    try {
      final response = await dioClient.get(
        ApiEndpoints.upcomingMatches,
        queryParameters: {'player_id': playerId},
      );
      
      // Handle API response structure
      final List<dynamic> data = response.data['data'] ?? [];
      return data.map((json) => MatchModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ServerException(message: 'Unexpected error: $e');
    }
  }
  
  @override
  Future<MatchModel> createMatch(MatchModel match) async {
    try {
      final response = await dioClient.post(
        ApiEndpoints.matches,
        data: match.toJson(),
      );
      
      return MatchModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }
  
  @override
  Future<void> cancelMatch(String matchId) async {
    try {
      await dioClient.delete(
        ApiEndpoints.matchById(matchId),
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }
  
  /// Converts Dio errors to domain exceptions
  Exception _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return NetworkException(message: 'Connection timeout');
      
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        if (statusCode == 400) {
          return ValidationException(
            message: e.response?.data['message'] ?? 'Invalid request',
          );
        } else if (statusCode == 404) {
          return NotFoundException(message: 'Resource not found');
        } else if (statusCode == 401 || statusCode == 403) {
          return UnauthorizedException(message: 'Authentication required');
        }
        return ServerException(
          message: e.response?.data['message'] ?? 'Server error',
        );
      
      case DioExceptionType.cancel:
        return CancelException(message: 'Request cancelled');
      
      default:
        return NetworkException(message: 'Network error occurred');
    }
  }
  
  @override
  Future<MatchModel> updateMatchStatus(String matchId, String status) async {
    try {
      final response = await dioClient.patch(
        ApiEndpoints.matchById(matchId),
        data: {'status': status},
      );
      
      return MatchModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }
}
```

**Data Source Characteristics**:
- ✅ Abstract interface + concrete implementation
- ✅ Handles all external communication
- ✅ Converts HTTP errors to domain exceptions
- ✅ Works with models, not entities
- ✅ Single source of truth for API calls

#### 3. Repository Implementation

Implements the domain repository interface.

```dart
// lib/features/matchmaking/data/repositories/match_repository_impl.dart
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/errors/exceptions.dart';
import '../../domain/entities/match_entity.dart';
import '../../domain/repositories/match_repository.dart';
import '../datasources/match_remote_data_source.dart';
import '../models/match_model.dart';

/// Implementation of [MatchRepository]
/// 
/// Coordinates between data sources and converts exceptions to failures
class MatchRepositoryImpl implements MatchRepository {
  final MatchRemoteDataSource remoteDataSource;
  
  MatchRepositoryImpl(this.remoteDataSource);
  
  @override
  Future<Either<Failure, List<MatchEntity>>> getUpcomingMatches(
    String playerId,
  ) async {
    try {
      // 1. Fetch models from data source
      final models = await remoteDataSource.getUpcomingMatches(playerId);
      
      // 2. Convert models to entities
      final entities = models.map((model) => model.toEntity()).toList();
      
      // 3. Return success
      return Right(entities);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on NotFoundException catch (e) {
      return Left(NotFoundFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, MatchEntity>> createMatch(MatchEntity match) async {
    try {
      // 1. Convert entity to model
      final model = match.toModel();
      
      // 2. Send to data source
      final resultModel = await remoteDataSource.createMatch(model);
      
      // 3. Convert back to entity and return
      return Right(resultModel.toEntity());
    } on ValidationException catch (e) {
      return Left(ValidationFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, void>> cancelMatch(String matchId) async {
    try {
      await remoteDataSource.cancelMatch(matchId);
      return const Right(null);
    } on NotFoundException catch (e) {
      return Left(NotFoundFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, MatchEntity>> updateMatchStatus(
    String matchId,
    MatchStatus status,
  ) async {
    try {
      final model = await remoteDataSource.updateMatchStatus(
        matchId,
        status.name,
      );
      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }
}
```

**Repository Implementation Characteristics**:
- ✅ Implements domain repository interface
- ✅ Coordinates between data sources
- ✅ Converts exceptions to failures
- ✅ Converts models to entities
- ✅ Handles error cases comprehensively
- ✅ Can combine multiple data sources (cache + remote)

---

### Presentation Layer (UI & State)

**Location**: `lib/features/[feature]/presentation/`

**Purpose**: Handles UI rendering and user interactions.

**Components**:

#### 1. Riverpod Providers

Manage state and dependency injection.

```dart
// lib/features/matchmaking/presentation/providers/match_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/network/dio_client.dart';
import '../../data/datasources/match_remote_data_source.dart';
import '../../data/repositories/match_repository_impl.dart';
import '../../domain/entities/match_entity.dart';
import '../../domain/repositories/match_repository.dart';
import '../../domain/usecases/get_upcoming_matches.dart';
import '../../domain/usecases/cancel_match.dart';

part 'match_provider.g.dart';

// ============================================================================
// DEPENDENCY PROVIDERS (Singleton)
// ============================================================================

/// Provides the data source
@riverpod
MatchRemoteDataSource matchRemoteDataSource(MatchRemoteDataSourceRef ref) {
  final dioClient = ref.watch(dioClientProvider);
  return MatchRemoteDataSourceImpl(dioClient);
}

/// Provides the repository
@riverpod
MatchRepository matchRepository(MatchRepositoryRef ref) {
  final dataSource = ref.watch(matchRemoteDataSourceProvider);
  return MatchRepositoryImpl(dataSource);
}

/// Provides the get matches use case
@riverpod
GetUpcomingMatches getUpcomingMatches(GetUpcomingMatchesRef ref) {
  final repository = ref.watch(matchRepositoryProvider);
  return GetUpcomingMatches(repository);
}

/// Provides the cancel match use case
@riverpod
CancelMatch cancelMatch(CancelMatchRef ref) {
  final repository = ref.watch(matchRepositoryProvider);
  return CancelMatch(repository);
}

// ============================================================================
// STATE PROVIDERS
// ============================================================================

/// State provider for upcoming matches
/// 
/// Automatically fetches matches when watched
/// Provides refresh and mutation methods
@riverpod
class UpcomingMatches extends _$UpcomingMatches {
  @override
  Future<List<MatchEntity>> build(String playerId) async {
    return await _fetchMatches();
  }
  
  /// Fetches matches from the repository
  Future<List<MatchEntity>> _fetchMatches() async {
    final getMatchesUseCase = ref.read(getUpcomingMatchesProvider);
    final result = await getMatchesUseCase(playerId: arg);
    
    return result.fold(
      (failure) {
        // Log error for debugging
        print('Error fetching matches: ${failure.message}');
        throw Exception(failure.message);
      },
      (matches) => matches,
    );
  }
  
  /// Refreshes the match list
  Future<void> refresh() async {
    // Set loading state
    state = const AsyncValue.loading();
    
    // Fetch new data
    state = await AsyncValue.guard(() => _fetchMatches());
  }
  
  /// Cancels a match and updates the list
  Future<void> cancelMatch(String matchId) async {
    final cancelMatchUseCase = ref.read(cancelMatchProvider);
    final result = await cancelMatchUseCase(matchId: matchId);
    
    result.fold(
      (failure) {
        // Handle error (could show snackbar in UI)
        throw Exception(failure.message);
      },
      (_) {
        // Remove cancelled match from state
        state.whenData((matches) {
          state = AsyncValue.data(
            matches.where((m) => m.id != matchId).toList(),
          );
        });
      },
    );
  }
}
```

**Provider Characteristics**:
- ✅ Uses `@riverpod` for code generation
- ✅ Separates dependency providers from state providers
- ✅ Handles `AsyncValue` states (loading, data, error)
- ✅ Provides mutation methods (refresh, add, delete)
- ✅ Automatically disposes when no longer needed

#### 2. Screens

Main UI components.

```dart
// lib/features/matchmaking/presentation/screens/upcoming_matches_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/match_provider.dart';
import '../widgets/match_card.dart';
import '../../../../shared/widgets/loaders/loading_indicator.dart';
import '../../../../shared/widgets/buttons/primary_button.dart';

class UpcomingMatchesScreen extends ConsumerWidget {
  final String playerId;
  
  const UpcomingMatchesScreen({
    super.key,
    required this.playerId,
  });
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the matches state
    final matchesState = ref.watch(upcomingMatchesProvider(playerId));
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upcoming Matches'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.read(upcomingMatchesProvider(playerId).notifier).refresh();
            },
          ),
        ],
      ),
      body: matchesState.when(
        // Loading state
        loading: () => const Center(
          child: LoadingIndicator(message: 'Loading matches...'),
        ),
        
        // Error state
        error: (error, stackTrace) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Colors.red,
                ),
                const SizedBox(height: 16),
                Text(
                  'Oops! Something went wrong',
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  error.toString(),
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                PrimaryButton(
                  text: 'Try Again',
                  onPressed: () {
                    ref.read(upcomingMatchesProvider(playerId).notifier).refresh();
                  },
                ),
              ],
            ),
          ),
        ),
        
        // Data state
        data: (matches) {
          if (matches.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.sports_tennis,
                    size: 64,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No upcoming matches',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Find opponents and schedule matches',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 24),
                  PrimaryButton(
                    text: 'Find Match',
                    onPressed: () {
                      context.push('/matchmaking');
                    },
                  ),
                ],
              ),
            );
          }
          
          return RefreshIndicator(
            onRefresh: () async {
              await ref.read(upcomingMatchesProvider(playerId).notifier).refresh();
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: matches.length,
              itemBuilder: (context, index) {
                final match = matches[index];
                return MatchCard(
                  match: match,
                  onTap: () {
                    context.push('/matches/${match.id}');
                  },
                  onCancel: match.canBeCancelled
                      ? () async {
                          final confirmed = await _showCancelDialog(context);
                          if (confirmed == true) {
                            try {
                              await ref
                                  .read(upcomingMatchesProvider(playerId).notifier)
                                  .cancelMatch(match.id);
                              
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Match cancelled successfully'),
                                  ),
                                );
                              }
                            } catch (e) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Error: $e'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            }
                          }
                        }
                      : null,
                );
              },
            ),
          );
        },
      ),
    );
  }
  
  Future<bool?> _showCancelDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Match'),
        content: const Text('Are you sure you want to cancel this match?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }
}
```

**Screen Characteristics**:
- ✅ Uses `ConsumerWidget` to watch providers
- ✅ Handles all AsyncValue states (loading, error, data)
- ✅ Implements pull-to-refresh
- ✅ Shows meaningful empty states
- ✅ Provides user feedback (snackbars)
- ✅ Delegates business logic to providers

#### 3. Widgets

Reusable UI components.

```dart
// lib/features/matchmaking/presentation/widgets/match_card.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/match_entity.dart';
import '../../../../core/constants/app_colors.dart';

class MatchCard extends StatelessWidget {
  final MatchEntity match;
  final VoidCallback? onTap;
  final VoidCallback? onCancel;
  
  const MatchCard({
    super.key,
    required this.match,
    this.onTap,
    this.onCancel,
  });
  
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: Sport and Status
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        _getSportIcon(),
                        color: AppColors.primaryBlue,
                        size: 24,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        match.sport,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  _StatusChip(status: match.status),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // Date and Time
              Row(
                children: [
                  const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                  const SizedBox(width: 8),
                  Text(
                    DateFormat('EEE, MMM d, yyyy').format(match.scheduledTime),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
              
              const SizedBox(height: 8),
              
              Row(
                children: [
                  const Icon(Icons.access_time, size: 16, color: Colors.grey),
                  const SizedBox(width: 8),
                  Text(
                    DateFormat('h:mm a').format(match.scheduledTime),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // Players
              Row(
                children: [
                  const Icon(Icons.people, size: 16, color: Colors.grey),
                  const SizedBox(width: 8),
                  Text(
                    '${match.playerIds.length} players',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
              
              // Cancel button
              if (onCancel != null) ...[
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: onCancel,
                    icon: const Icon(Icons.cancel, size: 18),
                    label: const Text('Cancel Match'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
  
  IconData _getSportIcon() {
    switch (match.sport.toLowerCase()) {
      case 'badminton':
        return Icons.sports_tennis;
      case 'football':
        return Icons.sports_soccer;
      case 'cricket':
        return Icons.sports_cricket;
      case 'basketball':
        return Icons.sports_basketball;
      default:
        return Icons.sports;
    }
  }
}

class _StatusChip extends StatelessWidget {
  final MatchStatus status;
  
  const _StatusChip({required this.status});
  
  @override
  Widget build(BuildContext context) {
    Color color;
    String text;
    
    switch (status) {
      case MatchStatus.scheduled:
        color = Colors.blue;
        text = 'Scheduled';
        break;
      case MatchStatus.inProgress:
        color = Colors.orange;
        text = 'In Progress';
        break;
      case MatchStatus.completed:
        color = Colors.green;
        text = 'Completed';
        break;
      case MatchStatus.cancelled:
        color = Colors.red;
        text = 'Cancelled';
        break;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
```

**Widget Characteristics**:
- ✅ Accepts entities, not providers or models
- ✅ Uses callbacks for actions
- ✅ Follows theme for consistent styling
- ✅ Reusable across features
- ✅ Stateless when possible

---

## 🔄 Data Flow

### Complete Request-Response Flow

Let's trace a complete flow: **User clicks "Cancel Match" button**

```
┌─────────────────────────────────────────────────────────────────────┐
│                        USER INTERACTION                              │
│  User taps "Cancel" button on MatchCard widget                      │
└────────────────────────────────┬────────────────────────────────────┘
                                  │
                                  ▼
┌─────────────────────────────────────────────────────────────────────┐
│                      PRESENTATION LAYER                              │
│                                                                       │
│  1. MatchCard.onCancel() triggered                                   │
│  2. Calls: ref.read(upcomingMatchesProvider.notifier)                │
│            .cancelMatch(matchId)                                      │
│                                                                       │
└────────────────────────────────┬────────────────────────────────────┘
                                  │
                                  ▼
┌─────────────────────────────────────────────────────────────────────┐
│                     RIVERPOD PROVIDER                                │
│                                                                       │
│  3. Provider notifier receives cancelMatch() call                    │
│  4. Gets CancelMatch use case from provider                          │
│  5. Calls: cancelMatchUseCase(matchId: matchId)                      │
│                                                                       │
└────────────────────────────────┬────────────────────────────────────┘
                                  │
                                  ▼
┌─────────────────────────────────────────────────────────────────────┐
│                        DOMAIN LAYER                                  │
│                         (Use Case)                                   │
│                                                                       │
│  6. CancelMatch.call(matchId) executes                               │
│  7. Calls repository.cancelMatch(matchId)                            │
│  8. Returns Either<Failure, void>                                    │
│                                                                       │
└────────────────────────────────┬────────────────────────────────────┘
                                  │
                                  ▼
┌─────────────────────────────────────────────────────────────────────┐
│                         DATA LAYER                                   │
│                  (Repository Implementation)                         │
│                                                                       │
│  9. MatchRepositoryImpl.cancelMatch() executes                       │
│  10. try-catch block wraps the operation                             │
│  11. Calls: remoteDataSource.cancelMatch(matchId)                    │
│                                                                       │
└────────────────────────────────┬────────────────────────────────────┘
                                  │
                                  ▼
┌─────────────────────────────────────────────────────────────────────┐
│                         DATA LAYER                                   │
│                      (Data Source)                                   │
│                                                                       │
│  12. MatchRemoteDataSource.cancelMatch() executes                    │
│  13. Makes HTTP DELETE request via Dio                               │
│  14. await dioClient.delete('/api/matches/{matchId}')                │
│                                                                       │
└────────────────────────────────┬────────────────────────────────────┘
                                  │
                                  ▼
┌─────────────────────────────────────────────────────────────────────┐
│                    EXTERNAL (Network/API)                            │
│                                                                       │
│  15. HTTP request sent to backend server                             │
│  16. Server processes cancellation                                   │
│  17. Returns HTTP 200 OK (or error)                                  │
│                                                                       │
└────────────────────────────────┬────────────────────────────────────┘
                                  │
                     ┌────────────┴────────────┐
                     │                          │
              ▼ SUCCESS                    ▼ ERROR
┌─────────────────────────────┐  ┌──────────────────────────────────┐
│     SUCCESS PATH            │  │        ERROR PATH                 │
│                             │  │                                   │
│  18. Data source returns    │  │  18. DioException thrown          │
│      successfully           │  │  19. Converted to ServerException │
│  19. Repository returns     │  │      by data source               │
│      Right(void)            │  │  20. Repository catches exception │
│  20. Use case returns       │  │  21. Converts to Left(Failure)    │
│      Right(void)            │  │  22. Use case propagates failure  │
│  21. Provider updates state │  │  23. Provider throws exception    │
│  22. UI removes match card  │  │  24. UI shows error snackbar      │
│  23. Shows success message  │  │                                   │
│                             │  │                                   │
└─────────────────────────────┘  └──────────────────────────────────┘
```

### Key Observations:

1. **Unidirectional Flow**: Data flows in one direction through layers
2. **Error Transformation**: Exceptions → Failures → UI errors
3. **Separation**: Each layer has a specific responsibility
4. **Testability**: Each step can be tested in isolation
5. **Type Safety**: Failures are typed and handled explicitly

---

## 🔌 Dependency Management

### Dependency Injection with Riverpod

REDvsBLUE uses Riverpod for dependency injection, ensuring loose coupling and testability.

#### Provider Hierarchy

```dart
// lib/core/network/dio_client.dart
@riverpod
DioClient dioClient(DioClientRef ref) {
  return DioClient(baseUrl: ApiEndpoints.baseUrl);
}

// Feature-level providers build on core providers
@riverpod
MatchRemoteDataSource matchRemoteDataSource(MatchRemoteDataSourceRef ref) {
  final dioClient = ref.watch(dioClientProvider); // ← Depends on core
  return MatchRemoteDataSourceImpl(dioClient);
}

@riverpod
MatchRepository matchRepository(MatchRepositoryRef ref) {
  final dataSource = ref.watch(matchRemoteDataSourceProvider);
  return MatchRepositoryImpl(dataSource);
}

@riverpod
GetUpcomingMatches getUpcomingMatches(GetUpcomingMatchesRef ref) {
  final repository = ref.watch(matchRepositoryProvider);
  return GetUpcomingMatches(repository);
}
```

### Benefits of This Approach:

1. **Automatic Disposal**: Providers dispose when no longer needed
2. **Caching**: Same dependencies are reused
3. **Testing**: Easy to override providers in tests
4. **Type Safety**: Compile-time checks for dependencies
5. **Dev Tools**: Riverpod Inspector shows dependency graph

---

## 🎭 State Management

### AsyncValue Pattern

Riverpod's `AsyncValue` handles loading, data, and error states elegantly:

```dart
@riverpod
class UpcomingMatches extends _$UpcomingMatches {
  @override
  Future<List<MatchEntity>> build(String playerId) async {
    // Automatically wrapped in AsyncValue
    return await _fetchMatches();
  }
  
  Future<void> refresh() async {
    state = const AsyncValue.loading(); // Loading state
    state = await AsyncValue.guard(() => _fetchMatches()); // Auto error handling
  }
}
```

UI consumption:

```dart
final matchesState = ref.watch(upcomingMatchesProvider(playerId));

matchesState.when(
  loading: () => CircularProgressIndicator(),
  error: (error, stack) => ErrorWidget(error),
  data: (matches) => MatchList(matches),
);
```

### State Types in REDvsBLUE:

1. **Ephemeral State**: Widget-level (e.g., form input, animations)
    - Use `StatefulWidget` or `useState` hook

2. **App State**: Cross-screen state (e.g., authentication, user profile)
    - Use Riverpod providers

3. **Cached State**: Persisted data (e.g., preferences, offline data)
    - Use Hive + Riverpod

---

## 🚨 Error Handling Strategy

### Three-Tier Error System

#### 1. Exceptions (Data Layer)

```dart
// lib/core/errors/exceptions.dart
class ServerException implements Exception {
  final String message;
  ServerException({required this.message});
}

class NetworkException implements Exception {
  final String message;
  NetworkException({required this.message});
}

class CacheException implements Exception {
  final String message;
  CacheException({required this.message});
}
```

#### 2. Failures (Domain Layer)

```dart
// lib/core/errors/failures.dart
import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  
  const Failure({required this.message});
  
  @override
  List<Object?> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure({required super.message});
}

class NetworkFailure extends Failure {
  const NetworkFailure({required super.message});
}

class ValidationFailure extends Failure {
  const ValidationFailure({required super.message});
}

class NotFoundFailure extends Failure {
  const NotFoundFailure({required super.message});
}
```

#### 3. UI Error Messages (Presentation Layer)

```dart
// In screen
result.fold(
  (failure) {
    String userMessage;
    
    if (failure is NetworkFailure) {
      userMessage = 'Check your internet connection';
    } else if (failure is ServerFailure) {
      userMessage = 'Server error. Please try again later';
    } else {
      userMessage = 'Something went wrong';
    }
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(userMessage)),
    );
  },
  (data) {
    // Handle success
  },
);
```

### Error Flow:

```
Exception (Data) → Failure (Domain) → User Message (Presentation)
  ↓                    ↓                     ↓
Technical          Business Logic        User-Friendly
```

---

## 🏗️ Feature Module Structure

### Anatomy of a Complete Feature

```
lib/features/matchmaking/
├── data/
│   ├── datasources/
│   │   ├── match_remote_data_source.dart        # API calls
│   │   └── match_local_data_source.dart         # Local storage
│   ├── models/
│   │   ├── match_model.dart                     # JSON model
│   │   ├── match_model.freezed.dart             # Generated
│   │   └── match_model.g.dart                   # Generated
│   └── repositories/
│       └── match_repository_impl.dart           # Repository implementation
│
├── domain/
│   ├── entities/
│   │   └── match_entity.dart                    # Business entity
│   ├── repositories/
│   │   └── match_repository.dart                # Repository interface
│   └── usecases/
│       ├── get_upcoming_matches.dart            # Use case 1
│       ├── create_match.dart                    # Use case 2
│       └── cancel_match.dart                    # Use case 3
│
└── presentation/
    ├── providers/
    │   ├── match_provider.dart                  # Riverpod providers
    │   └── match_provider.g.dart                # Generated
    ├── screens/
    │   ├── upcoming_matches_screen.dart         # Main screen
    │   └── match_details_screen.dart            # Details screen
    └── widgets/
        ├── match_card.dart                      # Reusable widget 1
        └── match_status_badge.dart              # Reusable widget 2
```

### File Naming Conventions:

- **Entities**: `[name]_entity.dart`
- **Models**: `[name]_model.dart`
- **Repositories**: `[name]_repository.dart` (interface) or `[name]_repository_impl.dart` (implementation)
- **Use Cases**: `[verb]_[noun].dart` (e.g., `get_user.dart`, `create_match.dart`)
- **Data Sources**: `[name]_remote_data_source.dart` or `[name]_local_data_source.dart`
- **Providers**: `[name]_provider.dart`
- **Screens**: `[name]_screen.dart`
- **Widgets**: `[name]_[widget_type].dart` (e.g., `match_card.dart`, `user_avatar.dart`)

---

## 🎨 Design Patterns

### 1. Repository Pattern

**Purpose**: Abstracts data sources from business logic.

```dart
// Domain defines the contract
abstract class UserRepository {
  Future<Either<Failure, User>> getUser(String id);
}

// Data implements the contract
class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;
  final UserLocalDataSource localDataSource;
  
  @override
  Future<Either<Failure, User>> getUser(String id) async {
    // Try cache first, then remote
    try {
      return Right(await localDataSource.getUser(id));
    } catch (_) {
      final user = await remoteDataSource.getUser(id);
      await localDataSource.cacheUser(user);
      return Right(user);
    }
  }
}
```

### 2. Use Case Pattern

**Purpose**: Encapsulates single business actions.

```dart
class GetUpcomingMatches {
  final MatchRepository repository;
  
  GetUpcomingMatches(this.repository);
  
  Future<Either<Failure, List<MatchEntity>>> call({
    required String playerId,
  }) async {
    return await repository.getUpcomingMatches(playerId);
  }
}
```

### 3. Factory Pattern

**Purpose**: Creates objects without specifying their exact classes.

```dart
class MatchModel {
  factory MatchModel.fromJson(Map<String, dynamic> json) {
    return MatchModel(
      id: json['id'],
      sport: json['sport'],
      // ...
    );
  }
}
```

### 4. Observer Pattern (Riverpod)

**Purpose**: Notifies dependents when state changes.

```dart
// Provider notifies widgets when state updates
@riverpod
class Counter extends _$Counter {
  @override
  int build() => 0;
  
  void increment() => state++;
}

// Widgets automatically rebuild
final count = ref.watch(counterProvider);
```

### 5. Adapter Pattern (Models ↔ Entities)

**Purpose**: Converts between incompatible interfaces.

```dart
extension MatchModelX on MatchModel {
  MatchEntity toEntity() {
    return MatchEntity(
      id: id,
      sport: sport,
      scheduledTime: scheduledTime,
      status: _parseStatus(status),
    );
  }
}
```

---

## ✅ Best Practices

### 1. Immutability

```dart
// ✅ GOOD: Immutable entity
class User {
  final String id;
  final String name;
  
  const User({required this.id, required this.name});
  
  User copyWith({String? name}) {
    return User(
      id: id,
      name: name ?? this.name,
    );
  }
}

// ❌ BAD: Mutable entity
class User {
  String id;
  String name;
  
  User(this.id, this.name);
}
```

### 2. Dependency Injection

```dart
// ✅ GOOD: Dependencies injected via constructor
class GetUser {
  final UserRepository repository;
  
  GetUser(this.repository);
}

// ❌ BAD: Direct instantiation inside class
class GetUser {
  final repository = UserRepositoryImpl();
}
```

### 3. Error Handling

```dart
// ✅ GOOD: Explicit error handling with Either
Future<Either<Failure, User>> getUser(String id) async {
  try {
    final user = await dataSource.getUser(id);
    return Right(user);
  } on ServerException catch (e) {
    return Left(ServerFailure(message: e.message));
  }
}

// ❌ BAD: Unhandled exceptions
Future<User> getUser(String id) async {
  return await dataSource.getUser(id); // Can throw!
}
```

### 4. Single Responsibility

```dart
// ✅ GOOD: Separate concerns
class MatchCard extends StatelessWidget {
  // Only renders UI
}

class MatchProvider extends StateNotifier {
  // Only manages state
}

class MatchRepository {
  // Only handles data operations
}

// ❌ BAD: Mixed concerns
class MatchWidget extends StatefulWidget {
  void fetchMatches() { } // Data logic in UI!
  void updateDatabase() { } // Database logic in UI!
}
```

### 5. Testability

```dart
// ✅ GOOD: Testable use case
class GetUser {
  final UserRepository repository;
  
  GetUser(this.repository);
  
  Future<Either<Failure, User>> call(String id) {
    return repository.getUser(id);
  }
}

// Easy to test with mock
test('should return user', () async {
  final mockRepo = MockUserRepository();
  final useCase = GetUser(mockRepo);
  
  when(mockRepo.getUser('1')).thenAnswer((_) => Right(user));
  
  final result = await useCase('1');
  expect(result, Right(user));
});
```

---

## ⚠️ Common Pitfalls

### 1. Breaking the Dependency Rule

```dart
// ❌ WRONG: Domain depending on presentation
// lib/features/matchmaking/domain/entities/match_entity.dart
import 'package:flutter/material.dart'; // NO! Domain shouldn't know Flutter

class MatchEntity {
  Color get statusColor { } // UI logic in domain!
}

// ✅ CORRECT: Keep domain pure
class MatchEntity {
  MatchStatus get status { }
}

// Put UI logic in presentation
extension MatchEntityUI on MatchEntity {
  Color get statusColor {
    switch (status) {
      case MatchStatus.scheduled:
        return Colors.blue;
      // ...
    }
  }
}
```

### 2. Models Leaking into Domain

```dart
// ❌ WRONG: Use case returning model
class GetUser {
  Future<Either<Failure, UserModel>> call(String id) {
    return repository.getUser(id);
  }
}

// ✅ CORRECT: Use case returns entity
class GetUser {
  Future<Either<Failure, UserEntity>> call(String id) {
    return repository.getUser(id);
  }
}
```

### 3. God Objects

```dart
// ❌ WRONG: One repository does everything
class DataRepository {
  Future<User> getUser();
  Future<List<Match>> getMatches();
  Future<List<Venue>> getVenues();
  Future<Tournament> getTournament();
  // 50 more methods...
}

// ✅ CORRECT: Separate repositories by domain
class UserRepository {
  Future<User> getUser();
}

class MatchRepository {
  Future<List<Match>> getMatches();
}
```

### 4. Skipping Use Cases

```dart
// ❌ WRONG: Provider directly uses repository
class UserProvider extends StateNotifier {
  final UserRepository repository;
  
  void loadUser() {
    final user = await repository.getUser(); // No use case!
  }
}

// ✅ CORRECT: Use cases encapsulate business logic
class UserProvider extends StateNotifier {
  final GetUser getUserUseCase;
  
  void loadUser() {
    final result = await getUserUseCase(id: userId);
  }
}
```

### 5. Tight Coupling

```dart
// ❌ WRONG: Concrete dependency
class MatchService {
  final FirebaseMatchDataSource dataSource;
  
  MatchService(this.dataSource); // Coupled to Firebase!
}

// ✅ CORRECT: Depend on abstraction
class MatchService {
  final MatchDataSource dataSource;
  
  MatchService(this.dataSource); // Can be any implementation
}
```

---

## 🎓 Real-World Examples

### Example 1: Complete Feature Implementation

Let's implement a "Rate Match" feature from scratch following Clean Architecture:

#### Step 1: Domain Entity

```dart
// lib/features/rating/domain/entities/match_rating_entity.dart
class MatchRatingEntity extends Equatable {
  final String id;
  final String matchId;
  final String playerId;
  final int score; // 1-5
  final String? comment;
  final DateTime createdAt;
  
  const MatchRatingEntity({
    required this.id,
    required this.matchId,
    required this.playerId,
    required this.score,
    this.comment,
    required this.createdAt,
  });
  
  /// Business rule: Score must be between 1 and 5
  bool get isValidScore => score >= 1 && score <= 5;
  
  @override
  List<Object?> get props => [id, matchId, playerId, score, comment, createdAt];
}
```

#### Step 2: Repository Interface

```dart
// lib/features/rating/domain/repositories/rating_repository.dart
abstract class RatingRepository {
  Future<Either<Failure, MatchRatingEntity>> rateMatch({
    required String matchId,
    required String playerId,
    required int score,
    String? comment,
  });
  
  Future<Either<Failure, List<MatchRatingEntity>>> getRatingsForMatch(
    String matchId,
  );
  
  Future<Either<Failure, double>> getAverageRating(String matchId);
}
```

#### Step 3: Use Case

```dart
// lib/features/rating/domain/usecases/rate_match.dart
class RateMatch {
  final RatingRepository repository;
  
  RateMatch(this.repository);
  
  Future<Either<Failure, MatchRatingEntity>> call({
    required String matchId,
    required String playerId,
    required int score,
    String? comment,
  }) async {
    // Business validation
    if (score < 1 || score > 5) {
      return Left(ValidationFailure(
        message: 'Rating must be between 1 and 5',
      ));
    }
    
    if (comment != null && comment.length > 500) {
      return Left(ValidationFailure(
        message: 'Comment must be less than 500 characters',
      ));
    }
    
    return await repository.rateMatch(
      matchId: matchId,
      playerId: playerId,
      score: score,
      comment: comment,
    );
  }
}
```

#### Step 4: Data Model

```dart
// lib/features/rating/data/models/match_rating_model.dart
@freezed
class MatchRatingModel with _$MatchRatingModel {
  const factory MatchRatingModel({
    required String id,
    required String matchId,
    required String playerId,
    required int score,
    String? comment,
    required DateTime createdAt,
  }) = _MatchRatingModel;
  
  factory MatchRatingModel.fromJson(Map<String, dynamic> json) =>
      _$MatchRatingModelFromJson(json);
}

extension MatchRatingModelX on MatchRatingModel {
  MatchRatingEntity toEntity() {
    return MatchRatingEntity(
      id: id,
      matchId: matchId,
      playerId: playerId,
      score: score,
      comment: comment,
      createdAt: createdAt,
    );
  }
}

extension MatchRatingEntityX on MatchRatingEntity {
  MatchRatingModel toModel() {
    return MatchRatingModel(
      id: id,
      matchId: matchId,
      playerId: playerId,
      score: score,
      comment: comment,
      createdAt: createdAt,
    );
  }
}
```

#### Step 5: Data Source

```dart
// lib/features/rating/data/datasources/rating_remote_data_source.dart
abstract class RatingRemoteDataSource {
  Future<MatchRatingModel> rateMatch({
    required String matchId,
    required String playerId,
    required int score,
    String? comment,
  });
  
  Future<List<MatchRatingModel>> getRatingsForMatch(String matchId);
  Future<double> getAverageRating(String matchId);
}

class RatingRemoteDataSourceImpl implements RatingRemoteDataSource {
  final DioClient dioClient;
  
  RatingRemoteDataSourceImpl(this.dioClient);
  
  @override
  Future<MatchRatingModel> rateMatch({
    required String matchId,
    required String playerId,
    required int score,
    String? comment,
  }) async {
    try {
      final response = await dioClient.post(
        ApiEndpoints.ratings,
        data: {
          'match_id': matchId,
          'player_id': playerId,
          'score': score,
          if (comment != null) 'comment': comment,
        },
      );
      
      return MatchRatingModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }
  
  @override
  Future<List<MatchRatingModel>> getRatingsForMatch(String matchId) async {
    try {
      final response = await dioClient.get(
        ApiEndpoints.matchRatings(matchId),
      );
      
      final List<dynamic> data = response.data['data'];
      return data.map((json) => MatchRatingModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }
  
  @override
  Future<double> getAverageRating(String matchId) async {
    try {
      final response = await dioClient.get(
        ApiEndpoints.matchAverageRating(matchId),
      );
      
      return (response.data['data']['average'] as num).toDouble();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }
  
  Exception _handleError(DioException e) {
    // Error handling logic
    return ServerException(message: e.message ?? 'Server error');
  }
}
```

#### Step 6: Repository Implementation

```dart
// lib/features/rating/data/repositories/rating_repository_impl.dart
class RatingRepositoryImpl implements RatingRepository {
  final RatingRemoteDataSource remoteDataSource;
  
  RatingRepositoryImpl(this.remoteDataSource);
  
  @override
  Future<Either<Failure, MatchRatingEntity>> rateMatch({
    required String matchId,
    required String playerId,
    required int score,
    String? comment,
  }) async {
    try {
      final model = await remoteDataSource.rateMatch(
        matchId: matchId,
        playerId: playerId,
        score: score,
        comment: comment,
      );
      
      return Right(model.toEntity());
    } on ValidationException catch (e) {
      return Left(ValidationFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, List<MatchRatingEntity>>> getRatingsForMatch(
    String matchId,
  ) async {
    try {
      final models = await remoteDataSource.getRatingsForMatch(matchId);
      final entities = models.map((m) => m.toEntity()).toList();
      return Right(entities);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, double>> getAverageRating(String matchId) async {
    try {
      final average = await remoteDataSource.getAverageRating(matchId);
      return Right(average);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }
}
```

#### Step 7: Providers

```dart
// lib/features/rating/presentation/providers/rating_provider.dart
part 'rating_provider.g.dart';

@riverpod
RatingRemoteDataSource ratingRemoteDataSource(RatingRemoteDataSourceRef ref) {
  final dioClient = ref.watch(dioClientProvider);
  return RatingRemoteDataSourceImpl(dioClient);
}

@riverpod
RatingRepository ratingRepository(RatingRepositoryRef ref) {
  final dataSource = ref.watch(ratingRemoteDataSourceProvider);
  return RatingRepositoryImpl(dataSource);
}

@riverpod
RateMatch rateMatch(RateMatchRef ref) {
  final repository = ref.watch(ratingRepositoryProvider);
  return RateMatch(repository);
}

@riverpod
class MatchRatings extends _$MatchRatings {
  @override
  Future<List<MatchRatingEntity>> build(String matchId) async {
    final repository = ref.watch(ratingRepositoryProvider);
    final result = await repository.getRatingsForMatch(matchId);
    
    return result.fold(
      (failure) => throw Exception(failure.message),
      (ratings) => ratings,
    );
  }
  
  Future<void> addRating({
    required int score,
    String? comment,
  }) async {
    final rateMatchUseCase = ref.read(rateMatchProvider);
    final result = await rateMatchUseCase(
      matchId: arg,
      playerId: 'current_user_id', // Get from auth provider
      score: score,
      comment: comment,
    );
    
    result.fold(
      (failure) => throw Exception(failure.message),
      (rating) {
        state.whenData((ratings) {
          state = AsyncValue.data([...ratings, rating]);
        });
      },
    );
  }
}

@riverpod
Future<double> matchAverageRating(
  MatchAverageRatingRef ref,
  String matchId,
) async {
  final repository = ref.watch(ratingRepositoryProvider);
  final result = await repository.getAverageRating(matchId);
  
  return result.fold(
    (failure) => throw Exception(failure.message),
    (average) => average,
  );
}
```

#### Step 8: UI Screen

```dart
// lib/features/rating/presentation/screens/rate_match_screen.dart
class RateMatchScreen extends ConsumerStatefulWidget {
  final String matchId;
  
  const RateMatchScreen({super.key, required this.matchId});
  
  @override
  ConsumerState<RateMatchScreen> createState() => _RateMatchScreenState();
}

class _RateMatchScreenState extends ConsumerState<RateMatchScreen> {
  int _rating = 0;
  final _commentController = TextEditingController();
  bool _isSubmitting = false;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rate Match')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'How was your match?',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 24),
            
            // Star rating
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return IconButton(
                    icon: Icon(
                      index < _rating ? Icons.star : Icons.star_border,
                      size: 48,
                      color: Colors.amber,
                    ),
                    onPressed: () {
                      setState(() {
                        _rating = index + 1;
                      });
                    },
                  );
                }),
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Comment
            TextField(
              controller: _commentController,
              decoration: const InputDecoration(
                labelText: 'Comments (optional)',
                hintText: 'Share your experience...',
                border: OutlineInputBorder(),
              ),
              maxLines: 4,
              maxLength: 500,
            ),
            
            const Spacer(),
            
            // Submit button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _rating > 0 && !_isSubmitting
                    ? _submitRating
                    : null,
                child: _isSubmitting
                    ? const CircularProgressIndicator()
                    : const Text('Submit Rating'),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Future<void> _submitRating() async {
    setState(() {
      _isSubmitting = true;
    });
    
    try {
      await ref.read(matchRatingsProvider(widget.matchId).notifier).addRating(
        score: _rating,
        comment: _commentController.text.isNotEmpty
            ? _commentController.text
            : null,
      );
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Rating submitted successfully!')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }
  
  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }
}
```

---

## 📖 Summary

### Key Takeaways

1. **Clean Architecture separates concerns** into three distinct layers:
    - **Domain**: Pure business logic, no dependencies
    - **Data**: Data operations, API calls, database
    - **Presentation**: UI, state management, user interactions

2. **Dependency Rule**: Dependencies flow inward
    - Presentation → Domain ← Data
    - Inner layers don't know about outer layers

3. **Use Either<Failure, T>** for explicit error handling
    - No surprise exceptions
    - Forces error consideration
    - Clean, functional approach

4. **Riverpod for dependency injection**
    - Type-safe
    - Automatic disposal
    - Easy testing

5. **Each layer has specific responsibilities**
    - Don't mix concerns
    - Single Responsibility Principle
    - Testable in isolation

### When to Use Clean Architecture

**Use Clean Architecture when:**
- ✅ Building medium to large applications
- ✅ Working in teams
- ✅ Long-term maintenance expected
- ✅ Complex business logic
- ✅ Multiple data sources
- ✅ High testability requirements

**Consider simpler approaches when:**
- ⚠️ Building simple prototypes
- ⚠️ Very small apps (< 5 screens)
- ⚠️ Short-lived projects
- ⚠️ Solo developer with time constraints

### Further Resources

- [Clean Architecture by Robert C. Martin](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [Flutter Clean Architecture by Reso Coder](https://resocoder.com/flutter-clean-architecture-tdd/)
- [Riverpod Documentation](https://riverpod.dev/)
- [Dartz Package (Functional Programming)](https://pub.dev/packages/dartz)

---

<div align="center">
  <p><strong>Happy Coding with Clean Architecture! 🏗️</strong></p>
  <p><em>Built with ❤️ by the REDvsBLUE Team</em></p>
</div>