// In lib/screens/cart_page.dart
import 'package:flutter/material.dart';
import 'package:store/services/cart_service.dart';
import 'package:store/theme.dart';
import 'home_page.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final CartService _cartService = CartService();
  late Future<List<ProductModel>> _cartItemsFuture;

  @override
  void initState() {
    super.initState();
    _loadCartItems();
  }

  void _loadCartItems() {
    setState(() {
      _cartItemsFuture = _cartService.getCartItems();
    });
  }

  void _removeItem(String productId) async {
    await _cartService.removeFromCart(productId);
    _loadCartItems(); // Refresh the list after removing an item
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('سلة المشتريات'),
      ),
      body: FutureBuilder<List<ProductModel>>(
        future: _cartItemsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('السلة فارغة حاليًا', style: TextStyle(fontSize: 18)));
          }

          final cartItems = snapshot.data!;
          final double totalPrice = cartItems.fold(0, (sum, item) => sum + item.price);

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    final product = cartItems[index];
                    return ListTile(
                      leading: Image.network(product.imageUrl, width: 50, height: 50, fit: BoxFit.cover),
                      title: Text(product.name),
                      subtitle: Text('${product.price.toStringAsFixed(2)} EGP'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline, color: Colors.red),
                        onPressed: () => _removeItem(product.id),
                      ),
                    );
                  },
                ),
              ),
              // --- The attractive checkout section ---
              _buildCheckoutSection(totalPrice),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCheckoutSection(double totalPrice) {
    return Container(
      padding: const EdgeInsets.all(16.0).copyWith(bottom: MediaQuery.of(context).padding.bottom + 16),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
           Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('الإجمالي:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text('${totalPrice.toStringAsFixed(2)} EGP', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryPink.withOpacity(0.9), // Lighter background
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(color: AppColors.primaryPink, width: 2), // Border with primary color
                ),
                elevation: 8, // Shadow
                shadowColor: AppColors.primaryPink.withOpacity(0.3),
              ),
              onPressed: () {},
              child: const Text('الانتقال إلى الدفع', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}