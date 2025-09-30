import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

class PlayerProfileScreen extends StatefulWidget {
  const PlayerProfileScreen({super.key});

  @override
  State<PlayerProfileScreen> createState() => _PlayerProfileScreenState();
}

class _PlayerProfileScreenState extends State<PlayerProfileScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Mock user data
  final Map<String, dynamic> _userData = {
    'name': 'Austin Matthews',
    'username': '@ausmatths',
    'level': 42,
    'xp': 8750,
    'nextLevelXp': 10000,
    'totalMatches': 127,
    'wins': 89,
    'losses': 38,
    'winRate': 70.1,
    'currentStreak': 5,
    'bestStreak': 12,
    'profileImage': null,
    'joinDate': 'January 2025',
    'bio': 'Competitive player looking for challenging matches. Let\'s play!',
  };

  final List<Map<String, dynamic>> _achievements = [
    {'icon': '🏆', 'title': 'Champion', 'description': 'Win 50 matches', 'unlocked': true},
    {'icon': '🔥', 'title': 'Hot Streak', 'description': '10 wins in a row', 'unlocked': true},
    {'icon': '⚡', 'title': 'Speed Demon', 'description': 'Complete 5 quick matches', 'unlocked': true},
    {'icon': '🎯', 'title': 'Sharpshooter', 'description': 'Win with 80%+ accuracy', 'unlocked': false},
    {'icon': '👑', 'title': 'Tournament King', 'description': 'Win a tournament', 'unlocked': false},
    {'icon': '💪', 'title': 'Unstoppable', 'description': '15 wins in a row', 'unlocked': false},
  ];

  final List<Map<String, dynamic>> _matchHistory = [
    {
      'opponent': 'Sarah Chen',
      'sport': 'Basketball',
      'result': 'WIN',
      'score': '21-18',
      'date': 'Today',
      'venue': 'Downtown Courts',
      'duration': '45 min',
    },
    {
      'opponent': 'Mike Johnson',
      'sport': 'Tennis',
      'result': 'WIN',
      'score': '6-4, 6-3',
      'date': 'Yesterday',
      'venue': 'City Tennis Club',
      'duration': '1h 20min',
    },
    {
      'opponent': 'Alex Rivera',
      'sport': 'Badminton',
      'result': 'LOSS',
      'score': '19-21',
      'date': '2 days ago',
      'venue': 'Sports Complex',
      'duration': '35 min',
    },
    {
      'opponent': 'Emma Davis',
      'sport': 'Basketball',
      'result': 'WIN',
      'score': '21-15',
      'date': '3 days ago',
      'venue': 'Riverside Park',
      'duration': '40 min',
    },
    {
      'opponent': 'Chris Lee',
      'sport': 'Tennis',
      'result': 'WIN',
      'score': '7-5, 6-4',
      'date': '4 days ago',
      'venue': 'Central Courts',
      'duration': '1h 35min',
    },
  ];

  final Map<String, Map<String, dynamic>> _sportStats = {
    'Basketball': {'matches': 45, 'wins': 32, 'rating': 4.5},
    'Tennis': {'matches': 38, 'wins': 27, 'rating': 4.3},
    'Badminton': {'matches': 30, 'wins': 20, 'rating': 4.0},
    'Football': {'matches': 14, 'wins': 10, 'rating': 3.8},
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context),
          SliverToBoxAdapter(
            child: Column(
              children: [
                _buildStatsOverview(),
                _buildTabBar(),
                _buildTabContent(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 280,
      pinned: true,
      backgroundColor: Colors.red,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFE53935), Color(0xFFD32F2F)],
            ),
          ),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                _buildProfileImage(),
                const SizedBox(height: 16),
                Text(
                  _userData['name'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ).animate().fadeIn().slideY(begin: 0.3, end: 0),
                const SizedBox(height: 4),
                Text(
                  _userData['username'],
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 16,
                  ),
                ).animate().fadeIn(delay: 100.ms),
                const SizedBox(height: 12),
                _buildLevelBadge(),
              ],
            ),
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.edit, color: Colors.white),
          onPressed: () => _showEditProfileDialog(context),
        ),
        IconButton(
          icon: const Icon(Icons.settings, color: Colors.white),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Settings coming soon!')),
            );
          },
        ),
      ],
    );
  }

  Widget _buildProfileImage() {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 4),
        gradient: const LinearGradient(
          colors: [Color(0xFF1976D2), Color(0xFF1565C0)],
        ),
      ),
      child: const Icon(
        Icons.person,
        size: 50,
        color: Colors.white,
      ),
    ).animate().scale(duration: 500.ms);
  }

  Widget _buildLevelBadge() {
    final progress = _userData['xp'] / _userData['nextLevelXp'];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.stars, color: Colors.amber, size: 20),
          const SizedBox(width: 8),
          Text(
            'Level ${_userData['level']}',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 100,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.white.withOpacity(0.3),
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.amber),
                minHeight: 8,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '${_userData['xp']}/${_userData['nextLevelXp']}',
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 12,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms);
  }

  Widget _buildStatsOverview() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatCard('Total Matches', _userData['totalMatches'].toString(), Icons.sports),
          _buildStatCard('Win Rate', '${_userData['winRate']}%', Icons.emoji_events),
          _buildStatCard('Current Streak', '${_userData['currentStreak']}🔥', Icons.local_fire_department),
        ],
      ),
    ).animate().fadeIn(delay: 300.ms);
  }

  Widget _buildStatCard(String label, String value, IconData icon) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.red, size: 28),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(12),
        ),
        labelColor: Colors.white,
        unselectedLabelColor: Colors.black54,
        tabs: const [
          Tab(text: 'History'),
          Tab(text: 'Achievements'),
          Tab(text: 'Sports'),
        ],
      ),
    );
  }

  Widget _buildTabContent() {
    return SizedBox(
      height: 500,
      child: TabBarView(
        controller: _tabController,
        children: [
          _buildMatchHistory(),
          _buildAchievements(),
          _buildSportStats(),
        ],
      ),
    );
  }

  Widget _buildMatchHistory() {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: _matchHistory.length,
      itemBuilder: (context, index) {
        final match = _matchHistory[index];
        final isWin = match['result'] == 'WIN';

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isWin ? Colors.green.withOpacity(0.3) : Colors.red.withOpacity(0.3),
              width: 2,
            ),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: isWin ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isWin ? Icons.check_circle : Icons.cancel,
                color: isWin ? Colors.green : Colors.red,
                size: 30,
              ),
            ),
            title: Row(
              children: [
                Expanded(
                  child: Text(
                    match['opponent'],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isWin ? Colors.green : Colors.red,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    match['result'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.sports, size: 14, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(match['sport']),
                    const SizedBox(width: 16),
                    Icon(Icons.score, size: 14, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(match['score'], style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.location_on, size: 14, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Expanded(child: Text(match['venue'])),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.access_time, size: 14, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(match['date']),
                    const SizedBox(width: 16),
                    Text('⏱️ ${match['duration']}'),
                  ],
                ),
              ],
            ),
          ),
        ).animate().fadeIn(delay: (index * 50).ms).slideX(begin: 0.2, end: 0);
      },
    );
  }

  Widget _buildAchievements() {
    return GridView.builder(
      padding: const EdgeInsets.all(20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: _achievements.length,
      itemBuilder: (context, index) {
        final achievement = _achievements[index];
        final unlocked = achievement['unlocked'];

        return Container(
          decoration: BoxDecoration(
            color: unlocked ? Colors.amber.withOpacity(0.1) : Colors.grey[200],
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: unlocked ? Colors.amber : Colors.grey[300]!,
              width: 2,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                achievement['icon'],
                style: TextStyle(
                  fontSize: 48,
                  color: unlocked ? null : Colors.grey,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                achievement['title'],
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: unlocked ? Colors.black87 : Colors.grey,
                ),
              ),
              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  achievement['description'],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ),
              if (unlocked)
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'UNLOCKED',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
        ).animate().fadeIn(delay: (index * 50).ms).scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1));
      },
    );
  }

  Widget _buildSportStats() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: _sportStats.entries.map((entry) {
        final sport = entry.key;
        final stats = entry.value;
        final winRate = (stats['wins'] / stats['matches'] * 100).toStringAsFixed(1);

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.sports, color: Colors.red),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      sport,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Row(
                    children: List.generate(5, (index) {
                      return Icon(
                        index < stats['rating'] ? Icons.star : Icons.star_border,
                        color: Colors.amber,
                        size: 20,
                      );
                    }),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildSportStatItem('Matches', stats['matches'].toString()),
                  _buildSportStatItem('Wins', stats['wins'].toString()),
                  _buildSportStatItem('Win Rate', '$winRate%'),
                ],
              ),
            ],
          ),
        ).animate().fadeIn().slideX(begin: 0.2, end: 0);
      }).toList(),
    );
  }

  Widget _buildSportStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.red,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  void _showEditProfileDialog(BuildContext context) {
    final nameController = TextEditingController(text: _userData['name']);
    final bioController = TextEditingController(text: _userData['bio']);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Edit Profile'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: bioController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Bio',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.info),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              setState(() {
                _userData['name'] = nameController.text;
                _userData['bio'] = bioController.text;
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Profile updated successfully!'),
                  backgroundColor: Colors.green,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              );
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}