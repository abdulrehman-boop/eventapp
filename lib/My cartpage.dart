import 'package:eventify/state_management/app_state.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);
  @override
  State<CartPage> createState() => _CartPageState();
}
class _CartPageState extends State<CartPage> {
  final TextEditingController _promoController = TextEditingController();
  final AppState appState = AppState(); // Singleton instance
  String appliedPromo = '';
  int discountPercent = 0;
  final List<Map<String, dynamic>> recommended = [
    {
      "id": "r1",
      "title": "DJ Night",
      "date": "Nov 12, 2025",
      "location": "Karachi",
      "price": 900,
      "imageUrl": "https://img1.exportersindia.com/product_images/bc-full/2020/9/6868292/dj-night-party-services-1600770259-5590905.jpeg"
    },
    {
      "id": "r2",
      "title": "Film Festival",
      "date": "Feb 2, 2026",
      "location": "Lahore",
      "price": 1200,
      "imageUrl": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTu3X5wnA7re95iNpaqMuzNoxzpW6yyHL1u-g&s"
    },
    {
      "id": "r3",
      "title": "Gaming Expo",
      "date": "Mar 3, 2026",
      "location": "Islamabad",
      "price": 700,
      "imageUrl": "https://images.unsplash.com/photo-1542751371-adc38448a05e?auto=format&fit=crop&w=800&q=60"
    },
  ];
  int get discountAmount => appState.calculateDiscount(discountPercent);
  int get total => appState.calculateTotal(discountAmount);

  @override
  void initState() {
    super.initState();
    print('Cart page loaded with ${appState.cartItems.length} items');
  }
  void _applyPromo() {
    final code = _promoController.text.trim().toUpperCase();
    if (code.isEmpty) {
      _showSnack("Enter a promo code.");
      return;
    }
    if (code == 'FLUTTER10') {
      setState(() {
        appliedPromo = code;
        discountPercent = 10;
      });
      _showSnack("FLUTTER10 applied — 10% off");
    } else if (code == 'EVENT5') {
      setState(() {
        appliedPromo = code;
        discountPercent = 5;
      });
      _showSnack("EVENT5 applied — 5% off");
    } else {
      setState(() {
        appliedPromo = '';
        discountPercent = 0;
      });
      _showSnack("Invalid promo code.");
    }
  }

