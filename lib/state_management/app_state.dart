import 'package:flutter/foundation.dart';
class AppState extends ChangeNotifier {
  static final AppState _instance = AppState._internal();
  factory AppState() => _instance;
  AppState._internal();
  List<Map<String, dynamic>> _cartItems = [
    {
      "id": "c1",
      "title": "Music Concert Ticket",
      "date": "Dec 10, 2025",
      "location": "Karachi",
      "price": 1500,
      "quantity": 1,
      "image": "https://images.unsplash.com/photo-1507874457470-272b3c8d8ee2?auto=format&fit=crop&w=800&q=60"
    },
    {
      "id": "c2",
      "title": "Tech Meetup Pass",
      "date": "Jan 5, 2026",
      "location": "Lahore",
      "price": 1000,
      "quantity": 2,
      "image": "https://images.unsplash.com/photo-1518770660439-4636190af475?auto=format&fit=crop&w=800&q=60"
    },
  ];
  List<Map<String, dynamic>> _favoriteEvents = [
    {
      "id": "fav1",
      "title": "Summer Music Festival 2025",
      "category": "Music",
      "date": "Dec 15, 2025",
      "time": "7:00 PM",
      "location": "Karachi",
      "venue": "Port Grand",
      "price": 2500,
      "rating": 4.8,
      "attendees": 1250,
      "isFeatured": true,
      "addedDate": "2025-08-20",
      "image": "https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?auto=format&fit=crop&w=800&q=60",
      "tags": ["Live Music", "Outdoor", "Festival"]
    },
  ];
  List<Map<String, dynamic>> get cartItems => List.unmodifiable(_cartItems);
  List<Map<String, dynamic>> get favoriteEvents => List.unmodifiable(_favoriteEvents);
  int get cartItemCount => _cartItems.fold<int>(
      0,
          (sum, item) => sum + (item['quantity'] as int)
  );
  int get favoriteCount => _favoriteEvents.length;
  void addToCart(Map<String, dynamic> event) {
    final existingIndex = _cartItems.indexWhere((item) => item['id'] == event['id']);
    if (existingIndex >= 0) {
      _cartItems[existingIndex]['quantity'] =
          (_cartItems[existingIndex]['quantity'] as int) + 1;
      print('Updated quantity for ${event['title']} to ${_cartItems[existingIndex]['quantity']}');
    } else {
      final cartItem = {
        'id': event['id'],
        'title': event['title'],
        'date': event['date'],
        'location': event['location'],
        'price': _ensureIntPrice(event['price']),
        'quantity': 1,
        'image': event['imageUrl'] ?? event['image'] ?? 'https://via.placeholder.com/400',
      };
      _cartItems.add(cartItem);
      print('Added new item to cart: ${event['title']}');
    }
    print('Total cart items: ${_cartItems.length}, Total quantity: $cartItemCount');
    notifyListeners();
  }
  void removeFromCart(String eventId) {
    final removedItem = _cartItems.firstWhere(
          (item) => item['id'] == eventId,
      orElse: () => <String, dynamic>{},
    );
    _cartItems.removeWhere((item) => item['id'] == eventId);

    if (removedItem.isNotEmpty) {
      print('Removed ${removedItem['title']} from cart');
    }
    notifyListeners();
  }
  void updateCartItemQuantity(String eventId, int quantity) {
    final index = _cartItems.indexWhere((item) => item['id'] == eventId);
    if (index >= 0) {
      if (quantity <= 0) {
        final removedItem = _cartItems[index];
        _cartItems.removeAt(index);
        print('Removed ${removedItem['title']} (quantity became 0)');
      } else {
        _cartItems[index]['quantity'] = quantity;
        print('Updated ${_cartItems[index]['title']} quantity to $quantity');
      }
      notifyListeners();
    }
  }
  void clearCart() {
    print('Clearing cart with ${_cartItems.length} items');
    _cartItems.clear();
    notifyListeners();
  }
  bool isFavorite(String eventId) {
    return _favoriteEvents.any((event) => event['id'] == eventId);
  }
  void addToFavorites(Map<String, dynamic> event) {
    if (!isFavorite(event['id'])) {
      final favoriteEvent = {
        'id': event['id'],
        'title': event['title'],
        'category': event['category'] ?? 'General',
        'date': event['date'],
        'time': event['time'] ?? '12:00 PM',
        'location': event['location'],
        'venue': event['venue'] ?? event['location'],
        'price': _ensureIntPrice(event['price']),
        'rating': event['rating'] ?? 4.5,
        'attendees': event['attendees'] ?? 100,
        'isFeatured': event['isFeatured'] ?? false,
        'addedDate': DateTime.now().toString().split(' ')[0],
        'image': event['imageUrl'] ?? event['image'] ?? 'https://via.placeholder.com/400',
        'tags': event['tags'] ?? ['Event'],
      };
      _favoriteEvents.add(favoriteEvent);
      print('Added ${event['title']} to favorites');
      notifyListeners();
    }
  }
  void removeFromFavorites(String eventId) {
    final removedEvent = _favoriteEvents.firstWhere(
          (event) => event['id'] == eventId,
      orElse: () => <String, dynamic>{},
    );
    _favoriteEvents.removeWhere((event) => event['id'] == eventId);
    if (removedEvent.isNotEmpty) {
      print('Removed ${removedEvent['title']} from favorites');
    }
    notifyListeners();
  }
  void toggleFavorite(Map<String, dynamic> event) {
    if (isFavorite(event['id'])) {
      removeFromFavorites(event['id']);
    } else {
      addToFavorites(event);
    }
  }
  int get subtotal => _cartItems.fold<int>(
      0,
          (sum, item) => sum + (item['price'] as int) * (item['quantity'] as int)
  );
  int calculateDiscount(int discountPercent) {
    if (discountPercent < 0 || discountPercent > 100) {
      return 0;
    }
    return ((subtotal * discountPercent) / 100).round();
  }
  int get serviceFee {
    final fee = (subtotal * 0.05).round();
    return fee < 50 ? 50 : fee;
  }
  int calculateTotal(int discountAmount) {
    final total = subtotal - discountAmount + serviceFee;
    return total < 0 ? 0 : total; // Ensure total is never negative
  }
  int _ensureIntPrice(dynamic price) {
    if (price is int) return price;
    if (price is double) return price.round();
    if (price is String) return int.tryParse(price) ?? 0;
    return 0;
  }
  void printDebugInfo() {
    print('=== AppState Debug Info ===');
    print('Cart items: ${_cartItems.length}');
    print('Total cart quantity: $cartItemCount');
    print('Favorite events: ${_favoriteEvents.length}');
    print('Subtotal: Rs. $subtotal');
    print('Service fee: Rs. $serviceFee');
    print('========================');
  }
  List<Map<String, dynamic>> searchFavorites(String query) {
    if (query.isEmpty) return favoriteEvents;
    final lowercaseQuery = query.toLowerCase();
    return _favoriteEvents.where((event) {
      final title = (event['title'] as String).toLowerCase();
      final category = (event['category'] as String).toLowerCase();
      return title.contains(lowercaseQuery) || category.contains(lowercaseQuery);
    }).toList();
  }
  List<Map<String, dynamic>> filterFavoritesByCategory(String category) {
    if (category.isEmpty || category.toLowerCase() == 'all') {
      return favoriteEvents;
    }
    return _favoriteEvents.where((event) {
      return (event['category'] as String).toLowerCase() == category.toLowerCase();
    }).toList();
  }
  List<String> get favoriteCategories {
    final categories = _favoriteEvents
        .map((event) => event['category'] as String)
        .toSet()
        .toList();
    categories.sort();
    return categories;
  }
  List<Map<String, dynamic>> getCartAsJson() {
    return _cartItems.map((item) => Map<String, dynamic>.from(item)).toList();
  }
  List<Map<String, dynamic>> getFavoritesAsJson() {
    return _favoriteEvents.map((event) => Map<String, dynamic>.from(event)).toList();
  }
  void loadCartFromJson(List<Map<String, dynamic>> cartData) {
    _cartItems = cartData;
    notifyListeners();
  }
  void loadFavoritesFromJson(List<Map<String, dynamic>> favoritesData) {
    _favoriteEvents = favoritesData;
    notifyListeners();
  }
}