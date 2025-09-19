import 'package:eventify/state_management/app_state.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
class FavoritesPage extends StatefulWidget {
  const FavoritesPage({Key? key}) : super(key: key);
  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}
class _FavoritesPageState extends State<FavoritesPage> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  final AppState appState = AppState();
  String selectedCategory = 'All';
  String selectedLocation = 'All';
  String sortBy = 'Date';
  final List<String> categories = ['All', 'Music', 'Tech', 'Sports', 'Art', 'Food', 'Gaming', 'Film'];
  final List<String> locations = ['All', 'Karachi', 'Lahore', 'Islamabad', 'Faisalabad', 'Multan'];
  final List<String> sortOptions = ['Date', 'Price', 'Name', 'Recently Added'];
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
  List<Map<String, dynamic>> get filteredEvents {
    List<Map<String, dynamic>> filtered = List.from(appState.favoriteEvents);

    if (selectedCategory != 'All') {
      filtered = filtered.where((event) => event['category'] == selectedCategory).toList();
    }
    if (selectedLocation != 'All') {
      filtered = filtered.where((event) => event['location'] == selectedLocation).toList();
    }
    switch (sortBy) {
      case 'Price':
        filtered.sort((a, b) => (a['price'] as int).compareTo(b['price'] as int));
        break;
      case 'Name':
        filtered.sort((a, b) => a['title'].compareTo(b['title']));
        break;
      case 'Recently Added':
        filtered.sort((a, b) => b['addedDate'].compareTo(a['addedDate']));
        break;
      default: // Date
        filtered.sort((a, b) => a['date'].compareTo(b['date']));
    }
    return filtered;
  }
  void _removeFromFavorites(String eventId) {
    appState.removeFromFavorites(eventId);
    _showSnack("Removed from favorites");
  }
  void _addToCart(Map<String, dynamic> event) {
    appState.addToCart(event);
    _showSnack("${event['title']} added to cart");
  }
  void _showEventDetails(Map<String, dynamic> event) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _EventDetailsSheet(event: event, appState: appState),
    );
  }
  void _showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.deepPurpleAccent,
          behavior: SnackBarBehavior.floating,
        )
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
          child: ListenableBuilder(
            listenable: appState,
            builder: (context, child) {
              return Column(
                children: [
                  _customAppBar(),
                  _filterSection(),
                  Expanded(
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: filteredEvents.isEmpty ? _emptyFavoritesView() : _eventsList(),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _customAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 14.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.deepPurple.shade800, Colors.black],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.6), blurRadius: 8, offset: Offset(0, 4))
        ],
      ),
      child: Row(
        children: [
          InkWell(
            onTap: () => Navigator.maybePop(context),
            child: Icon(Icons.arrow_back, color: Colors.white),
          ),
          Expanded(
            child: Center(
              child: Text(
                "My Favorites ❤️",
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          InkWell(
            onTap: _showFilterBottomSheet,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white12,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.tune, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }

  Widget _filterSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _filterChip('Category', selectedCategory, categories),
            const SizedBox(width: 8),
            _filterChip('Location', selectedLocation, locations),
            const SizedBox(width: 8),
            _filterChip('Sort by', sortBy, sortOptions),
            const SizedBox(width: 8),
            if (selectedCategory != 'All' || selectedLocation != 'All')
              InkWell(
                onTap: () {
                  setState(() {
                    selectedCategory = 'All';
                    selectedLocation = 'All';
                    sortBy = 'Date';
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.red.shade700,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.clear, color: Colors.white, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        "Clear",
                        style: GoogleFonts.montserrat(color: Colors.white, fontSize: 12),
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

  Widget _filterChip(String label, String selected, List<String> options) {
    return InkWell(
      onTap: () => _showFilterOptions(label, selected, options),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple.shade700.withOpacity(0.6), Colors.black54],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white24, width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "$label: $selected",
              style: GoogleFonts.montserrat(color: Colors.white, fontSize: 12),
            ),
            const SizedBox(width: 4),
            Icon(Icons.keyboard_arrow_down, color: Colors.white70, size: 16),
          ],
        ),
      ),
    );
  }

  Widget _emptyFavoritesView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite_border, size: 80, color: Colors.white24),
          const SizedBox(height: 16),
          Text(
            "No favorites yet",
            style: GoogleFonts.poppins(color: Colors.white70, fontSize: 20),
          ),
          const SizedBox(height: 8),
          Text(
            "Start adding events to your favorites\nto see them here!",
            textAlign: TextAlign.center,
            style: GoogleFonts.montserrat(color: Colors.white54, fontSize: 14),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.explore),
            label: Text("Explore Events"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurpleAccent,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _eventsList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              "${filteredEvents.length} event${filteredEvents.length != 1 ? 's' : ''} found",
              style: GoogleFonts.montserrat(color: Colors.white70, fontSize: 14),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredEvents.length,
              itemBuilder: (context, index) {
                final event = filteredEvents[index];
                return _EventCard(
                  event: event,
                  onRemove: () => _removeFromFavorites(event['id']),
                  onAddToCart: () => _addToCart(event),
                  onTap: () => _showEventDetails(event),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterOptions(String label, String selected, List<String> options) {
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
                "Select $label",
                style: GoogleFonts.poppins(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),
              ...options.map((option) => ListTile(
                title: Text(option, style: GoogleFonts.montserrat(color: Colors.white)),
                trailing: selected == option ? Icon(Icons.check, color: Colors.deepPurpleAccent) : null,
                onTap: () {
                  setState(() {
                    switch (label) {
                      case 'Category':
                        selectedCategory = option;
                        break;
                      case 'Location':
                        selectedLocation = option;
                        break;
                      case 'Sort by':
                        sortBy = option;
                        break;
                    }
                  });
                  Navigator.pop(context);
                },
              )),
            ],
          ),
        );
      },
    );
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey[900],
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
                      Text(
                        "Filter & Sort",
                        style: GoogleFonts.poppins(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            selectedCategory = 'All';
                            selectedLocation = 'All';
                            sortBy = 'Date';
                          });
                          Navigator.pop(context);
                        },
                        child: Text("Reset", style: TextStyle(color: Colors.red.shade400)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text("Category", style: GoogleFonts.montserrat(color: Colors.white70, fontSize: 14)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: categories.map((category) => FilterChip(
                      label: Text(category, style: GoogleFonts.montserrat(fontSize: 12)),
                      selected: selectedCategory == category,
                      onSelected: (selected) {
                        setModalState(() => selectedCategory = category);
                        setState(() => selectedCategory = category);
                      },
                      selectedColor: Colors.deepPurpleAccent,
                      backgroundColor: Colors.white12,
                      labelStyle: TextStyle(color: Colors.white),
                    )).toList(),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurpleAccent,
                      minimumSize: const Size(double.infinity, 45),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: Text("Apply Filters", style: GoogleFonts.poppins(color: Colors.white)),
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

class _EventCard extends StatelessWidget {
  final Map<String, dynamic> event;
  final VoidCallback onRemove;
  final VoidCallback onAddToCart;
  final VoidCallback onTap;
  const _EventCard({
    required this.event,
    required this.onRemove,
    required this.onAddToCart,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [Colors.deepPurple.shade700.withOpacity(0.4), Colors.black87],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(color: Colors.black54, blurRadius: 8, offset: Offset(0, 4))
        ],
      ),
      child: InkWell(
        onTap: onTap,
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
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      height: 180,
                      color: Colors.white12,
                      child: const Icon(Icons.event, color: Colors.white30, size: 50),
                    ),
                  ),
                ),
                if (event['isFeatured'])
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        "FEATURED",
                        style: GoogleFonts.montserrat(
                          color: Colors.black87,
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
                      icon: Icon(Icons.favorite, color: Colors.red, size: 20),
                      onPressed: onRemove,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.deepPurpleAccent.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.deepPurpleAccent, width: 1),
                        ),
                        child: Text(
                          event['category'],
                          style: GoogleFonts.montserrat(
                            color: Colors.deepPurpleAccent,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.amber, size: 14),
                          const SizedBox(width: 4),
                          Text(
                            "${event['rating']}",
                            style: GoogleFonts.montserrat(color: Colors.white70, fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    event['title'],
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 18,
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
                      Text(
                        "${event['date']} • ${event['time']}",
                        style: GoogleFonts.montserrat(color: Colors.white70, fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.location_on, color: Colors.white54, size: 14),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          "${event['venue']}, ${event['location']}",
                          style: GoogleFonts.montserrat(color: Colors.white70, fontSize: 12),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.people, color: Colors.white54, size: 14),
                      const SizedBox(width: 6),
                      Text(
                        "${event['attendees']} attending",
                        style: GoogleFonts.montserrat(color: Colors.white70, fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Text(
                        "Rs. ${event['price']}",
                        style: GoogleFonts.poppins(
                          color: Colors.amber,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const Spacer(),
                      ElevatedButton.icon(
                        onPressed: onAddToCart,
                        icon: Icon(Icons.shopping_cart_outlined, size: 16),
                        label: Text("Add to Cart"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurpleAccent,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        ),
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
}

class _EventDetailsSheet extends StatelessWidget {
  final Map<String, dynamic> event;
  final AppState appState;
  const _EventDetailsSheet({required this.event, required this.appState});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.black, Colors.deepPurple.shade900],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white54,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      event['image'],
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    event['title'],
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _detailRow(Icons.calendar_today, "${event['date']} • ${event['time']}"),
                  _detailRow(Icons.location_on, "${event['venue']}, ${event['location']}"),
                  _detailRow(Icons.people, "${event['attendees']} people attending"),
                  _detailRow(Icons.star, "${event['rating']} rating"),
                  const SizedBox(height: 16),
                  Text(
                    "Tags",
                    style: GoogleFonts.poppins(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: (event['tags'] as List<String>).map((tag) => Chip(
                      label: Text(tag, style: GoogleFonts.montserrat(fontSize: 12)),
                      backgroundColor: Colors.deepPurpleAccent.withOpacity(0.2),
                      labelStyle: const TextStyle(color: Colors.white),
                    )).toList(),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.8),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Price", style: GoogleFonts.montserrat(color: Colors.white70, fontSize: 12)),
                    Text("Rs. ${event['price']}", style: GoogleFonts.poppins(color: Colors.amber, fontSize: 20, fontWeight: FontWeight.bold)),
                  ],
                ),
                const Spacer(),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    appState.addToCart(event);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("${event['title']} added to cart"),
                        backgroundColor: Colors.deepPurpleAccent,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  icon: Icon(Icons.shopping_cart),
                  label: Text("Add to Cart"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurpleAccent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _detailRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, color: Colors.white54, size: 16),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.montserrat(color: Colors.white70, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}