  void _addRecommendedToCart(Map<String, dynamic> item) {
    appState.addToCart(item);
    _showSnack("${item['title']} added to cart");
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

  void _checkout() {
    if (appState.cartItems.isEmpty) {
      _showSnack("Your cart is empty.");
      return;
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: Text(
          "Confirm Checkout",
          style: GoogleFonts.poppins(color: Colors.white),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _lineEntry("Subtotal", "Rs. ${appState.subtotal}"),
              _lineEntry("Discount", "- Rs. $discountAmount"),
              _lineEntry("Service Fee", "Rs. ${appState.serviceFee}"),
              const Divider(color: Colors.white24),
              _lineEntry("Total", "Rs. $total", valueColor: Colors.amber),
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
              Navigator.pop(context);
              appState.clearCart();
              setState(() {
                appliedPromo = '';
                discountPercent = 0;
                _promoController.clear();
              });
              _showSnack("Checkout successful! Cart cleared.");
            },
            child: Text(
              "Pay Rs. $total",
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _lineEntry(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: GoogleFonts.montserrat(color: Colors.white70),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: GoogleFonts.poppins(
                color: valueColor ?? Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.end,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
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
          child: ListenableBuilder(
            listenable: appState,
            builder: (context, child) {
              return Column(
                children: [
                  _customAppBar(),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: appState.cartItems.isEmpty
                          ? _emptyCartView()
                          : _cartListWithRecommended(),
                    ),
                  ),
                  if (appState.cartItems.isNotEmpty) _checkoutArea(),
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
          BoxShadow(
            color: Colors.black.withOpacity(0.6),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
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
                "My Cart",
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          Icon(Icons.more_vert, color: Colors.white),
        ],
      ),
    );
  }

  Widget _emptyCartView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.white24),
        const SizedBox(height: 12),
        Text(
          "Your cart is empty",
          style: GoogleFonts.poppins(color: Colors.white70, fontSize: 18),
        ),
        const SizedBox(height: 8),
        Text(
          "Add events from Recommended below.",
          style: GoogleFonts.montserrat(color: Colors.white54),
        ),
        const SizedBox(height: 20),
        Expanded(
          child: _recommendedSection(),
        ),
      ],
    );
  }

  Widget _cartListWithRecommended() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 12),
      itemCount: appState.cartItems.length + 1,
      itemBuilder: (context, index) {
        if (index < appState.cartItems.length) {
          final item = appState.cartItems[index];
          return _cartItemCard(item);
        } else {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 6),
              Text(
                "Recommended for you",
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(height: 200, child: _recommendedHorizontal()),
              const SizedBox(height: 12),
            ],
          );
        }
      },
    );
  }

  Widget _cartItemCard(Map<String, dynamic> item) {
    return Dismissible(
      key: Key(item['id'] + DateTime.now().millisecondsSinceEpoch.toString()),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.red.shade700,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(Icons.delete_forever, color: Colors.white),
      ),
      onDismissed: (_) {
        appState.removeFromCart(item['id']);
        _showSnack("${item['title']} removed");
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          gradient: LinearGradient(
            colors: [
              Colors.deepPurple.shade700.withOpacity(0.35),
              Colors.black87
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black54,
              blurRadius: 6,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  item['image'] ?? item['imageUrl'] ?? 'https://via.placeholder.com/64',
                  width: 64,
                  height: 64,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) {
                    return Container(
                      width: 64,
                      height: 64,
                      color: Colors.white12,
                      child: Icon(Icons.event, color: Colors.white30),
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['title'],
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "${item['date']} • ${item['location']}",
                      style: GoogleFonts.montserrat(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        InkWell(
                          onTap: () {
                            final currentQuantity = item['quantity'] as int;
                            if (currentQuantity > 1) {
                              appState.updateCartItemQuantity(
                                  item['id'], currentQuantity - 1);
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white12,
                            ),
                            child: Icon(Icons.remove,
                                color: Colors.white70, size: 18),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          "${item['quantity']}",
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(width: 10),
                        InkWell(
                          onTap: () {
                            final currentQuantity = item['quantity'] as int;
                            appState.updateCartItemQuantity(
                                item['id'], currentQuantity + 1);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.deepPurpleAccent,
                            ),
                            child: Icon(Icons.add, color: Colors.white, size: 18),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          "Rs. ${(item['price'] as int) * (item['quantity'] as int)}",
                          style: GoogleFonts.poppins(
                            color: Colors.amber,
                            fontWeight: FontWeight.w700,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: Icon(Icons.delete_outline, color: Colors.white54),
                onPressed: () {
                  appState.removeFromCart(item['id']);
                  _showSnack("${item['title']} removed");
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _recommendedSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Recommended Events",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Expanded(child: _recommendedHorizontal()),
      ],
    );
  }

  Widget _recommendedHorizontal() {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: recommended.length,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      separatorBuilder: (_, __) => const SizedBox(width: 12),
      itemBuilder: (context, idx) {
        final r = recommended[idx];
        return Container(
          width: 180,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              colors: [Colors.black87, Colors.deepPurple.shade800],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black54,
                blurRadius: 6,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                child: Image.network(
                  r['imageUrl'],
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
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        r['title'],
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "${r['date']} • ${r['location']}",
                        style: GoogleFonts.montserrat(
                          color: Colors.white70,
                          fontSize: 11,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              "Rs. ${r['price']}",
                              style: GoogleFonts.poppins(
                                color: Colors.amber,
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 4),
                          SizedBox(
                            height: 28,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.deepPurpleAccent,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                minimumSize: Size(50, 28),
                              ),
                              onPressed: () => _addRecommendedToCart(r),
                              child: Text(
                                "Add",
                                style: GoogleFonts.montserrat(
                                  fontSize: 11,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _checkoutArea() {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.85),
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(16),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black54,
            blurRadius: 8,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _promoController,
                    style: GoogleFonts.montserrat(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: appliedPromo.isEmpty
                          ? "Enter promo code"
                          : "Applied: $appliedPromo",
                      hintStyle: GoogleFonts.montserrat(color: Colors.white54),
                      filled: true,
                      fillColor: Colors.deepPurple.shade800.withOpacity(0.35),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 14,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurpleAccent,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: _applyPromo,
                  child: Text(
                    "Apply",
                    style: GoogleFonts.montserrat(color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Subtotal",
                      style: GoogleFonts.montserrat(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Rs. ${appState.subtotal}",
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "Discount",
                      style: GoogleFonts.montserrat(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "- Rs. $discountAmount",
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Service Fee",
                  style: GoogleFonts.montserrat(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
                Text(
                  "Rs. ${appState.serviceFee}",
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const Divider(color: Colors.white12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Total",
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _checkout,
                  icon: Icon(Icons.payment, size: 18, color: Colors.black87),
                  label: Text(
                    "Pay Rs. $total",
                    style: GoogleFonts.poppins(
                      color: Colors.black87,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black87,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  @override
  void dispose() {
    _promoController.dispose();
    super.dispose();
  }
}