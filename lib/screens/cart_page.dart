// In lib/screens/cart_page.dart
import 'package:flutter/material.dart';
import 'package:store/l10n/app_localizations.dart';
import 'package:store/models/cart_item_model.dart';
import 'package:store/services/auth_service.dart';
import 'package:store/services/cart_service.dart';
import 'package:store/services/address_service.dart';
import 'package:store/screens/checkout_page.dart';
import 'package:store/screens/signup_page.dart';
import 'package:store/screens/location_validation_page.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final CartService _cartService = CartService();
  final AuthService _authService = AuthService();
  late Future<List<CartItemModel>> _cartItemsFuture;

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

  void _updateItemQuantity(String productId, int newQuantity) async {
    await _cartService.updateQuantity(productId, newQuantity);
    _loadCartItems();
  }

  void _proceedToCheckout() async {
    final bool isLoggedIn = await _authService.isLoggedIn();
    if (!mounted) return;

    if (!isLoggedIn) {
      final signupSuccess = await Navigator.push<bool>(
        context,
        MaterialPageRoute(builder: (context) => const SignUpPage()),
      );
      if (signupSuccess != true || !mounted) return;
    }

    // Check if user has a saved address
    final addressService = AddressService();
    final hasAddress = await addressService.hasAddress();

    if (!mounted) return;

    if (hasAddress) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const CheckoutPage()));
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const LocationValidationPage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.cartPageTitle),
      ),
      body: FutureBuilder<List<CartItemModel>>(
        future: _cartItemsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError ||
              !snapshot.hasData ||
              snapshot.data!.isEmpty) {
            return Center(
                child: Text(loc.noAddresses,
                    style: const TextStyle(fontSize: 18)));
          }

          final cartItems = snapshot.data!;
          final double totalPrice = cartItems.fold(
              0, (sum, item) => sum + (item.product.price * item.quantity));

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(8.0),
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    final item = cartItems[index];
                    return _CartItemCard(
                      item: item,
                      onQuantityChanged: (newQuantity) {
                        _updateItemQuantity(item.product.id, newQuantity);
                      },
                    );
                  },
                ),
              ),
              _buildCheckoutSection(context, totalPrice, cartItems.length),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCheckoutSection(
      BuildContext context, double totalPrice, int totalItems) {
    final loc = AppLocalizations.of(context)!;
    return Card(
      margin: EdgeInsets.zero,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      elevation: 10,
      child: Padding(
        padding: const EdgeInsets.all(16.0)
            .copyWith(bottom: MediaQuery.of(context).padding.bottom + 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // --- تم التعديل هنا: استخدام Flexible ---
                // هذا يسمح للنص بأن يأخذ المساحة المتاحة ويتجنب الأخطاء
                Flexible(
                  child: Text(
                    //todo: '${loc.totalLabel} ($totalItems ${loc.products})',
                    'products ($totalItems) price: ${totalPrice.toStringAsFixed(2)} EGP',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade600),
                  ),
                ),
                const SizedBox(width: 8),
                Text('${totalPrice.toStringAsFixed(2)} EGP',
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: _proceedToCheckout,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  elevation: 5,
                ),
                child: Text(loc.checkoutButtonText,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- تم التعديل هنا: استخدام ListTile لجعلها متجاوبة ---
class _CartItemCard extends StatelessWidget {
  final CartItemModel item;
  final ValueChanged<int> onQuantityChanged;

  const _CartItemCard({required this.item, required this.onQuantityChanged});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 4.0),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
        // `leading` لوضع الصورة على اليسار (أو اليمين في العربي)
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Image.network(
            item.product.imageUrl,
            width: 70, // يمكنك تعديل الحجم حسب الرغبة
            height: 70,
            fit: BoxFit.cover,
          ),
        ),
        // `title` لوضع اسم المنتج
        title: Text(
          item.product.name,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        // `subtitle` لوضع السعر
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Text(
            '${item.product.price.toStringAsFixed(2)} EGP',
            style: TextStyle(
              fontSize: 15,
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        // `trailing` لوضع عداد الكمية في نهاية السطر
        trailing: Row(
          mainAxisSize: MainAxisSize.min, // ليأخذ أقل مساحة ممكنة
          children: [
            IconButton(
              icon: const Icon(Icons.remove_circle_outline),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              onPressed: () => onQuantityChanged(item.quantity - 1),
            ),
            Text(
              '${item.quantity}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            IconButton(
              icon: const Icon(Icons.add_circle_outline),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              onPressed: () => onQuantityChanged(item.quantity + 1),
            ),
          ],
        ),
      ),
    );
  }
}
