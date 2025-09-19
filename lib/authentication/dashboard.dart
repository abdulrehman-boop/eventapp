import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);
  @override
  State<DashboardPage> createState() => _DashboardPageState();
}
class _DashboardPageState extends State<DashboardPage> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _cardAnimationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _cardAnimation;
  final TextEditingController _searchController = TextEditingController();
  String selectedCity = 'Faisalabad';
  int selectedCategoryIndex = 0;
  bool showNotificationBadge = true;
  final List<String> cities = ['Faisalabad', 'Karachi', 'Lahore', 'Islamabad', 'Multan', 'Rawalpindi'];
  final List<Map<String, dynamic>> categories = [
    {'name': 'All', 'icon': Icons.apps, 'color': Colors.deepPurpleAccent},
    {'name': 'Music', 'icon': Icons.music_note, 'color': Colors.purple},
    {'name': 'Tech', 'icon': Icons.computer, 'color': Colors.blue},
    {'name': 'Sports', 'icon': Icons.sports_soccer, 'color': Colors.green},
    {'name': 'Food', 'icon': Icons.restaurant, 'color': Colors.orange},
    {'name': 'Art', 'icon': Icons.palette, 'color': Colors.pink},
    {'name': 'Gaming', 'icon': Icons.games, 'color': Colors.red},
  ];

  // User Data
  final Map<String, String> userData = {
    'name': 'Ahmed Ali',
    'avatar': 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?auto=format&fit=crop&w=400&q=60',
  };

  // Quick Stats
  final Map<String, dynamic> quickStats = {
    'upcomingEvents': 3,
    'thisWeekEvents': 8,
    'favoriteEvents': 12,
    'completedEvents': 24,
  };

  // Featured Events (Carousel)
  final List<Map<String, dynamic>> featuredEvents = [
    {
      'id': 'f1',
      'title': 'Summer Music Festival 2025',
      'category': 'Music',
      'date': 'Dec 15, 2025',
      'location': 'Karachi',
      'price': 2500,
      'image': 'https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?auto=format&fit=crop&w=800&q=60',
      'isTrending': true,
      'attendees': 1250,
      'rating': 4.8,
    },
    {
      'id': 'f2',
      'title': 'Tech Innovation Summit',
      'category': 'Tech',
      'date': 'Nov 20, 2025',
      'location': 'Lahore',
      'price': 1800,
      'image': 'https://images.unsplash.com/photo-1517077304055-6e89abbf09b0?auto=format&fit=crop&w=800&q=60',
      'isTrending': false,
      'attendees': 890,
      'rating': 4.9,
    },
    {
      'id': 'f3',
      'title': 'Food & Culture Festival',
      'category': 'Food',
      'date': 'Jan 10, 2026',
      'location': 'Islamabad',
      'price': 800,
      'image': 'https://images.unsplash.com/photo-1414235077428-338989a2e8c0?auto=format&fit=crop&w=800&q=60',
      'isTrending': true,
      'attendees': 650,
      'rating': 4.6,
    },
  ];

  // Trending Events
  final List<Map<String, dynamic>> trendingEvents = [
    {
      'id': 't1',
      'title': 'Flutter Pakistan Meetup',
      'category': 'Tech',
      'date': 'Nov 25, 2025',
      'location': 'Lahore',
      'price': 500,
      'image': 'https://images.unsplash.com/photo-1515187029135-18ee286d815b?auto=format&fit=crop&w=800&q=60',
      'attendees': 320,
      'isFree': false,
    },
    {
      'id': 't2',
      'title': 'Digital Art Workshop',
      'category': 'Art',
      'date': 'Dec 5, 2025',
      'location': 'Faisalabad',
      'price': 0,
      'image': 'https://images.unsplash.com/photo-1578662996442-48f60103fc96?auto=format&fit=crop&w=800&q=60',
      'attendees': 150,
      'isFree': true,
    },
    {
      'id': 't3',
      'title': 'Cricket Tournament',
      'category': 'Sports',
      'date': 'Jan 15, 2026',
      'location': 'Karachi',
      'price': 1200,
      'image': 'https://images.unsplash.com/photo-1540747913346-19e32dc3e97e?auto=format&fit=crop&w=800&q=60',
      'attendees': 2100,
      'isFree': false,
    },
  ];

  // Upcoming Events for User
  final List<Map<String, dynamic>> upcomingUserEvents = [
    {
      'id': 'u1',
      'title': 'Music Concert Tonight',
      'date': 'Today',
      'time': '8:00 PM',
      'location': 'Port Grand, Karachi',
      'status': 'confirmed',
      'image': 'https://images.unsplash.com/photo-1507874457470-272b3c8d8ee2?auto=format&fit=crop&w=800&q=60',
    },
    {
      'id': 'u2',
      'title': 'Tech Meetup',
      'date': 'Tomorrow',
      'time': '2:00 PM',
      'location': 'Arfa Tower, Lahore',
      'status': 'confirmed',
      'image': 'https://images.unsplash.com/photo-1518770660439-4636190af475?auto=format&fit=crop&w=800&q=60',
    },
    {
      'id': 'u3',
      'title': 'Food Festival',
      'date': 'Dec 20, 2025',
      'time': '5:00 PM',
      'location': 'F-9 Park, Islamabad',
      'status': 'pending',
      'image': 'https://images.unsplash.com/photo-1414235077428-338989a2e8c0?auto=format&fit=crop&w=800&q=60',
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _cardAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack));

    _cardAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _cardAnimationController, curve: Curves.elasticOut),
    );

    _animationController.forward();
    Future.delayed(const Duration(milliseconds: 300), () {
      _cardAnimationController.forward();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _cardAnimationController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.deepPurpleAccent,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black, Colors.deepPurple.shade900],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildHeader(),
                    _buildSearchBar(),
                    _buildQuickStats(),
                    _buildCategoryFilter(),
                    _buildFeaturedSection(),
                    _buildTrendingSection(),
                    _buildUpcomingSection(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getGreeting(),
                  style: GoogleFonts.montserrat(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  userData['name']!,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.location_on, color: Colors.deepPurpleAccent, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      selectedCity,
                      style: GoogleFonts.montserrat(color: Colors.white70, fontSize: 14),
                    ),
                    const SizedBox(width: 8),
                    InkWell(
                      onTap: _showCitySelector,
                      child: Icon(Icons.keyboard_arrow_down, color: Colors.white70, size: 16),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Row(
            children: [
              Stack(
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() => showNotificationBadge = false);
                      _showSnack("Notifications opened");
                    },
                    icon: Icon(Icons.notifications_outlined, color: Colors.white, size: 26),
                  ),
                  if (showNotificationBadge)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 8),
              InkWell(
                onTap: () => _showSnack("Profile opened"),
                child: CircleAvatar(
                  radius: 22,
                  backgroundImage: NetworkImage(userData['avatar']!),
                  backgroundColor: Colors.white12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.deepPurple.shade700.withOpacity(0.3), Colors.black54],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white24, width: 1),
      ),
      child: TextField(
        controller: _searchController,
        style: GoogleFonts.montserrat(color: Colors.white),
        decoration: InputDecoration(
          hintText: "Search events, venues, categories...",
          hintStyle: GoogleFonts.montserrat(color: Colors.white54),
          prefixIcon: Icon(Icons.search, color: Colors.deepPurpleAccent),
          suffixIcon: IconButton(
            icon: Icon(Icons.tune, color: Colors.white70),
            onPressed: () => _showSnack("Filters opened"),
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
        onSubmitted: (value) {
          if (value.isNotEmpty) {
            _showSnack("Searching for: $value");
          }
        },
      ),
    );
  }

  Widget _buildQuickStats() {
    return ScaleTransition(
      scale: _cardAnimation,
      child: Container(
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple.shade700.withOpacity(0.4), Colors.black87],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: Colors.black54, blurRadius: 8, offset: Offset(0, 4))
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Your Dashboard",
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _buildStatItem("Upcoming", "${quickStats['upcomingEvents']}", Icons.schedule, Colors.orange)),
                Expanded(child: _buildStatItem("This Week", "${quickStats['thisWeekEvents']}", Icons.event, Colors.blue)),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _buildStatItem("Favorites", "${quickStats['favoriteEvents']}", Icons.favorite, Colors.red)),
                Expanded(child: _buildStatItem("Completed", "${quickStats['completedEvents']}", Icons.check_circle, Colors.green)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: GoogleFonts.montserrat(color: Colors.white70, fontSize: 11),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return Container(
      height: 100,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = selectedCategoryIndex == index;

          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.symmetric(horizontal: 4),
            child: InkWell(
              onTap: () {
                setState(() => selectedCategoryIndex = index);
                _showSnack("${category['name']} events selected");
              },
              child: Container(
                width: 80,
                decoration: BoxDecoration(
                  gradient: isSelected
                      ? LinearGradient(
                    colors: [category['color'].withOpacity(0.3), Colors.black87],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                      : LinearGradient(
                    colors: [Colors.white12, Colors.black54],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected ? category['color'] : Colors.white24,
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      category['icon'],
                      color: isSelected ? category['color'] : Colors.white70,
                      size: 24,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      category['name'],
                      style: GoogleFonts.montserrat(
                        color: isSelected ? Colors.white : Colors.white70,
                        fontSize: 12,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFeaturedSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Featured Events 🔥",
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextButton(
                onPressed: () => _showSnack("View all featured events"),
                child: Text(
                  "View All",
                  style: GoogleFonts.montserrat(color: Colors.deepPurpleAccent),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 280,
          child: PageView.builder(
            itemCount: featuredEvents.length,
            padEnds: false,
            controller: PageController(viewportFraction: 0.85),
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                child: _buildFeaturedCard(featuredEvents[index]),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFeaturedCard(Map<String, dynamic> event) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [Colors.deepPurple.shade700.withOpacity(0.4), Colors.black87],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(color: Colors.black54, blurRadius: 12, offset: Offset(0, 6))
        ],
      ),
      child: InkWell(
        onTap: () => _showSnack("${event['title']} selected"),
        borderRadius: BorderRadius.circular(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  child: Image.network(
                    event['image'],
                    height: 160,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      height: 160,
                      color: Colors.white12,
                      child: const Icon(Icons.event, color: Colors.white30, size: 50),
                    ),
                  ),
                ),
                if (event['isTrending'])
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        "TRENDING",
                        style: GoogleFonts.montserrat(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Icon(Icons.favorite_border, color: Colors.white, size: 20),
                      onPressed: () => _showSnack("Added to favorites"),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event['title'],
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.calendar_today, color: Colors.white54, size: 14),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            "${event['date']} • ${event['location']}",
                            style: GoogleFonts.montserrat(color: Colors.white70, fontSize: 12),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Rs. ${event['price']}",
                          style: GoogleFonts.poppins(
                            color: Colors.amber,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: [
                            Icon(Icons.star, color: Colors.amber, size: 16),
                            const SizedBox(width: 4),
                            Text(
                              "${event['rating']}",
                              style: GoogleFonts.montserrat(color: Colors.white70, fontSize: 12),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrendingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Trending Near You 📍",
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextButton(
                onPressed: () => _showSnack("View all trending events"),
                child: Text(
                  "See More",
                  style: GoogleFonts.montserrat(color: Colors.deepPurpleAccent),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: trendingEvents.length,
            itemBuilder: (context, index) {
              return Container(
                width: 160,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                child: _buildTrendingCard(trendingEvents[index]),
              );
            },
          ),
        ),
      ],
    );
  }
  Widget _buildTrendingCard(Map<String, dynamic> event) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [Colors.black87, Colors.deepPurple.shade800.withOpacity(0.3)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(color: Colors.black54, blurRadius: 6, offset: Offset(0, 3))
        ],
      ),
      child: InkWell(
        onTap: () => _showSnack("${event['title']} selected"),
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  child: Image.network(
                    event['image'],
                    height: 100,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      height: 100,
                      color: Colors.white12,
                      child: const Icon(Icons.event, color: Colors.white30),
                    ),
                  ),
                ),
                if (event['isFree'])
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        "FREE",
                        style: GoogleFonts.montserrat(
                          color: Colors.white,
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event['title'],
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "${event['date']} • ${event['location']}",
                      style: GoogleFonts.montserrat(color: Colors.white70, fontSize: 10),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          event['isFree'] ? "FREE" : "Rs. ${event['price']}",
                          style: GoogleFonts.poppins(
                            color: event['isFree'] ? Colors.green : Colors.amber,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "${event['attendees']}+",
                          style: GoogleFonts.montserrat(color: Colors.white54, fontSize: 10),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildUpcomingSection() {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.deepPurple.shade700.withOpacity(0.3), Colors.black87],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black54, blurRadius: 8, offset: Offset(0, 4))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Your Upcoming Events 📅",
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextButton(
                  onPressed: () => _showSnack("View all upcoming events"),
                  child: Text(
                    "View All",
                    style: GoogleFonts.montserrat(color: Colors.deepPurpleAccent),
                  ),
                ),
              ],
            ),
          ),
          ...upcomingUserEvents.take(3).map((event) => _buildUpcomingEventItem(event)),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
  Widget _buildUpcomingEventItem(Map<String, dynamic> event) {
    final statusColor = event['status'] == 'confirmed' ? Colors.green : Colors.orange;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white12, width: 1),
      ),
      child: InkWell(
        onTap: () => _showSnack("${event['title']} details"),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                event['image'],
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 60,
                  height: 60,
                  color: Colors.white12,
                  child: const Icon(Icons.event, color: Colors.white30),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event['title'],
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${event['date']} • ${event['time']}",
                    style: GoogleFonts.montserrat(color: Colors.white70, fontSize: 12),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.location_on, color: Colors.white54, size: 12),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          event['location'],
                          style: GoogleFonts.montserrat(color: Colors.white54, fontSize: 11),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: statusColor, width: 1),
                  ),
                  child: Text(
                    event['status'].toUpperCase(),
                    style: GoogleFonts.montserrat(
                      color: statusColor,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                IconButton(
                  icon: Icon(Icons.more_vert, color: Colors.white54, size: 18),
                  onPressed: () => _showEventOptions(event),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return "Good Morning";
    } else if (hour < 17) {
      return "Good Afternoon";
    } else {
      return "Good Evening";
    }
  }
  void _showCitySelector() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey[900],
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
                "Select Your City",
                style: GoogleFonts.poppins(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 20),
              ...cities.map((city) => ListTile(
                leading: Icon(Icons.location_on, color: Colors.deepPurpleAccent),
                title: Text(city, style: GoogleFonts.montserrat(color: Colors.white)),
                trailing: selectedCity == city ? Icon(Icons.check, color: Colors.green) : null,
                onTap: () {
                  setState(() => selectedCity = city);
                  Navigator.pop(context);
                  _showSnack("Location changed to $city");
                },
              )),
            ],
          ),
        );
      },
    );
  }
  void _showEventOptions(Map<String, dynamic> event) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey[900],
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
                event['title'],
                style: GoogleFonts.poppins(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: Icon(Icons.info_outline, color: Colors.blue),
                title: Text("Event Details", style: GoogleFonts.montserrat(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  _showSnack("Event details opened");
                },
              ),
              ListTile(
                leading: Icon(Icons.directions, color: Colors.green),
                title: Text("Get Directions", style: GoogleFonts.montserrat(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  _showSnack("Opening directions");
                },
              ),
              ListTile(
                leading: Icon(Icons.calendar_today, color: Colors.orange),
                title: Text("Add to Calendar", style: GoogleFonts.montserrat(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  _showSnack("Added to calendar");
                },
              ),
              ListTile(
                leading: Icon(Icons.share, color: Colors.purple),
                title: Text("Share Event", style: GoogleFonts.montserrat(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  _showSnack("Sharing event");
                },
              ),
              if (event['status'] == 'confirmed')
                ListTile(
                  leading: Icon(Icons.cancel_outlined, color: Colors.red),
                  title: Text("Cancel Booking", style: GoogleFonts.montserrat(color: Colors.red)),
                  onTap: () {
                    Navigator.pop(context);
                    _showCancelDialog(event);
                  },
                ),
            ],
          ),
        );
      },
    );
  }
  void _showCancelDialog(Map<String, dynamic> event) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text("Cancel Booking", style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600)),
        content: Text(
          "Are you sure you want to cancel your booking for ${event['title']}?",
          style: GoogleFonts.montserrat(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Keep Booking", style: TextStyle(color: Colors.white70)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              setState(() {
                upcomingUserEvents.removeWhere((e) => e['id'] == event['id']);
                quickStats['upcomingEvents'] = (quickStats['upcomingEvents'] as int) - 1;
              });
              Navigator.pop(context);
              _showSnack("Booking cancelled successfully");
            },
            child: Text("Cancel Booking", style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}