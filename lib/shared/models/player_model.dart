// Location: lib/shared/models/player_model.dart
// This is a simple version without Freezed that will work immediately
// No code generation required

enum MedalLevel {
  bronze,
  silver,
  gold,
  platinum,
  diamond,
  master,
  grandMaster,
}

enum SportType {
  badminton,
  football,
  cricket,
  pickleball,
}

class Player {
  final String id;
  final String name;
  final String email;
  final String? phoneNumber;
  final String? profileImageUrl;
  final Map<SportType, PlayerRating> ratings;
  final int totalGmrPoints;
  final List<String> achievements;
  final List<String> tournamentIds;
  final List<String> matchHistory;
  final DateTime? createdAt;
  final DateTime? lastPlayedAt;
  final bool isActive;
  final String? bio;
  final String? location;
  final Map<String, dynamic> preferences;

  Player({
    required this.id,
    required this.name,
    required this.email,
    this.phoneNumber,
    this.profileImageUrl,
    Map<SportType, PlayerRating>? ratings,
    this.totalGmrPoints = 0,
    List<String>? achievements,
    List<String>? tournamentIds,
    List<String>? matchHistory,
    this.createdAt,
    this.lastPlayedAt,
    this.isActive = true,
    this.bio,
    this.location,
    Map<String, dynamic>? preferences,
  })  : ratings = ratings ?? {},
        achievements = achievements ?? [],
        tournamentIds = tournamentIds ?? [],
        matchHistory = matchHistory ?? [],
        preferences = preferences ?? {};

  // Factory constructor for creating from JSON
  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      phoneNumber: json['phoneNumber'] as String?,
      profileImageUrl: json['profileImageUrl'] as String?,
      totalGmrPoints: json['totalGmrPoints'] as int? ?? 0,
      isActive: json['isActive'] as bool? ?? true,
      bio: json['bio'] as String?,
      location: json['location'] as String?,
      achievements: (json['achievements'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      tournamentIds: (json['tournamentIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      matchHistory: (json['matchHistory'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      lastPlayedAt: json['lastPlayedAt'] != null
          ? DateTime.parse(json['lastPlayedAt'] as String)
          : null,
      preferences: json['preferences'] as Map<String, dynamic>? ?? {},
    );
  }

  // Method to convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'profileImageUrl': profileImageUrl,
      'totalGmrPoints': totalGmrPoints,
      'achievements': achievements,
      'tournamentIds': tournamentIds,
      'matchHistory': matchHistory,
      'createdAt': createdAt?.toIso8601String(),
      'lastPlayedAt': lastPlayedAt?.toIso8601String(),
      'isActive': isActive,
      'bio': bio,
      'location': location,
      'preferences': preferences,
    };
  }

  // Copy with method for updating player data
  Player copyWith({
    String? id,
    String? name,
    String? email,
    String? phoneNumber,
    String? profileImageUrl,
    Map<SportType, PlayerRating>? ratings,
    int? totalGmrPoints,
    List<String>? achievements,
    List<String>? tournamentIds,
    List<String>? matchHistory,
    DateTime? createdAt,
    DateTime? lastPlayedAt,
    bool? isActive,
    String? bio,
    String? location,
    Map<String, dynamic>? preferences,
  }) {
    return Player(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      ratings: ratings ?? this.ratings,
      totalGmrPoints: totalGmrPoints ?? this.totalGmrPoints,
      achievements: achievements ?? this.achievements,
      tournamentIds: tournamentIds ?? this.tournamentIds,
      matchHistory: matchHistory ?? this.matchHistory,
      createdAt: createdAt ?? this.createdAt,
      lastPlayedAt: lastPlayedAt ?? this.lastPlayedAt,
      isActive: isActive ?? this.isActive,
      bio: bio ?? this.bio,
      location: location ?? this.location,
      preferences: preferences ?? this.preferences,
    );
  }
}

class PlayerRating {
  final SportType sport;
  final int gmrPoints;
  final MedalLevel medalLevel;
  final int medalSubLevel; // 1-5 within each medal
  final int matchesPlayed;
  final int wins;
  final int losses;
  final double? winRate;
  final DateTime? lastMatchDate;
  final int currentStreak;
  final int bestStreak;
  final int tournamentsWon;
  final int tournamentsParticipated;

  PlayerRating({
    required this.sport,
    required this.gmrPoints,
    required this.medalLevel,
    required this.medalSubLevel,
    required this.matchesPlayed,
    required this.wins,
    required this.losses,
    this.winRate,
    this.lastMatchDate,
    this.currentStreak = 0,
    this.bestStreak = 0,
    this.tournamentsWon = 0,
    this.tournamentsParticipated = 0,
  });

  // Factory constructor for creating from JSON
  factory PlayerRating.fromJson(Map<String, dynamic> json) {
    return PlayerRating(
      sport: SportType.values.firstWhere(
            (e) => e.toString() == 'SportType.${json['sport']}',
        orElse: () => SportType.badminton,
      ),
      gmrPoints: json['gmrPoints'] as int,
      medalLevel: MedalLevel.values.firstWhere(
            (e) => e.toString() == 'MedalLevel.${json['medalLevel']}',
        orElse: () => MedalLevel.bronze,
      ),
      medalSubLevel: json['medalSubLevel'] as int,
      matchesPlayed: json['matchesPlayed'] as int,
      wins: json['wins'] as int,
      losses: json['losses'] as int,
      winRate: (json['winRate'] as num?)?.toDouble(),
      lastMatchDate: json['lastMatchDate'] != null
          ? DateTime.parse(json['lastMatchDate'] as String)
          : null,
      currentStreak: json['currentStreak'] as int? ?? 0,
      bestStreak: json['bestStreak'] as int? ?? 0,
      tournamentsWon: json['tournamentsWon'] as int? ?? 0,
      tournamentsParticipated: json['tournamentsParticipated'] as int? ?? 0,
    );
  }

