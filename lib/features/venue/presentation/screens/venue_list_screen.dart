import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class VenueListScreen extends StatefulWidget {
  const VenueListScreen({super.key});

  @override
  State<VenueListScreen> createState() => _VenueListScreenState();
}

class _VenueListScreenState extends State<VenueListScreen> {
  String _selectedSport = 'All';
  String _selectedSort = 'Distance';
  bool _showMapView = false;

  final List<Map<String, dynamic>> _mockVenues = [
    {
      'id': '1',
      'name': 'Olympic Sports Complex',
      'address': '123 Main Street, Downtown',
      'distance': 1.2,
      'rating': 4.8,
      'reviews': 342,
      'pricePerHour': 50,
      'sports': ['Badminton', 'Football', 'Cricket'],
      'courts': 8,
      'availableSlots': 5,
      'image': 'https://via.placeholder.com/300x200',
      'amenities': ['Parking', 'Changing Room', 'Cafeteria', 'Equipment'],
      'openTime': '6:00 AM',
      'closeTime': '11:00 PM',
    },
    {
      'id': '2',
      'name': 'City Sports Arena',
      'address': '456 Park Avenue, Westside',
      'distance': 2.5,
      'rating': 4.6,
      'reviews': 228,
      'pricePerHour': 40,
      'sports': ['Badminton', 'Pickleball'],
      'courts': 6,
      'availableSlots': 3,
      'image': 'https://via.placeholder.com/300x200',
      'amenities': ['Parking', 'Changing Room', 'Water'],
      'openTime': '7:00 AM',
      'closeTime': '10:00 PM',
    },
    {
      'id': '3',
      'name': 'Green Field Stadium',
      'address': '789 Stadium Road, North District',
      'distance': 3.8,
      'rating': 4.9,
      'reviews': 512,
      'pricePerHour': 75,
      'sports': ['Football', 'Cricket'],
      'courts': 4,
      'availableSlots': 2,
      'image': 'https://via.placeholder.com/300x200',
      'amenities': ['Parking', 'Changing Room', 'Cafeteria', 'Floodlights'],
      'openTime': '5:00 AM',
      'closeTime': '12:00 AM',
    },
    {
      'id': '4',
      'name': 'Riverside Recreation Center',
      'address': '321 River View, East Side',
      'distance': 4.2,
      'rating': 4.5,
      'reviews': 189,
      'pricePerHour': 35,
      'sports': ['Badminton', 'Pickleball', 'Cricket'],
      'courts': 10,
      'availableSlots': 8,
      'image': 'https://via.placeholder.com/300x200',
      'amenities': ['Parking', 'Equipment Rental'],
      'openTime': '6:00 AM',
      'closeTime': '10:00 PM',
    },
    {
      'id': '5',
      'name': 'Elite Sports Hub',
      'address': '555 Champions Way, Central',
      'distance': 5.5,
      'rating': 4.7,
      'reviews': 403,
      'pricePerHour': 60,
      'sports': ['All Sports'],
      'courts': 12,
      'availableSlots': 6,
      'image': 'https://via.placeholder.com/300x200',
      'amenities': ['Parking', 'Pro Shop', 'Coaching', 'Cafeteria'],
      'openTime': '6:00 AM',
      'closeTime': '11:00 PM',
    },
  ];

