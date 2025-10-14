import 'package:flutter/material.dart';

class SportTypes {
  // Sport type constants
  static const String badminton = 'Badminton';
  static const String cricket = 'Cricket';
  static const String football = 'Football';
  static const String basketball = 'Basketball';
  static const String tennis = 'Tennis';
  static const String volleyball = 'Volleyball';
  static const String tableTennis = 'Table Tennis';
  static const String squash = 'Squash';

  // List of all supported sports
  static const List<String> allSports = [
    badminton,
    cricket,
    football,
    basketball,
    tennis,
    volleyball,
    tableTennis,
    squash,
  ];

  // Get icon for each sport
  static IconData getSportIcon(String sport) {
    switch (sport.toLowerCase()) {
      case 'badminton':
        return Icons.sports_tennis;
      case 'cricket':
        return Icons.sports_cricket;
      case 'football':
      case 'soccer':
        return Icons.sports_soccer;
      case 'basketball':
        return Icons.sports_basketball;
      case 'tennis':
        return Icons.sports_tennis;
      case 'volleyball':
        return Icons.sports_volleyball;
      case 'table tennis':
      case 'tabletennis':
        return Icons.table_restaurant;
      case 'squash':
        return Icons.sports_tennis;
      default:
        return Icons.sports;
    }
  }

  // Get color for each sport (optional)
  static Color getSportColor(String sport) {
    switch (sport.toLowerCase()) {
      case 'badminton':
        return const Color(0xFF4CAF50); // Green
      case 'cricket':
        return const Color(0xFF2196F3); // Blue
      case 'football':
      case 'soccer':
        return const Color(0xFFFF9800); // Orange
      case 'basketball':
        return const Color(0xFFFF5722); // Deep Orange
      case 'tennis':
        return const Color(0xFFFFEB3B); // Yellow
      case 'volleyball':
        return const Color(0xFF9C27B0); // Purple
      case 'table tennis':
      case 'tabletennis':
        return const Color(0xFF00BCD4); // Cyan
      case 'squash':
        return const Color(0xFF795548); // Brown
      default:
        return const Color(0xFF9E9E9E); // Grey
    }
  }
}