import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class VenueCard extends StatelessWidget {
  final Map<String, dynamic> venue;
  final VoidCallback onTap;

  const VenueCard({
    super.key,
    required this.venue,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Venue Image
            Container(
              height: 160,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                gradient: LinearGradient(
                  colors: [
                    AppColors.primaryRed.withOpacity(0.7),
                    AppColors.primaryBlue.withOpacity(0.7),
                  ],
                ),
              ),
              child: Stack(
                children: [
                  // Placeholder for venue image
                  if (venue['imageUrl'] != null)
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                      child: Image.network(
                        venue['imageUrl'],
                        width: double.infinity,
                        height: 160,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return _buildImagePlaceholder();
                        },
                      ),
                    )
                  else
                    _buildImagePlaceholder(),

                  // Rating badge
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            venue['rating']?.toString() ?? '4.5',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Available courts badge
                  Positioned(
                    bottom: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${venue['availableCourts'] ?? 3} courts available',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Venue Details
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Venue Name
                  Text(
                    venue['name'] ?? 'Sports Complex',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.grey900,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Location
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        size: 16,
                        color: AppColors.grey600,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          venue['address'] ?? 'Downtown Sports Center',
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.grey600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Distance and Price
                  Row(
                    children: [
                      // Distance
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.grey100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.directions_car_outlined,
                              size: 14,
                              color: AppColors.grey700,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${venue['distance'] ?? '2.5'} km',
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.grey700,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),

                      // Price
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primaryBlue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.currency_rupee,
                              size: 14,
                              color: AppColors.primaryBlue,
                            ),
                            Text(
                              '${venue['pricePerHour'] ?? '500'}/hr',
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.primaryBlue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const Spacer(),

                      // Sports Available
                      Row(
                        children: _buildSportsIcons(venue['sports'] ?? []),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16),
        ),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryRed,
            AppColors.primaryBlue,
          ],
        ),
      ),
      child: const Center(
        child: Icon(
          Icons.sports_tennis,
          size: 60,
          color: Colors.white30,
        ),
      ),
    );
  }

  List<Widget> _buildSportsIcons(List<dynamic> sports) {
    final List<Widget> icons = [];
    final sportsIconMap = {
      'badminton': Icons.sports_tennis,
      'football': Icons.sports_soccer,
      'cricket': Icons.sports_cricket,
      'basketball': Icons.sports_basketball,
      'tennis': Icons.sports_tennis,
      'volleyball': Icons.sports_volleyball,
      'swimming': Icons.pool,
      'gym': Icons.fitness_center,
    };

    final sportsToShow = sports.take(3).toList();

    for (final sport in sportsToShow) {
      final sportName = sport.toString().toLowerCase();
      icons.add(
        Container(
          margin: const EdgeInsets.only(left: 4),
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: AppColors.grey100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            sportsIconMap[sportName] ?? Icons.sports,
            size: 16,
            color: AppColors.grey700,
          ),
        ),
      );
    }

    if (sports.length > 3) {
      icons.add(
        Container(
          margin: const EdgeInsets.only(left: 4),
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.grey100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            '+${sports.length - 3}',
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.grey700,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }

    return icons;
  }
}