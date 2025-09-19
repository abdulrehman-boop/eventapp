import 'package:eventify/authentication/dashboard.dart';
import 'package:eventify/profile.dart';
import 'package:eventify/state_management/app_state.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'My cartpage.dart';
import 'Settings.dart';
import 'favouritepage.dart';
class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final AppState appState = AppState();

  final List<Widget> _pages = [
    HomeContent(),
    Center(child: Text("My Events", style: TextStyle(color: Colors.white))),
    Center(child: Text("Favorites", style: TextStyle(color: Colors.white))),
    Center(child: Text("Profile", style: TextStyle(color: Colors.white))),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildDrawer(),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black, Colors.deepPurple.shade900],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: _pages[_currentIndex],
      ),
      bottomNavigationBar: ListenableBuilder(
        listenable: appState,
        builder: (context, child) {
          return BottomNavigationBar(
            backgroundColor: Colors.black87,
            currentIndex: _currentIndex,
            selectedItemColor: Colors.deepPurpleAccent,
            unselectedItemColor: Colors.white70,
            type: BottomNavigationBarType.fixed,
            onTap: (index) {
              if (index == 1) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CartPage()),
                );
              } else if (index == 2) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FavoritesPage()),
                );
              } else if (index == 3) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePage()),
                );
              } else {
                setState(() => _currentIndex = index);
              }
            },
            items: [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
              BottomNavigationBarItem(
                icon: Stack(
                  children: [
                    Icon(Icons.event),
                    if (appState.cartItemCount > 0)
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          padding: EdgeInsets.all(1),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          constraints: BoxConstraints(minWidth: 12, minHeight: 12),
                          child: Text(
                            '${appState.cartItemCount}',
                            style: TextStyle(color: Colors.white, fontSize: 8),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                ),
                label: "My Events",
              ),
              BottomNavigationBarItem(
                icon: Stack(
                  children: [
                    Icon(Icons.favorite),
                    if (appState.favoriteCount > 0)
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          padding: EdgeInsets.all(1),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          constraints: BoxConstraints(minWidth: 12, minHeight: 12),
                          child: Text(
                            '${appState.favoriteCount}',
                            style: TextStyle(color: Colors.white, fontSize: 8),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                ),
                label: "Favorites",
              ),
              BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
            ],
          );
        },
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: Container(
        color: Colors.black87,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.deepPurple.shade800, Colors.black],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(
                      "https://i.pravatar.cc/150?img=12",
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Abdulrehman",
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    "Flutter Developer",
                    style: GoogleFonts.montserrat(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.dashboard, color: Colors.white),
              title: Text("Dashboard", style: GoogleFonts.montserrat(color: Colors.white)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DashboardPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.settings, color: Colors.white),
              title: Text("Settings", style: GoogleFonts.montserrat(color: Colors.white)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.info, color: Colors.white),
              title: Text("About", style: GoogleFonts.montserrat(color: Colors.white)),
              onTap: () {},
            ),
            Divider(color: Colors.white54),
            ListTile(
              leading: Icon(Icons.logout, color: Colors.red),
              title: Text("Logout", style: GoogleFonts.montserrat(color: Colors.red)),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
class HomeContent extends StatefulWidget {
  @override
  _HomeContentState createState() => _HomeContentState();
}
class _HomeContentState extends State<HomeContent> {
  List<Map<String, dynamic>> events = [];
  bool isLoading = false;
  final AppState appState = AppState();
  @override
  void initState() {
    super.initState();
    _loadSampleEvents();
  }
  void _loadSampleEvents() {
    events = [
      {
        'id': '1',
        'title': 'Tech Conference 2025',
        'description': 'A tech conference for developers',
        'date': 'March 15, 2025',
        'location': 'Convention Center',
        'price': 2500.0,
        'category': 'Technology',
        'imageUrl': 'https://images.unsplash.com/photo-1540575467063-178a50c2df87?w=400',
      },
      {
        'id': '2',
        'title': 'Music Festival',
        'description': 'Amazing music festival with top artists',
        'date': 'April 20, 2025',
        'location': 'City Park',
        'price': 1500.0,
        'category': 'Music',
        'imageUrl': 'https://images.unsplash.com/photo-1514525253161-7a46d19cd819?w=400',
      },
      {
        'id': '3',
        'title': 'Art Exhibition',
        'description': 'Contemporary art exhibition',
        'date': 'May 5, 2025',
        'location': 'Art Gallery',
        'price': 500.0,
        'category': 'Art',
        'imageUrl': 'https://images.unsplash.com/photo-1578321272176-b7bbc0679853?w=400',
      },
      {
        'id': '4',
        'title': 'Food Festival',
        'description': 'Taste amazing local and international cuisines',
        'date': 'June 10, 2025',
        'location': 'Central Square',
        'price': 800.0,
        'category': 'Food',
        'imageUrl': 'https://images.unsplash.com/photo-1414235077428-338989a2e8c0?w=400',
      },
      {
        'id': '5',
        'title': 'Sports Championship',
        'description': 'Annual sports championship event',
        'date': 'July 25, 2025',
        'location': 'Stadium',
        'price': 1200.0,
        'category': 'Sports',
        'imageUrl': 'https://images.unsplash.com/photo-1461896836934-ffe607ba8211?w=400',
      },
    ];
    setState(() {
      isLoading = false;
    });
  }
  void _refreshEvents() {
    setState(() {
      isLoading = true;
    });
    Future.delayed(Duration(seconds: 1), () {
      _loadSampleEvents();
    });
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
    return ListenableBuilder(
      listenable: appState,
      builder: (context, child) {
        return Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.deepPurple.shade800, Colors.black],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.6),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Builder(
                    builder: (context) => IconButton(
                      icon: Icon(Icons.menu, color: Colors.white),
                      onPressed: () => Scaffold.of(context).openDrawer(),
                    ),
                  ),
                  Text(
                    "Eventify",
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.2,
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.refresh, color: Colors.white),
                        onPressed: _refreshEvents,
                      ),
                      Icon(Icons.notifications_none, color: Colors.white, size: 28),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.deepPurple.shade700.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: TextField(
                        style: GoogleFonts.montserrat(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: "Search events...",
                          hintStyle: GoogleFonts.montserrat(color: Colors.white70),
                          prefixIcon: Icon(Icons.search, color: Colors.white),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 15),
                        ),
                      ),
                    ),
                    SizedBox(height: 25),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Upcoming Events",
                          style: GoogleFonts.poppins(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          "${events.length} events",
                          style: GoogleFonts.montserrat(
                            color: Colors.deepPurpleAccent,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
                    Container(
                      height: 200,
                      child: isLoading
                          ? Center(
                        child: CircularProgressIndicator(
                          color: Colors.deepPurpleAccent,
                        ),
                      )
                          : events.isEmpty
                          ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.event_busy,
                                color: Colors.white70, size: 50),
                            SizedBox(height: 10),
                            Text(
                              "No events found",
                              style: GoogleFonts.montserrat(
                                  color: Colors.white70),
                            ),
                          ],
                        ),
                      )
                          : ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: events.length > 5 ? 5 : events.length,
                        itemBuilder: (context, index) {
                          final event = events[index];
                          return _eventCard(event);
                        },
                      ),
                    ),
                    SizedBox(height: 30),
                    Text(
                      "All Events",
                      style: GoogleFonts.poppins(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 15),
                    isLoading
                        ? Center(
                      child: CircularProgressIndicator(
                        color: Colors.deepPurpleAccent,
                      ),
                    )
                        : events.isEmpty
                        ? Center(
                      child: Text(
                        "No events available",
                        style: GoogleFonts.montserrat(
                            color: Colors.white70),
                      ),
                    )
                        : Column(
                      children: events.map((event) {
                        return _recommendCard(event);
                      }).toList(),
                    )
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _eventCard(Map<String, dynamic> event) {
    return Container(
      width: 160,
      margin: EdgeInsets.only(right: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.deepPurpleAccent.withOpacity(0.5),
            blurRadius: 8,
            offset: Offset(2, 4),
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            Image.network(
              event['imageUrl'],
              height: double.infinity,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey,
                  child: Icon(Icons.image, color: Colors.white, size: 50),
                );
              },
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.black.withOpacity(0.7), Colors.transparent],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
            ),
            // Favorite button
            Positioned(
              top: 8,
              right: 8,
              child: InkWell(
                onTap: () {
                  appState.toggleFavorite(event);
                  _showSnack(appState.isFavorite(event['id'])
                      ? "Added to favorites"
                      : "Removed from favorites");
                },
                child: Container(
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    appState.isFavorite(event['id']) ? Icons.favorite : Icons.favorite_border,
                    color: Colors.red,
                    size: 18,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.event, color: Colors.white, size: 38),
                  Spacer(),
                  Text(
                    event['title'],
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    event['date'],
                    style: GoogleFonts.montserrat(
                        color: Colors.white70, fontSize: 13),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _recommendCard(Map<String, dynamic> event) {
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 8,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Stack(
          children: [
            Image.network(
              event['imageUrl'],
              height: 120,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 120,
                  color: Colors.grey,
                  child: Icon(Icons.image, color: Colors.white, size: 50),
                );
              },
            ),
            Container(
              height: 120,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.black.withOpacity(0.7), Colors.transparent],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      appState.toggleFavorite(event);
                      _showSnack(appState.isFavorite(event['id'])
                          ? "Added to favorites"
                          : "Removed from favorites");
                    },
                    child: Container(
                      padding: EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        appState.isFavorite(event['id']) ? Icons.favorite : Icons.favorite_border,
                        color: Colors.red,
                        size: 18,
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  InkWell(
                    onTap: () {
                      print('Adding to cart: ${event['title']}'); // Debug print
                      appState.addToCart(event);
                      _showSnack("${event['title']} added to cart");
                    },
                    child: Container(
                      padding: EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.deepPurpleAccent,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.add_shopping_cart,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(18),
              child: Row(
                children: [
                  Icon(Icons.star, color: Colors.amber, size: 40),
                  SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          event['title'],
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          "${event['location']} • ₹${event['price'].toInt()}",
                          style: GoogleFonts.montserrat(
                              color: Colors.white70, fontSize: 14),
                        ),
                        Text(
                          "${event['date']} • ${event['category']}",
                          style: GoogleFonts.montserrat(
                              color: Colors.deepPurpleAccent, fontSize: 12),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}