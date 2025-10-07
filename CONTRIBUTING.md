# Contributing to REDvsBLUE

First off, thank you for considering contributing to REDvsBLUE! 🎉

This document provides guidelines and instructions for contributing to the project. Following these guidelines helps maintain code quality and makes the review process smoother for everyone.

## 📋 Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [Development Setup](#development-setup)
- [Project Architecture](#project-architecture)
- [Adding New Features](#adding-new-features)
- [Coding Standards](#coding-standards)
- [Commit Guidelines](#commit-guidelines)
- [Pull Request Process](#pull-request-process)
- [Testing Guidelines](#testing-guidelines)
- [Documentation](#documentation)

---

## 📜 Code of Conduct

### Our Standards

- Be respectful and inclusive
- Welcome newcomers and help them get started
- Accept constructive criticism gracefully
- Focus on what's best for the community and project
- Show empathy towards other community members

### Unacceptable Behavior

- Harassment, trolling, or discriminatory language
- Personal or political attacks
- Publishing others' private information
- Any conduct that could be considered inappropriate in a professional setting

---

## 🚀 Getting Started

### Prerequisites

Before you begin, ensure you have:

- [ ] Flutter SDK 3.5.4 or higher installed
- [ ] Dart SDK 3.9.0 or higher
- [ ] Git for version control
- [ ] A code editor (VS Code, Android Studio, or IntelliJ IDEA)
- [ ] Basic understanding of Flutter and Dart
- [ ] Familiarity with Clean Architecture principles
- [ ] Understanding of Riverpod state management

### First-Time Setup

1. **Fork the repository** on GitHub
2. **Clone your fork** locally:
   ```bash
   git clone https://github.com/YOUR_USERNAME/REDvsBLUE.git
   cd REDvsBLUE
   ```

3. **Add upstream remote**:
   ```bash
   git remote add upstream https://github.com/ausmatths/REDvsBLUE.git
   ```

4. **Install dependencies**:
   ```bash
   flutter pub get
   ```

5. **Set up Firebase** (see README.md for details)

6. **Generate code**:
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

7. **Create a new branch** for your feature:
   ```bash
   git checkout -b feature/your-feature-name
   ```

---

## 🏗️ Project Architecture

REDvsBLUE follows **Clean Architecture** principles with a feature-based modular structure. Understanding this architecture is crucial before contributing.

### Architecture Layers

```
┌─────────────────────────────────────────┐
│         PRESENTATION LAYER              │
│  (UI, Widgets, State Management)        │
│  - Screens, Widgets, Providers          │
│  - Depends on: Domain Layer             │
└─────────────────────────────────────────┘
                    ↓
┌─────────────────────────────────────────┐
│           DOMAIN LAYER                  │
│     (Business Logic, Entities)          │
│  - Entities, Use Cases, Repositories    │
│  - Pure Dart (No Flutter imports)       │
│  - Depends on: Nothing                  │
└─────────────────────────────────────────┘
                    ↑
┌─────────────────────────────────────────┐
│            DATA LAYER                   │
│   (API, Database, External Sources)     │
│  - Data Sources, Models, Repositories   │
│  - Depends on: Domain Layer             │
└─────────────────────────────────────────┘
```

### Key Principles

1. **Dependency Rule**: Dependencies should only point inward
    - Presentation → Domain ← Data
    - Domain layer is independent and contains business logic
    - Never import from outer layers into inner layers

2. **Single Responsibility**: Each class/file has one clear purpose

3. **Dependency Injection**: Use repository interfaces, not concrete implementations

4. **Separation of Concerns**: Keep UI, business logic, and data separate

---

## ✨ Adding New Features

### Step-by-Step Guide

Follow this comprehensive guide when adding a new feature to REDvsBLUE:

#### Step 1: Create Feature Directory Structure

Create the following structure for your new feature:

```bash
lib/features/your_feature/
├── data/
│   ├── datasources/
│   │   └── your_feature_remote_data_source.dart
│   ├── models/
│   │   └── your_feature_model.dart
│   └── repositories/
│       └── your_feature_repository_impl.dart
├── domain/
│   ├── entities/
│   │   └── your_feature_entity.dart
│   ├── repositories/
│   │   └── your_feature_repository.dart
│   └── usecases/
│       ├── get_your_feature.dart
│       └── update_your_feature.dart
└── presentation/
    ├── providers/
    │   └── your_feature_provider.dart
    ├── screens/
    │   └── your_feature_screen.dart
    └── widgets/
        └── your_feature_card.dart
```

**Quick Command** (optional):
```bash
# Use the provided script
bash create_structure.sh your_feature
```

---

#### Step 2: Define Domain Entities

Start with the **domain layer** as it's the core of your feature.

**File**: `lib/features/your_feature/domain/entities/your_feature_entity.dart`

```dart
import 'package:equatable/equatable.dart';

/// Business entity representing [YourFeature]
/// This is pure Dart - NO Flutter dependencies
class YourFeatureEntity extends Equatable {
  final String id;
  final String name;
  final DateTime createdAt;
  
  const YourFeatureEntity({
    required this.id,
    required this.name,
    required this.createdAt,
  });
  
  @override
  List<Object?> get props => [id, name, createdAt];
}
```

**Key Points**:
- ✅ Use `Equatable` for value comparison
- ✅ Make entities immutable (`final` fields)
- ✅ No Flutter imports in domain layer
- ✅ Include all business-critical properties

---

#### Step 3: Define Repository Interface

**File**: `lib/features/your_feature/domain/repositories/your_feature_repository.dart`

```dart
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/your_feature_entity.dart';

/// Repository interface defining contracts for [YourFeature] data operations
/// Implementation will be in the data layer
abstract class YourFeatureRepository {
  /// Fetches a list of [YourFeatureEntity]
  /// Returns [Right] with list on success
  /// Returns [Left] with [Failure] on error
  Future<Either<Failure, List<YourFeatureEntity>>> getYourFeatures();
  
  /// Fetches a single [YourFeatureEntity] by [id]
  Future<Either<Failure, YourFeatureEntity>> getYourFeatureById(String id);
  
  /// Creates a new [YourFeatureEntity]
  Future<Either<Failure, YourFeatureEntity>> createYourFeature(
    YourFeatureEntity feature,
  );
  
  /// Updates an existing [YourFeatureEntity]
  Future<Either<Failure, YourFeatureEntity>> updateYourFeature(
    YourFeatureEntity feature,
  );
  
  /// Deletes a [YourFeatureEntity] by [id]
  Future<Either<Failure, void>> deleteYourFeature(String id);
}
```

**Key Points**:
- ✅ Use `Either<Failure, T>` for error handling (from dartz package)
- ✅ Document each method with clear comments
- ✅ Return domain entities, not models
- ✅ Keep it abstract - implementation goes in data layer

---

#### Step 4: Create Use Cases

**File**: `lib/features/your_feature/domain/usecases/get_your_features.dart`

```dart
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/your_feature_entity.dart';
import '../repositories/your_feature_repository.dart';

/// Use case for getting all [YourFeatureEntity] items
/// 
/// Single Responsibility: Fetch all features
class GetYourFeatures {
  final YourFeatureRepository repository;
  
  GetYourFeatures(this.repository);
  
  /// Executes the use case
  /// Returns [Right] with list of features on success
  /// Returns [Left] with [Failure] on error
  Future<Either<Failure, List<YourFeatureEntity>>> call() async {
    return await repository.getYourFeatures();
  }
}
```

**File**: `lib/features/your_feature/domain/usecases/create_your_feature.dart`

```dart
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/your_feature_entity.dart';
import '../repositories/your_feature_repository.dart';

/// Use case for creating a new [YourFeatureEntity]
class CreateYourFeature {
  final YourFeatureRepository repository;
  
  CreateYourFeature(this.repository);
  
  /// Executes the use case
  /// 
  /// [feature]: The feature entity to create
  /// Returns [Right] with created feature on success
  /// Returns [Left] with [Failure] on error
  Future<Either<Failure, YourFeatureEntity>> call(
    YourFeatureEntity feature,
  ) async {
    return await repository.createYourFeature(feature);
  }
}
```

**Key Points**:
- ✅ One use case = one business action
- ✅ Use `call()` method for execution
- ✅ Inject repository via constructor
- ✅ Keep use cases simple and focused

---

#### Step 5: Create Data Models

**File**: `lib/features/your_feature/data/models/your_feature_model.dart`

```dart
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/your_feature_entity.dart';

part 'your_feature_model.freezed.dart';
part 'your_feature_model.g.dart';

/// Data model for [YourFeatureEntity]
/// Handles JSON serialization/deserialization
@freezed
class YourFeatureModel with _$YourFeatureModel {
  const factory YourFeatureModel({
    required String id,
    required String name,
    required DateTime createdAt,
  }) = _YourFeatureModel;
  
  /// Convert from JSON
  factory YourFeatureModel.fromJson(Map<String, dynamic> json) =>
      _$YourFeatureModelFromJson(json);
}

/// Extension to convert model to entity
extension YourFeatureModelX on YourFeatureModel {
  YourFeatureEntity toEntity() {
    return YourFeatureEntity(
      id: id,
      name: name,
      createdAt: createdAt,
    );
  }
}

/// Extension to convert entity to model
extension YourFeatureEntityX on YourFeatureEntity {
  YourFeatureModel toModel() {
    return YourFeatureModel(
      id: id,
      name: name,
      createdAt: createdAt,
    );
  }
}
```

**After creating the model, run**:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

**Key Points**:
- ✅ Use `@freezed` for immutable models with code generation
- ✅ Include `fromJson` and `toJson` for API communication
- ✅ Create extension methods for entity ↔ model conversion
- ✅ Keep serialization logic separate from business logic

---

#### Step 6: Implement Data Sources

**File**: `lib/features/your_feature/data/datasources/your_feature_remote_data_source.dart`

```dart
import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../models/your_feature_model.dart';

/// Remote data source for [YourFeature]
/// Handles API calls using Dio
abstract class YourFeatureRemoteDataSource {
  Future<List<YourFeatureModel>> getYourFeatures();
  Future<YourFeatureModel> getYourFeatureById(String id);
  Future<YourFeatureModel> createYourFeature(YourFeatureModel feature);
  Future<YourFeatureModel> updateYourFeature(YourFeatureModel feature);
  Future<void> deleteYourFeature(String id);
}

class YourFeatureRemoteDataSourceImpl implements YourFeatureRemoteDataSource {
  final DioClient dioClient;
  
  YourFeatureRemoteDataSourceImpl(this.dioClient);
  
  @override
  Future<List<YourFeatureModel>> getYourFeatures() async {
    try {
      final response = await dioClient.get(ApiEndpoints.yourFeatures);
      
      final List<dynamic> data = response.data['data'];
      return data.map((json) => YourFeatureModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Server error occurred');
    }
  }
  
  @override
  Future<YourFeatureModel> createYourFeature(YourFeatureModel feature) async {
    try {
      final response = await dioClient.post(
        ApiEndpoints.yourFeatures,
        data: feature.toJson(),
      );
      
      return YourFeatureModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to create feature');
    }
  }
  
  // Implement other methods similarly...
}
```

**Key Points**:
- ✅ Create abstract interface first, then implementation
- ✅ Use `DioClient` from core for network calls
- ✅ Handle errors and throw custom exceptions
- ✅ Parse JSON responses into models

---

#### Step 7: Implement Repository

**File**: `lib/features/your_feature/data/repositories/your_feature_repository_impl.dart`

```dart
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/errors/exceptions.dart';
import '../../domain/entities/your_feature_entity.dart';
import '../../domain/repositories/your_feature_repository.dart';
import '../datasources/your_feature_remote_data_source.dart';
import '../models/your_feature_model.dart';

/// Implementation of [YourFeatureRepository]
/// Handles data operations and error conversion
class YourFeatureRepositoryImpl implements YourFeatureRepository {
  final YourFeatureRemoteDataSource remoteDataSource;
  
  YourFeatureRepositoryImpl(this.remoteDataSource);
  
  @override
  Future<Either<Failure, List<YourFeatureEntity>>> getYourFeatures() async {
    try {
      final models = await remoteDataSource.getYourFeatures();
      final entities = models.map((model) => model.toEntity()).toList();
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
  Future<Either<Failure, YourFeatureEntity>> createYourFeature(
    YourFeatureEntity feature,
  ) async {
    try {
      final model = feature.toModel();
      final resultModel = await remoteDataSource.createYourFeature(model);
      return Right(resultModel.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }
  
  // Implement other methods similarly...
}
```

**Key Points**:
- ✅ Convert exceptions to failures using `Either`
- ✅ Convert models to entities before returning
- ✅ Handle all possible error cases
- ✅ Never expose models outside the data layer

---

#### Step 8: Create Riverpod Providers

**File**: `lib/features/your_feature/presentation/providers/your_feature_provider.dart`

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/network/dio_client.dart';
import '../../data/datasources/your_feature_remote_data_source.dart';
import '../../data/repositories/your_feature_repository_impl.dart';
import '../../domain/entities/your_feature_entity.dart';
import '../../domain/repositories/your_feature_repository.dart';
import '../../domain/usecases/get_your_features.dart';
import '../../domain/usecases/create_your_feature.dart';

part 'your_feature_provider.g.dart';

// ============================================================================
// DEPENDENCY PROVIDERS
// ============================================================================

/// Provides the data source
@riverpod
YourFeatureRemoteDataSource yourFeatureRemoteDataSource(
  YourFeatureRemoteDataSourceRef ref,
) {
  final dioClient = ref.watch(dioClientProvider);
  return YourFeatureRemoteDataSourceImpl(dioClient);
}

/// Provides the repository
@riverpod
YourFeatureRepository yourFeatureRepository(YourFeatureRepositoryRef ref) {
  final dataSource = ref.watch(yourFeatureRemoteDataSourceProvider);
  return YourFeatureRepositoryImpl(dataSource);
}

/// Provides the get features use case
@riverpod
GetYourFeatures getYourFeatures(GetYourFeaturesRef ref) {
  final repository = ref.watch(yourFeatureRepositoryProvider);
  return GetYourFeatures(repository);
}

/// Provides the create feature use case
@riverpod
CreateYourFeature createYourFeature(CreateYourFeatureRef ref) {
  final repository = ref.watch(yourFeatureRepositoryProvider);
  return CreateYourFeature(repository);
}

// ============================================================================
// STATE PROVIDERS
// ============================================================================

/// State for the list of features
@riverpod
class YourFeatureList extends _$YourFeatureList {
  @override
  Future<List<YourFeatureEntity>> build() async {
    return await _fetchFeatures();
  }
  
  /// Fetch features from repository
  Future<List<YourFeatureEntity>> _fetchFeatures() async {
    final getYourFeaturesUseCase = ref.read(getYourFeaturesProvider);
    final result = await getYourFeaturesUseCase();
    
    return result.fold(
      (failure) => throw Exception(failure.message),
      (features) => features,
    );
  }
  
  /// Refresh the list
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchFeatures());
  }
  
  /// Add a new feature
  Future<void> addFeature(YourFeatureEntity feature) async {
    final createUseCase = ref.read(createYourFeatureProvider);
    final result = await createUseCase(feature);
    
    result.fold(
      (failure) => throw Exception(failure.message),
      (newFeature) {
        // Update state with new feature
        state.whenData((features) {
          state = AsyncValue.data([...features, newFeature]);
        });
      },
    );
  }
}
```

**After creating providers, run**:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

**Key Points**:
- ✅ Use `@riverpod` annotation for code generation
- ✅ Create providers for dependencies (repository, use cases)
- ✅ Create state providers for UI data
- ✅ Handle loading, data, and error states with `AsyncValue`
- ✅ Implement methods for common operations (refresh, add, update, delete)

---

#### Step 9: Build UI Screens

**File**: `lib/features/your_feature/presentation/screens/your_feature_screen.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/your_feature_provider.dart';
import '../widgets/your_feature_card.dart';

class YourFeatureScreen extends ConsumerWidget {
  const YourFeatureScreen({super.key});
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final featureListState = ref.watch(yourFeatureListProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Feature'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.read(yourFeatureListProvider.notifier).refresh();
            },
          ),
        ],
      ),
      body: featureListState.when(
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                'Error: $error',
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  ref.read(yourFeatureListProvider.notifier).refresh();
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (features) {
          if (features.isEmpty) {
            return const Center(
              child: Text('No features found'),
            );
          }
          
          return ListView.builder(
            itemCount: features.length,
            itemBuilder: (context, index) {
              return YourFeatureCard(feature: features[index]);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to create feature screen
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
```

**Key Points**:
- ✅ Use `ConsumerWidget` to watch providers
- ✅ Handle all three states: loading, error, data
- ✅ Implement pull-to-refresh functionality
- ✅ Show meaningful error messages with retry option
- ✅ Keep UI logic minimal - delegate to providers

---

#### Step 10: Create Reusable Widgets

**File**: `lib/features/your_feature/presentation/widgets/your_feature_card.dart`

```dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/your_feature_entity.dart';

class YourFeatureCard extends StatelessWidget {
  final YourFeatureEntity feature;
  final VoidCallback? onTap;
  
  const YourFeatureCard({
    super.key,
    required this.feature,
    this.onTap,
  });
  
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(
          feature.name,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        subtitle: Text(
          'Created: ${DateFormat.yMMMd().format(feature.createdAt)}',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}
```

**Key Points**:
- ✅ Make widgets reusable and configurable
- ✅ Accept entities, not models or providers
- ✅ Use callbacks for actions
- ✅ Follow theme for consistent styling

---

#### Step 11: Add Routes

**File**: `lib/core/router/app_router.dart`

```dart
// Add your new route
GoRoute(
  path: '/your-feature',
  builder: (context, state) => const YourFeatureScreen(),
),

GoRoute(
  path: '/your-feature/:id',
  builder: (context, state) {
    final id = state.pathParameters['id']!;
    return YourFeatureDetailsScreen(id: id);
  },
),
```

---

#### Step 12: Update API Endpoints

**File**: `lib/core/network/api_endpoints.dart`

```dart
class ApiEndpoints {
  // ... existing endpoints
  
  // Your Feature endpoints
  static const String yourFeatures = '/api/v1/your-features';
  static String yourFeatureById(String id) => '/api/v1/your-features/$id';
}
```

---

#### Step 13: Test Your Feature

Create tests for each layer:

```bash
test/
├── features/
│   └── your_feature/
│       ├── data/
│       │   ├── datasources/
│       │   │   └── your_feature_remote_data_source_test.dart
│       │   ├── models/
│       │   │   └── your_feature_model_test.dart
│       │   └── repositories/
│       │       └── your_feature_repository_impl_test.dart
│       ├── domain/
│       │   └── usecases/
│       │       └── get_your_features_test.dart
│       └── presentation/
│           ├── providers/
│           │   └── your_feature_provider_test.dart
│           └── widgets/
│               └── your_feature_card_test.dart
```

Run tests:
```bash
flutter test
```

---

## 📝 Coding Standards

### Naming Conventions

```dart
// Classes: PascalCase
class YourFeatureRepository {}

// Variables, methods: camelCase
final yourFeature = YourFeature();
void getYourFeature() {}

// Constants: lowerCamelCase
const maxRetryAttempts = 3;

// Private members: _prefixed
final _privateField = '';
void _privateMethod() {}

// Files: snake_case
your_feature_screen.dart
your_feature_repository.dart
```

### Code Organization

```dart
// 1. Imports (grouped and sorted)
import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/your_entity.dart';

// 2. Class definition
class YourClass {
  // 3. Static constants
  static const maxItems = 10;
  
  // 4. Instance fields
  final String id;
  final String name;
  
  // 5. Constructor
  const YourClass({
    required this.id,
    required this.name,
  });
  
  // 6. Getters
  String get displayName => name;
  
  // 7. Methods
  void yourMethod() {}
  
  // 8. Private methods
  void _privateMethod() {}
  
  // 9. Overrides
  @override
  String toString() => 'YourClass($id, $name)';
}
```

### Documentation

```dart
/// Brief description of the class/method
///
/// More detailed explanation if needed.
///
/// Example:
/// ```dart
/// final feature = YourFeature(id: '1', name: 'Example');
/// feature.doSomething();
/// ```
///
/// See also:
/// * [RelatedClass], for related functionality
class YourFeature {
  /// The unique identifier
  final String id;
  
  /// Creates a [YourFeature]
  ///
  /// [id] must not be empty
  /// [name] must not be empty
  const YourFeature({
    required this.id,
    required this.name,
  }) : assert(id != ''), assert(name != '');
}
```

### Error Handling

```dart
// DO: Use Either for expected errors
Future<Either<Failure, User>> getUser() async {
  try {
    final user = await api.getUser();
    return Right(user);
  } on NetworkException catch (e) {
    return Left(NetworkFailure(message: e.message));
  }
}

// DO: Use try-catch for unexpected errors
try {
  await riskyOperation();
} catch (e, stackTrace) {
  debugPrint('Error: $e\n$stackTrace');
  // Handle or rethrow
}

// DON'T: Silently catch errors
try {
  await operation();
} catch (e) {
  // BAD: No error handling
}
```

### Flutter Best Practices

```dart
// DO: Extract widgets
class MyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _HeaderWidget(),  // ✅ Extracted
    );
  }
}

// DON'T: Build complex widgets inline
class MyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(  // ❌ Too complex inline
        child: Column(
          children: [
            // 50 lines of nested widgets...
          ],
        ),
      ),
    );
  }
}

// DO: Use const constructors
const Text('Hello');  // ✅
const SizedBox(height: 16);  // ✅

// DON'T: Skip const when possible
Text('Hello');  // ❌ Could be const
SizedBox(height: 16);  // ❌ Could be const
```

---

## 📝 Commit Guidelines

### Commit Message Format

```
<type>(<scope>): <subject>

<body>

<footer>
```

### Types

- **feat**: New feature
- **fix**: Bug fix
- **docs**: Documentation changes
- **style**: Code style changes (formatting, semicolons, etc.)
- **refactor**: Code refactoring
- **test**: Adding or updating tests
- **chore**: Maintenance tasks (dependencies, build, etc.)
- **perf**: Performance improvements

### Examples

```bash
feat(matchmaking): add ELO-based matchmaking algorithm

Implemented the ELO rating system for skill-based player matching.
Players are now matched based on their GMR points and medal level.

Closes #123

---

fix(venue): resolve booking time conflict

Fixed issue where users could book overlapping time slots.
Added validation to check for existing bookings before confirmation.

Fixes #456

---

docs(readme): update installation instructions

Added detailed Firebase setup steps and troubleshooting guide.

---

refactor(auth): migrate to Riverpod 2.0

Updated authentication providers to use new Riverpod syntax.
Removed deprecated notifiers and updated state management.
```

### Commit Rules

- ✅ Use present tense ("add feature" not "added feature")
- ✅ Use imperative mood ("move cursor to..." not "moves cursor to...")
- ✅ Limit subject line to 50 characters
- ✅ Wrap body at 72 characters
- ✅ Reference issues/PRs in footer
- ✅ One logical change per commit

---

## 🔄 Pull Request Process

### Before Submitting

- [ ] Code follows project architecture and style guidelines
- [ ] All tests pass (`flutter test`)
- [ ] No linting errors (`flutter analyze`)
- [ ] Code is properly formatted (`flutter format .`)
- [ ] Documentation is updated (if needed)
- [ ] Commits follow commit message guidelines
- [ ] Branch is up to date with main

```bash
# Update your branch
git fetch upstream
git rebase upstream/main
```

### PR Template

When creating a PR, use this template:

```markdown
## Description
Brief description of what this PR does

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Breaking change
- [ ] Documentation update

## Related Issues
Closes #123
Related to #456

## Screenshots (if applicable)
[Add screenshots here]

## Testing
- [ ] Unit tests added/updated
- [ ] Integration tests added/updated
- [ ] Manual testing completed

## Checklist
- [ ] Code follows style guidelines
- [ ] Self-reviewed code
- [ ] Commented hard-to-understand areas
- [ ] Updated documentation
- [ ] No new warnings
- [ ] Added tests that prove fix/feature works
- [ ] All tests passing
```

### Review Process

1. **Automated Checks**: CI/CD runs tests and linting
2. **Code Review**: Maintainers review your code
3. **Address Feedback**: Make requested changes
4. **Approval**: PR approved by maintainers
5. **Merge**: PR merged into main branch

### Review Criteria

Reviewers will check:
- ✅ Code quality and readability
- ✅ Architecture compliance
- ✅ Test coverage
- ✅ Performance implications
- ✅ Documentation completeness
- ✅ Security considerations

---

## 🧪 Testing Guidelines

### Test Structure

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Mocks
class MockYourFeatureRepository extends Mock 
    implements YourFeatureRepository {}

void main() {
  group('YourFeature Tests', () {
    late MockYourFeatureRepository mockRepository;
    late GetYourFeatures useCase;
    
    setUp(() {
      mockRepository = MockYourFeatureRepository();
      useCase = GetYourFeatures(mockRepository);
    });
    
    test('should return list of features on success', () async {
      // Arrange
      final expectedFeatures = [
        YourFeatureEntity(id: '1', name: 'Feature 1', createdAt: DateTime.now()),
      ];
      when(() => mockRepository.getYourFeatures())
          .thenAnswer((_) async => Right(expectedFeatures));
      
      // Act
      final result = await useCase();
      
      // Assert
      expect(result, Right(expectedFeatures));
      verify(() => mockRepository.getYourFeatures()).called(1);
    });
    
    test('should return ServerFailure on server error', () async {
      // Arrange
      when(() => mockRepository.getYourFeatures())
          .thenAnswer((_) async => Left(ServerFailure(message: 'Error')));
      
      // Act
      final result = await useCase();
      
      // Assert
      expect(result, isA<Left<Failure, List<YourFeatureEntity>>>());
    });
  });
}
```

### Test Coverage Requirements

- **Unit Tests**: 80%+ coverage for business logic
- **Widget Tests**: All custom widgets
- **Integration Tests**: Critical user flows
- **Golden Tests**: For UI consistency (optional)

### Running Tests

```bash
# All tests
flutter test

# Specific file
flutter test test/features/your_feature/domain/usecases/get_your_features_test.dart

# With coverage
flutter test --coverage

# Watch mode (run tests on file changes)
flutter test --watch
```

---

## 📚 Documentation

### When to Document

Document when:
- Creating a new feature
- Adding complex business logic
- Changing existing behavior
- Adding configuration options
- Creating public APIs

### What to Document

1. **Code Comments**
   ```dart
   /// Documents the purpose and usage
   /// 
   /// Use for public APIs and complex logic
   ```

2. **README Updates**
    - Add new features to feature list
    - Update installation instructions
    - Add new dependencies

3. **API Documentation**
    - Document all public methods
    - Include examples
    - Explain parameters and return values

4. **Architecture Decisions**
    - Create ADR (Architecture Decision Record) for major decisions
    - Document in `docs/architecture/` folder

---

## ❓ Getting Help

### Resources

- **Documentation**: Check README.md and code comments
- **Issues**: Search existing issues before creating new ones
- **Discussions**: Use GitHub Discussions for questions
- **Team Chat**: [Discord/Slack link if available]

### Asking Questions

When asking for help:

1. **Search first**: Check if question was already answered
2. **Provide context**: Explain what you're trying to achieve
3. **Show your work**: Share relevant code and error messages
4. **Be specific**: Include error logs, screenshots, environment details
5. **Format code**: Use markdown code blocks

**Good Question Example**:
```
I'm implementing the matchmaking feature and getting this error:
[Error log]

Here's my code:
[Code snippet]

Environment:
- Flutter: 3.5.4
- Device: Android Emulator

What I've tried:
- Checked Firebase configuration
- Verified network permissions
```

---

## 🎉 Thank You!

Your contributions make REDvsBLUE better for everyone. We appreciate your time and effort!

### Recognition

- Outstanding contributors will be mentioned in release notes
- Regular contributors may receive maintainer status
- All contributors are listed in our Contributors page

### Questions?

If you have any questions about contributing, feel free to:
- Open an issue with the `question` label
- Join our community chat
- Email us at: support@redvsblue.app

---

**Happy Coding! 🚀**

<div align="center">
  <p><em>Built with ❤️ by the REDvsBLUE Community</em></p>
</div>