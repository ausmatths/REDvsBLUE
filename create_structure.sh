#!/bin/bash

# Create lib directory and main files
mkdir -p lib
touch lib/main.dart
touch lib/app.dart

# Core directory structure
mkdir -p lib/core/constants
touch lib/core/constants/app_colors.dart
touch lib/core/constants/app_strings.dart
touch lib/core/constants/app_sizes.dart
touch lib/core/constants/sport_types.dart

mkdir -p lib/core/errors
touch lib/core/errors/failures.dart
touch lib/core/errors/exceptions.dart

mkdir -p lib/core/network
touch lib/core/network/dio_client.dart
touch lib/core/network/api_endpoints.dart

mkdir -p lib/core/router
touch lib/core/router/app_router.dart

mkdir -p lib/core/theme
touch lib/core/theme/app_theme.dart
touch lib/core/theme/text_styles.dart

mkdir -p lib/core/utils
touch lib/core/utils/validators.dart
touch lib/core/utils/formatters.dart
touch lib/core/utils/extensions.dart

# Features directory structure
# Auth feature
mkdir -p lib/features/auth/data/datasources
mkdir -p lib/features/auth/data/models
mkdir -p lib/features/auth/data/repositories
mkdir -p lib/features/auth/domain/entities
mkdir -p lib/features/auth/domain/repositories
mkdir -p lib/features/auth/domain/usecases
mkdir -p lib/features/auth/presentation/providers
mkdir -p lib/features/auth/presentation/screens
mkdir -p lib/features/auth/presentation/widgets

# Matchmaking feature
mkdir -p lib/features/matchmaking/data/datasources
mkdir -p lib/features/matchmaking/data/models
mkdir -p lib/features/matchmaking/data/repositories
mkdir -p lib/features/matchmaking/domain/entities
mkdir -p lib/features/matchmaking/domain/repositories
mkdir -p lib/features/matchmaking/domain/usecases
mkdir -p lib/features/matchmaking/presentation/providers
mkdir -p lib/features/matchmaking/presentation/screens
mkdir -p lib/features/matchmaking/presentation/widgets

# Venue feature
mkdir -p lib/features/venue/data/datasources
mkdir -p lib/features/venue/data/models
mkdir -p lib/features/venue/data/repositories
mkdir -p lib/features/venue/domain/entities
mkdir -p lib/features/venue/domain/repositories
mkdir -p lib/features/venue/domain/usecases
mkdir -p lib/features/venue/presentation/providers
mkdir -p lib/features/venue/presentation/screens
mkdir -p lib/features/venue/presentation/widgets

# Profile feature
mkdir -p lib/features/profile/data/datasources
mkdir -p lib/features/profile/data/models
mkdir -p lib/features/profile/data/repositories
mkdir -p lib/features/profile/domain/entities
mkdir -p lib/features/profile/domain/repositories
mkdir -p lib/features/profile/domain/usecases
mkdir -p lib/features/profile/presentation/providers
mkdir -p lib/features/profile/presentation/screens
mkdir -p lib/features/profile/presentation/widgets

# Tournament feature
mkdir -p lib/features/tournament/data/datasources
mkdir -p lib/features/tournament/data/models
mkdir -p lib/features/tournament/data/repositories
mkdir -p lib/features/tournament/domain/entities
mkdir -p lib/features/tournament/domain/repositories
mkdir -p lib/features/tournament/domain/usecases
mkdir -p lib/features/tournament/presentation/providers
mkdir -p lib/features/tournament/presentation/screens
mkdir -p lib/features/tournament/presentation/widgets

# Ranking feature
mkdir -p lib/features/ranking/data/datasources
mkdir -p lib/features/ranking/data/models
mkdir -p lib/features/ranking/data/repositories
mkdir -p lib/features/ranking/domain/entities
mkdir -p lib/features/ranking/domain/repositories
mkdir -p lib/features/ranking/domain/usecases
mkdir -p lib/features/ranking/presentation/providers
mkdir -p lib/features/ranking/presentation/screens
mkdir -p lib/features/ranking/presentation/widgets

# Shared directory structure
mkdir -p lib/shared/models
mkdir -p lib/shared/providers
mkdir -p lib/shared/widgets/buttons
mkdir -p lib/shared/widgets/cards
mkdir -p lib/shared/widgets/dialogs
mkdir -p lib/shared/widgets/loaders

# Assets directory structure
mkdir -p assets/images
mkdir -p assets/icons
mkdir -p assets/animations
mkdir -p assets/fonts

echo "REDvsBLUE folder structure created successfully!"

# Optional: Create a tree view of the structure
if command -v tree &> /dev/null; then
    echo ""
    echo "Project structure:"
    tree -d lib/
else
    echo "Install 'tree' command to see the folder structure visualization"
fi