  List<Map<String, dynamic>> get filteredVenues {
    var venues = List<Map<String, dynamic>>.from(_mockVenues);

    // Filter by sport
    if (_selectedSport != 'All') {
      venues = venues.where((venue) {
        final sports = venue['sports'] as List<String>;
        return sports.contains(_selectedSport) || sports.contains('All Sports');
      }).toList();
    }

    // Sort venues
    if (_selectedSort == 'Distance') {
      venues.sort((a, b) => (a['distance'] as double).compareTo(b['distance'] as double));
    } else if (_selectedSort == 'Price') {
      venues.sort((a, b) => (a['pricePerHour'] as int).compareTo(b['pricePerHour'] as int));
    } else if (_selectedSort == 'Rating') {
      venues.sort((a, b) => (b['rating'] as double).compareTo(a['rating'] as double));
    }

    return venues;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('Find Venues'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(_showMapView ? Icons.list : Icons.map),
            onPressed: () {
              setState(() {
                _showMapView = !_showMapView;
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Filters
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              children: [
                // Sport filter chips
                SizedBox(
                  height: 40,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _buildFilterChip('All', 'All'),
                      _buildFilterChip('Badminton', 'Badminton'),
                      _buildFilterChip('Football', 'Football'),
                      _buildFilterChip('Cricket', 'Cricket'),
                      _buildFilterChip('Pickleball', 'Pickleball'),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                // Sort options
                Row(
                  children: [
                    const Text('Sort by: ', style: TextStyle(fontWeight: FontWeight.w500)),
                    const SizedBox(width: 8),
                    _buildSortButton('Distance'),
                    _buildSortButton('Price'),
                    _buildSortButton('Rating'),
                  ],
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: _showMapView ? _buildMapView() : _buildListView(),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String value) {
    final isSelected = _selectedSport == value;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            _selectedSport = selected ? value : 'All';
          });
        },
        selectedColor: Colors.red.shade100,
        checkmarkColor: Colors.red.shade700,
        labelStyle: TextStyle(
          color: isSelected ? Colors.red.shade700 : Colors.grey.shade700,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildSortButton(String sort) {
    final isSelected = _selectedSort == sort;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: TextButton(
        onPressed: () {
          setState(() {
            _selectedSort = sort;
          });
        },
        style: TextButton.styleFrom(
          backgroundColor: isSelected ? Colors.blue.shade50 : null,
          foregroundColor: isSelected ? Colors.blue.shade700 : Colors.grey.shade600,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          minimumSize: Size.zero,
        ),
        child: Text(
          sort,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildListView() {
    final venues = filteredVenues;

    if (venues.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              'No venues found',
              style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 8),
            Text(
              'Try changing your filters',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: venues.length,
      itemBuilder: (context, index) {
        final venue = venues[index];
        return _buildVenueCard(venue);
      },
    );
  }

  Widget _buildVenueCard(Map<String, dynamic> venue) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          context.push('/venue-details', extra: venue);
        },
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Container(
              height: 150,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                gradient: LinearGradient(
                  colors: [
                    Colors.grey.shade300,
                    Colors.grey.shade200,
                  ],
                ),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Icon(
                      Icons.stadium,
                      size: 60,
                      color: Colors.grey.shade400,
                    ),
                  ),
                  // Distance badge
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.location_on, size: 14, color: Colors.white),
                          const SizedBox(width: 4),
                          Text(
                            '${venue['distance']} km',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Available slots badge
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: venue['availableSlots'] > 3
                            ? Colors.green.shade600
                            : Colors.orange.shade600,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${venue['availableSlots']} slots today',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name and rating
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          venue['name'],
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Icon(Icons.star, size: 16, color: Colors.amber.shade600),
                          const SizedBox(width: 4),
                          Text(
                            venue['rating'].toString(),
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          Text(
                            ' (${venue['reviews']})',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // Address
                  Row(
                    children: [
                      Icon(Icons.location_on_outlined, size: 16, color: Colors.grey.shade600),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          venue['address'],
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Sports tags
                  Wrap(
                    spacing: 8,
                    children: (venue['sports'] as List<String>).map((sport) {
                      return Chip(
                        label: Text(
                          sport,
                          style: const TextStyle(fontSize: 12),
                        ),
                        backgroundColor: Colors.blue.shade50,
                        labelStyle: TextStyle(color: Colors.blue.shade700),
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        visualDensity: VisualDensity.compact,
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 12),

                  // Bottom info
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Price
                      Row(
                        children: [
                          Text(
                            '\$${venue['pricePerHour']}',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.green.shade700,
                            ),
                          ),
                          Text(
                            '/hour',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),

                      // Book button
                      ElevatedButton(
                        onPressed: () {
                          context.push('/venue-booking', extra: venue);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.shade400,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        ),
                        child: const Text('Book Now'),
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

  Widget _buildMapView() {
    return Stack(
      children: [
        // Map placeholder
        Container(
          color: Colors.grey.shade200,
          child: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.map, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'Map View',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
                SizedBox(height: 8),
                Text(
                  'Google Maps integration coming soon',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ),
        ),

        // Venue markers (mock)
        ...filteredVenues.asMap().entries.map((entry) {
          final index = entry.key;
          final venue = entry.value;
          return Positioned(
            top: 100.0 + (index * 80),
            left: 50.0 + (index * 40),
            child: GestureDetector(
              onTap: () {
                _showVenueBottomSheet(venue);
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red.shade400,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.location_on,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
          );
        }).toList(),
      ],
    );
  }

  void _showVenueBottomSheet(Map<String, dynamic> venue) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                venue['name'],
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.star, size: 16, color: Colors.amber.shade600),
                  const SizedBox(width: 4),
                  Text('${venue['rating']} (${venue['reviews']} reviews)'),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                venue['address'],
                style: TextStyle(color: Colors.grey.shade600),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '\$${venue['pricePerHour']}/hour',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade700,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      context.push('/venue-details', extra: venue);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade400,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text('View Details'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}