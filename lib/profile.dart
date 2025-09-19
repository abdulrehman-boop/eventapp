import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}
class _ProfilePageState extends State<ProfilePage> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  bool notificationsEnabled = true;
  bool locationEnabled = true;
  bool marketingEmails = false;
  String selectedLanguage = 'English';
  String selectedCurrency = 'PKR';
  String selectedTheme = 'Dark';
  final List<String> languages = ['English', 'Urdu', 'Punjabi'];
  final List<String> currencies = ['PKR', 'USD', 'EUR'];
  final List<String> themes = ['Dark', 'Light', 'Auto'];
  final Map<String, dynamic> userData = {
    'name': 'Ahmed Ali Khan',
    'email': 'ahmed.ali@example.com',
    'phone': '+92 300 1234567',
    'location': 'Faisalabad, Punjab',
    'joinDate': 'January 2024',
    'profileImage': 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?auto=format&fit=crop&w=400&q=60',
    'verified': true,
    'totalEvents': 24,
    'favoriteEvents': 12,
    'completedEvents': 18,
    'upcomingEvents': 6,
    'membershipLevel': 'Gold',
    'points': 2450,
  };
  final List<Map<String, dynamic>> recentActivity = [
    {
      'title': 'Attended Music Concert',
      'subtitle': 'Summer Music Festival 2025',
      'date': '2 days ago',
      'icon': Icons.music_note,
      'color': Colors.purple,
    },
    {
      'title': 'Added to Favorites',
      'subtitle': 'Flutter Pakistan Meetup',
      'date': '5 days ago',
      'icon': Icons.favorite,
      'color': Colors.red,
    },
    {
      'title': 'Purchased Ticket',
      'subtitle': 'Cricket Championship Final',
      'date': '1 week ago',
      'icon': Icons.shopping_cart,
      'color': Colors.green,
    },
    {
      'title': 'Profile Updated',
      'subtitle': 'Added profile picture',
      'date': '2 weeks ago',
      'icon': Icons.person,
      'color': Colors.blue,
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
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

  void _showEditProfileDialog() {
    final nameController = TextEditingController(text: userData['name']);
    final emailController = TextEditingController(text: userData['email']);
    final phoneController = TextEditingController(text: userData['phone']);
    final locationController = TextEditingController(text: userData['location']);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text("Edit Profile", style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTextField(nameController, "Full Name", Icons.person),
              const SizedBox(height: 12),
              _buildTextField(emailController, "Email", Icons.email),
              const SizedBox(height: 12),
              _buildTextField(phoneController, "Phone", Icons.phone),
              const SizedBox(height: 12),
              _buildTextField(locationController, "Location", Icons.location_on),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel", style: TextStyle(color: Colors.white70)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurpleAccent,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              setState(() {
                userData['name'] = nameController.text;
                userData['email'] = emailController.text;
                userData['phone'] = phoneController.text;
                userData['location'] = locationController.text;
              });
              Navigator.pop(context);
              _showSnack("Profile updated successfully!");
            },
            child: Text("Save", style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon) {
    return TextField(
      controller: controller,
      style: GoogleFonts.montserrat(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.montserrat(color: Colors.white70),
        prefixIcon: Icon(icon, color: Colors.deepPurpleAccent),
        filled: true,
        fillColor: Colors.deepPurple.shade800.withOpacity(0.3),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.deepPurpleAccent, width: 2),
        ),
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
                    _customAppBar(),
                    _profileHeader(),
                    _statsSection(),
                    _membershipSection(),
                    _menuSection(),
                    _recentActivitySection(),
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
                "My Profile 👤",
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          InkWell(
            onTap: _showEditProfileDialog,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white12,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.edit, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }

  Widget _profileHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.deepPurpleAccent, width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.deepPurpleAccent.withOpacity(0.3),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(userData['profileImage']),
                  backgroundColor: Colors.white12,
                ),
              ),
              if (userData['verified'])
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.black, width: 2),
                    ),
                    child: Icon(Icons.verified, color: Colors.white, size: 16),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            userData['name'],
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            userData['email'],
            style: GoogleFonts.montserrat(color: Colors.white70, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.location_on, color: Colors.white54, size: 16),
              const SizedBox(width: 4),
              Text(
                userData['location'],
                style: GoogleFonts.montserrat(color: Colors.white54, fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            "Member since ${userData['joinDate']}",
            style: GoogleFonts.montserrat(color: Colors.white54, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _statsSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
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
            "Activity Stats",
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _statItem("Total Events", "${userData['totalEvents']}", Icons.event, Colors.blue)),
              Expanded(child: _statItem("Completed", "${userData['completedEvents']}", Icons.check_circle, Colors.green)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _statItem("Favorites", "${userData['favoriteEvents']}", Icons.favorite, Colors.red)),
              Expanded(child: _statItem("Upcoming", "${userData['upcomingEvents']}", Icons.schedule, Colors.orange)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statItem(String label, String value, IconData icon, Color color) {
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
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: GoogleFonts.montserrat(color: Colors.white70, fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _membershipSection() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.amber.shade700.withOpacity(0.3), Colors.orange.shade900.withOpacity(0.3)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.amber.withOpacity(0.5), width: 1),
        boxShadow: [
          BoxShadow(color: Colors.black54, blurRadius: 8, offset: Offset(0, 4))
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.amber,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.stars, color: Colors.black87, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${userData['membershipLevel']} Member",
                  style: GoogleFonts.poppins(
                    color: Colors.amber,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "${userData['points']} points earned",
                  style: GoogleFonts.montserrat(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () => _showSnack("Coming soon!"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber,
              foregroundColor: Colors.black87,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
            child: Text("Upgrade", style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  Widget _menuSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
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
        children: [
          _buildMenuCategory("Account Settings", [
            _MenuItemData(Icons.person_outline, "Edit Profile", "Update your personal information", () => _showEditProfileDialog()),
            _MenuItemData(Icons.security, "Privacy & Security", "Manage your account security", () => _showSnack("Coming soon!")),
            _MenuItemData(Icons.payment, "Payment Methods", "Manage cards and payment options", () => _showSnack("Coming soon!")),
            _MenuItemData(Icons.location_on, "Address Book", "Manage your saved addresses", () => _showSnack("Coming soon!")),
          ]),
          const Divider(color: Colors.white12, height: 1),
          _buildMenuCategory("Preferences", [
            _MenuItemData(Icons.notifications_outlined, "Notifications", "Push notifications, emails", () => _showNotificationSettings()),
            _MenuItemData(Icons.language, "Language & Region", "Change app language and currency", () => _showLanguageSettings()),
            _MenuItemData(Icons.dark_mode, "Theme", "Dark, Light, or Auto", () => _showThemeSettings()),
          ]),
          const Divider(color: Colors.white12, height: 1),
          _buildMenuCategory("Support & More", [
            _MenuItemData(Icons.help_outline, "Help & Support", "FAQs, contact support", () => _showSnack("Coming soon!")),
            _MenuItemData(Icons.info_outline, "About", "App version and legal info", () => _showAboutDialog()),
            _MenuItemData(Icons.logout, "Sign Out", "Log out of your account", () => _showLogoutDialog(), isDestructive: true),
          ]),
        ],
      ),
    );
  }

  Widget _buildMenuCategory(String title, List<_MenuItemData> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
          child: Text(
            title,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        ...items.map((item) => _buildMenuItem(item)),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildMenuItem(_MenuItemData item) {
    return InkWell(
      onTap: item.onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Row(
          children: [
            Icon(
              item.icon,
              color: item.isDestructive ? Colors.red : Colors.white70,
              size: 22,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: GoogleFonts.poppins(
                      color: item.isDestructive ? Colors.red : Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (item.subtitle != null)
                    Text(
                      item.subtitle!,
                      style: GoogleFonts.montserrat(
                        color: Colors.white54,
                        fontSize: 12,
                      ),
                    ),
                ],
              ),
            ),
            if (!item.isDestructive)
              Icon(Icons.chevron_right, color: Colors.white54, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _recentActivitySection() {
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
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Recent Activity",
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextButton(
                  onPressed: () => _showSnack("Coming soon!"),
                  child: Text(
                    "View All",
                    style: GoogleFonts.montserrat(color: Colors.deepPurpleAccent, fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
          ...recentActivity.take(3).map((activity) => _buildActivityItem(activity)),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildActivityItem(Map<String, dynamic> activity) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: (activity['color'] as Color).withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              activity['icon'],
              color: activity['color'],
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity['title'],
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  activity['subtitle'],
                  style: GoogleFonts.montserrat(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Text(
            activity['date'],
            style: GoogleFonts.montserrat(
              color: Colors.white54,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  void _showNotificationSettings() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey[900],
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Notification Settings",
                style: GoogleFonts.poppins(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 20),
              _buildSwitchTile("Push Notifications", "Get notified about events", notificationsEnabled, (value) {
                setModalState(() => notificationsEnabled = value);
                setState(() => notificationsEnabled = value);
              }),
              _buildSwitchTile("Location Services", "Find events near you", locationEnabled, (value) {
                setModalState(() => locationEnabled = value);
                setState(() => locationEnabled = value);
              }),
              _buildSwitchTile("Marketing Emails", "Receive promotional emails", marketingEmails, (value) {
                setModalState(() => marketingEmails = value);
                setState(() => marketingEmails = value);
              }),
            ],
          ),
        ),
      ),
    );
  }

  void _showLanguageSettings() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey[900],
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Language & Currency",
              style: GoogleFonts.poppins(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),
            Text("Language", style: GoogleFonts.montserrat(color: Colors.white70, fontSize: 14)),
            ...languages.map((lang) => RadioListTile<String>(
              title: Text(lang, style: GoogleFonts.montserrat(color: Colors.white)),
              value: lang,
              groupValue: selectedLanguage,
              onChanged: (value) {
                setState(() => selectedLanguage = value!);
                Navigator.pop(context);
                _showSnack("Language changed to $value");
              },
              activeColor: Colors.deepPurpleAccent,
            )),
            const Divider(color: Colors.white24),
            Text("Currency", style: GoogleFonts.montserrat(color: Colors.white70, fontSize: 14)),
            ...currencies.map((currency) => RadioListTile<String>(
              title: Text(currency, style: GoogleFonts.montserrat(color: Colors.white)),
              value: currency,
              groupValue: selectedCurrency,
              onChanged: (value) {
                setState(() => selectedCurrency = value!);
                Navigator.pop(context);
                _showSnack("Currency changed to $value");
              },
              activeColor: Colors.deepPurpleAccent,
            )),
          ],
        ),
      ),
    );
  }

  void _showThemeSettings() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey[900],
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Theme Settings",
              style: GoogleFonts.poppins(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),
            ...themes.map((theme) => RadioListTile<String>(
              title: Text(theme, style: GoogleFonts.montserrat(color: Colors.white)),
              subtitle: Text(
                theme == 'Dark' ? 'Always use dark theme' :
                theme == 'Light' ? 'Always use light theme' : 'Follow system setting',
                style: GoogleFonts.montserrat(color: Colors.white54, fontSize: 12),
              ),
              value: theme,
              groupValue: selectedTheme,
              onChanged: (value) {
                setState(() => selectedTheme = value!);
                Navigator.pop(context);
                _showSnack("Theme changed to $value");
              },
              activeColor: Colors.deepPurpleAccent,
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchTile(String title, String subtitle, bool value, Function(bool) onChanged) {
    return SwitchListTile(
      title: Text(title, style: GoogleFonts.poppins(color: Colors.white)),
      subtitle: Text(subtitle, style: GoogleFonts.montserrat(color: Colors.white70, fontSize: 12)),
      value: value,
      onChanged: onChanged,
      activeColor: Colors.deepPurpleAccent,
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text("About EventHub", style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Version: 1.0.0", style: GoogleFonts.montserrat(color: Colors.white70)),
            const SizedBox(height: 8),
            Text("Build: 2025.08.28", style: GoogleFonts.montserrat(color: Colors.white70)),
            const SizedBox(height: 16),
            Text("EventHub - Your gateway to amazing events in Pakistan",
                style: GoogleFonts.montserrat(color: Colors.white54, fontSize: 14)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Close", style: TextStyle(color: Colors.deepPurpleAccent)),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text("Sign Out", style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600)),
        content: Text(
          "Are you sure you want to sign out of your account?",
          style: GoogleFonts.montserrat(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel", style: TextStyle(color: Colors.white70)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
              _showSnack("Signed out successfully");
              // In real app: clear user session and navigate to login
            },
            child: Text("Sign Out", style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}

class _MenuItemData {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;
  final bool isDestructive;
  _MenuItemData(this.icon, this.title, this.subtitle, this.onTap, {this.isDestructive = false});
}