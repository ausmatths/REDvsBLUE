#!/bin/bash

echo "🔧 FIXING FRIENDS FEATURE ERRORS"
echo "================================"
echo ""

# Check if we're in the right directory
if [ ! -f "pubspec.yaml" ]; then
    echo "❌ Error: Not in project root directory"
    echo "Please run this script from your REDvsBLUE project root"
    exit 1
fi

echo "✅ Found pubspec.yaml"
echo ""

# Step 1: Update exceptions.dart
echo "📝 Step 1: Updating exceptions.dart..."
cat > lib/core/errors/exceptions.dart << 'EXCEPTIONS'
/// Base exception class for data layer errors
/// These are converted to Failures in the repository layer
abstract class AppException implements Exception {
  final String message;
  
  AppException(this.message);
  
  @override
  String toString() => message;
}

/// Exception when server/API returns an error
class ServerException extends AppException {
  ServerException({required String message}) : super(message);
}

/// Exception when there's no internet connection
class NetworkException extends AppException {
  NetworkException({required String message}) : super(message);
}

/// Exception when validation fails (e.g., invalid input)
class ValidationException extends AppException {
  ValidationException({required String message}) : super(message);
}

/// Exception when requested resource is not found
class NotFoundExceptionCustom extends AppException {
  NotFoundExceptionCustom({required String message}) : super(message);
}

/// Exception when user is not authenticated
class AuthenticationException extends AppException {
  AuthenticationException({required String message}) : super(message);
}

/// Exception when user doesn't have permission
class PermissionException extends AppException {
  PermissionException({required String message}) : super(message);
}

/// Exception when caching data fails
class CacheException extends AppException {
  CacheException({required String message}) : super(message);
}
EXCEPTIONS

echo "✅ exceptions.dart updated"
echo ""

# Step 2: Fix import in friends_providers.dart
echo "📝 Step 2: Fixing import in friends_providers.dart..."
sed -i "s|import '../../../auth/presentation/providers/auth_providers.dart';|import '../../../auth/presentation/providers/auth_providers_with_profile.dart';|g" lib/features/friends/presentation/providers/friends_providers.dart
echo "✅ Import fixed"
echo ""

# Step 3: Run code generation
echo "📝 Step 3: Running code generation..."
flutter pub run build_runner build --delete-conflicting-outputs

if [ $? -eq 0 ]; then
    echo "✅ Code generation completed successfully"
else
    echo "⚠️  Warning: Code generation had issues"
    echo "You may need to run it manually"
fi
echo ""

# Step 4: Analyze code
echo "📝 Step 4: Running flutter analyze..."
flutter analyze

echo ""
echo "🎉 Fix script completed!"
echo ""
echo "Next steps:"
echo "1. Review any remaining errors above"
echo "2. Test the Friends feature"
echo "3. If there are still issues, check FRIENDS_FIX_GUIDE.md"