  // Method to convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'sport': sport.toString().split('.').last,
      'gmrPoints': gmrPoints,
      'medalLevel': medalLevel.toString().split('.').last,
      'medalSubLevel': medalSubLevel,
      'matchesPlayed': matchesPlayed,
      'wins': wins,
      'losses': losses,
      'winRate': winRate,
      'lastMatchDate': lastMatchDate?.toIso8601String(),
      'currentStreak': currentStreak,
      'bestStreak': bestStreak,
      'tournamentsWon': tournamentsWon,
      'tournamentsParticipated': tournamentsParticipated,
    };
  }

  // Calculate GMR points based on match result
  int calculateGmrChange({
    required bool isWin,
    required MedalLevel opponentMedal,
    required int opponentGmr,
    bool hasPlayedThisMonth = true,
  }) {
    // Base points
    int basePoints = isWin ? 20 : -20;

    // Medal/level bonus
    if (opponentMedal.index >= medalLevel.index) {
      basePoints += isWin ? 5 : -5;
    }

    // Consistency bonus
    if (hasPlayedThisMonth) {
      basePoints += 5;
    }

    // Ensure minimum point loss
    if (!isWin && basePoints < -30) {
      basePoints = -30;
    }

    return basePoints;
  }

  // Get medal range for current level
  (int, int) getMedalRange() {
    switch (medalLevel) {
      case MedalLevel.bronze:
        return (0, 499);
      case MedalLevel.silver:
        return (500, 999);
      case MedalLevel.gold:
        return (1000, 1499);
      case MedalLevel.platinum:
        return (1500, 1999);
      case MedalLevel.diamond:
        return (2000, 2499);
      case MedalLevel.master:
        return (2500, 2999);
      case MedalLevel.grandMaster:
        return (3000, 10000);
    }
  }

  // Get sublevel within medal (1-5)
  int getSubLevel() {
    final range = getMedalRange();
    final rangeSize = (range.$2 - range.$1) ~/ 5;
    final position = gmrPoints - range.$1;
    return 5 - (position ~/ rangeSize).clamp(0, 4);
  }

  // Check if close to promotion
  bool isNearPromotion() {
    final range = getMedalRange();
    return gmrPoints >= range.$2 - 50;
  }

  // Check if close to demotion
  bool isNearDemotion() {
    final range = getMedalRange();
    return gmrPoints <= range.$1 + 50 && medalLevel != MedalLevel.bronze;
  }

  // Calculate win rate
  double calculateWinRate() {
    if (matchesPlayed == 0) return 0.0;
    return (wins / matchesPlayed) * 100;
  }

  // Copy with method for updating rating data
  PlayerRating copyWith({
    SportType? sport,
    int? gmrPoints,
    MedalLevel? medalLevel,
    int? medalSubLevel,
    int? matchesPlayed,
    int? wins,
    int? losses,
    double? winRate,
    DateTime? lastMatchDate,
    int? currentStreak,
    int? bestStreak,
    int? tournamentsWon,
    int? tournamentsParticipated,
  }) {
    return PlayerRating(
      sport: sport ?? this.sport,
      gmrPoints: gmrPoints ?? this.gmrPoints,
      medalLevel: medalLevel ?? this.medalLevel,
      medalSubLevel: medalSubLevel ?? this.medalSubLevel,
      matchesPlayed: matchesPlayed ?? this.matchesPlayed,
      wins: wins ?? this.wins,
      losses: losses ?? this.losses,
      winRate: winRate ?? this.winRate,
      lastMatchDate: lastMatchDate ?? this.lastMatchDate,
      currentStreak: currentStreak ?? this.currentStreak,
      bestStreak: bestStreak ?? this.bestStreak,
      tournamentsWon: tournamentsWon ?? this.tournamentsWon,
      tournamentsParticipated: tournamentsParticipated ?? this.tournamentsParticipated,
    );
  }
}

// Extension methods for MedalLevel
extension MedalLevelExtension on MedalLevel {
  String get displayName {
    switch (this) {
      case MedalLevel.bronze:
        return 'Bronze';
      case MedalLevel.silver:
        return 'Silver';
      case MedalLevel.gold:
        return 'Gold';
      case MedalLevel.platinum:
        return 'Platinum';
      case MedalLevel.diamond:
        return 'Diamond';
      case MedalLevel.master:
        return 'Master';
      case MedalLevel.grandMaster:
        return 'Grand Master';
    }
  }

  String get colorHex {
    switch (this) {
      case MedalLevel.bronze:
        return '#CD7F32';
      case MedalLevel.silver:
        return '#C0C0C0';
      case MedalLevel.gold:
        return '#FFD700';
      case MedalLevel.platinum:
        return '#E5E4E2';
      case MedalLevel.diamond:
        return '#B9F2FF';
      case MedalLevel.master:
        return '#9932CC';
      case MedalLevel.grandMaster:
        return '#FF4500';
    }
  }
}

// Extension methods for SportType
extension SportTypeExtension on SportType {
  String get displayName {
    switch (this) {
      case SportType.badminton:
        return 'Badminton';
      case SportType.football:
        return 'Football';
      case SportType.cricket:
        return 'Cricket';
      case SportType.pickleball:
        return 'Pickleball';
    }
  }

  String get icon {
    switch (this) {
      case SportType.badminton:
        return '🏸';
      case SportType.football:
        return '⚽';
      case SportType.cricket:
        return '🏏';
      case SportType.pickleball:
        return '🎾';
    }
  }
}