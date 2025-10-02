import 'package:flutter/material.dart';

class DefaultAvatar extends StatelessWidget {
  final double size;
  final String? name;
  final String? imageUrl;

  const DefaultAvatar({
    super.key,
    this.size = 50,
    this.name,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    // If there's an image URL, try to load it
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return CircleAvatar(
        radius: size / 2,
        backgroundImage: NetworkImage(imageUrl!),
        onBackgroundImageError: (exception, stackTrace) {
          // If image fails to load, show default
          debugPrint('Failed to load image: $exception');
        },
        child: _buildFallback(),
      );
    }

    // Default avatar
    return CircleAvatar(
      radius: size / 2,
      backgroundColor: Colors.grey[400],
      child: _buildFallback(),
    );
  }

  Widget? _buildFallback() {
    if (name != null && name!.isNotEmpty) {
      // Show initials if name is available
      final initials = name!
          .split(' ')
          .take(2)
          .map((word) => word.isNotEmpty ? word[0].toUpperCase() : '')
          .join();

      return Text(
        initials.isEmpty ? 'U' : initials,
        style: TextStyle(
          color: Colors.white,
          fontSize: size * 0.4,
          fontWeight: FontWeight.bold,
        ),
      );
    }

    // Show person icon as fallback
    return Icon(
      Icons.person,
      size: size * 0.6,
      color: Colors.white,
    );
  }
}