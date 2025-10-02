import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../widgets/venue_card.dart';

class VenueListScreen extends StatefulWidget {
  const VenueListScreen({super.key});

  @override
  State<VenueListScreen> createState() => _VenueListScreenState();
}

class _VenueListScreenState extends State<VenueListScreen> {
  String _selectedSport = 'all';
  String _sortBy = 'distance';

  // Mock data - Replace with actual API call
  final List<Map<String, dynamic>> _venues = [
    {
      'id': '1',
      'name': 'Elite Sports Complex',
      'address': 'MG Road, Bangalore',
      'rating': 4.8,
      'distance': 2.5,
      'pricePerHour': 600,
      'availableCourts': 4,
      'sports': ['badminton', 'tennis', 'basketball'],
      'imageUrl': null, // Will use placeholder
    },
    {
      'id': '2',
      'name': 'Victory Arena',
      'address': 'Koramangala, Bangalore',
      'rating': 4.5,
      'distance': 3.8,
      'pricePerHour': 500,
      'availableCourts': 2,
      'sports': ['badminton', 'cricket', 'football'],
      'imageUrl': null,
    },
    {
      'id': '3',
      'name': 'Champions Court',
      'address': 'Indiranagar, Bangalore',
      'rating': 4.9,
      'distance': 1.2,
      'pricePerHour': 800,
      'availableCourts': 6,
      'sports': ['badminton', 'tennis', 'volleyball', 'swimming'],
      'imageUrl': null,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.white,
              AppColors.grey50,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () => context.go('/home'),
                        ),
                        const Expanded(
                          child: Text(
                            'Nearby Venues',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.filter_list),
                          onPressed: _showFilterBottomSheet,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Search Bar
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Search venues...',
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.location_on),
                          onPressed: () {
                            // Show location picker
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: AppColors.grey100,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Sport Filter Chips
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildSportChip('All', 'all'),
                          _buildSportChip('Badminton', 'badminton'),
                          _buildSportChip('Cricket', 'cricket'),
                          _buildSportChip('Football', 'football'),
                          _buildSportChip('Tennis', 'tennis'),
                          _buildSportChip('Basketball', 'basketball'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Venues List
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.only(top: 8, bottom: 80),
                  itemCount: _venues.length,
                  itemBuilder: (context, index) {
                    final venue = _venues[index];
                    return VenueCard(
                      venue: venue,
                      onTap: () {
                        context.go('/venue-details', extra: venue);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),

      // Floating Map Button
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Show map view
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Map view coming soon!')),
          );
        },
        backgroundColor: AppColors.primaryBlue,
        icon: const Icon(Icons.map, color: Colors.white),
        label: const Text(
          'Map View',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildSportChip(String label, String value) {
    final isSelected = _selectedSport == value;

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            _selectedSport = value;
            // Filter venues based on sport
          });
        },
        selectedColor: AppColors.primaryBlue.withOpacity(0.2),
        checkmarkColor: AppColors.primaryBlue,
        labelStyle: TextStyle(
          color: isSelected ? AppColors.primaryBlue : AppColors.grey700,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Sort & Filter',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  const Text(
                    'Sort By',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Sort Options
                  ...[
                    {'label': 'Distance', 'value': 'distance'},
                    {'label': 'Price (Low to High)', 'value': 'price_asc'},
                    {'label': 'Price (High to Low)', 'value': 'price_desc'},
                    {'label': 'Rating', 'value': 'rating'},
                  ].map((option) {
                    return RadioListTile<String>(
                      title: Text(option['label']!),
                      value: option['value']!,
                      groupValue: _sortBy,
                      onChanged: (value) {
                        setModalState(() {
                          _sortBy = value!;
                        });
                        setState(() {
                          _sortBy = value!;
                        });
                      },
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                    );
                  }).toList(),

                  const SizedBox(height: 20),

                  // Apply Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        // Apply filters
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryBlue,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text(
                        'Apply Filters',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}