// In lib/screens/cart_page.dart
import 'package:flutter/material.dart';
import 'package:store/services/auth_service.dart';
import 'package:store/services/cart_service.dart';
import 'package:store/screens/checkout_page.dart';
import 'package:store/screens/signup_page.dart';
import 'package:store/theme.dart';
import 'home_page.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final CartService _cartService = CartService();
  final AuthService _authService = AuthService(); // إضافة خدمة المستخدم
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
    _loadCartItems();
  }
  
  // --- دالة جديدة للتحقق والانتقال للدفع ---
 // In lib/screens/cart_page.dart

  // --- دالة جديدة ومحسنة للتحقق والانتقال للدفع ---
  void _proceedToCheckout() async {
    final bool isLoggedIn = await _authService.isLoggedIn();
    if (!mounted) return; // للتأكد من أن الويدجت ما زالت موجودة

    if (isLoggedIn) {
      // إذا كان مسجل، اذهب لصفحة الدفع مباشرة
      Navigator.push(context, MaterialPageRoute(builder: (context) => const CheckoutPage()));
    } else {
      // إذا لم يكن مسجل، اذهب لصفحة إنشاء حساب
      // وانتظر النتيجة عند العودة من الصفحة
      final signupSuccess = await Navigator.push<bool>(
        context,
        MaterialPageRoute(builder: (context) => const SignUpPage()),
      );

      // إذا عاد المستخدم وكانت النتيجة "true" (أي أنه أنشأ حسابًا بنجاح)
      // قم بالانتقال إلى صفحة الدفع
      if (signupSuccess == true) {
        if (!mounted) return;
        Navigator.push(context, MaterialPageRoute(builder: (context) => const CheckoutPage()));
      }
    }
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
                  padding: const EdgeInsets.all(8.0),
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    final product = cartItems[index];
                    // --- استخدام التصميم الجديد الشبيه بأمازون ---
                    return _CartItemCard(
                      product: product,
                      onRemove: () => _removeItem(product.id),
                    );
                  },
                ),
              ),
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
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), spreadRadius: 1, blurRadius: 10, offset: const Offset(0, -3))],
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
                backgroundColor: AppColors.primaryPink.withOpacity(0.25),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(color: AppColors.primaryPink, width: 2),
                ),
                elevation: 8,
                shadowColor: AppColors.primaryPink.withOpacity(0.7),
              ),
              onPressed: _proceedToCheckout, // <-- استخدام الدالة الجديدة هنا
              child: const Text('الانتقال إلى الدفع', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}

// --- ويدجت جديدة مخصصة لعرض المنتج في السلة ---
class _CartItemCard extends StatelessWidget {
  final ProductModel product;
  final VoidCallback onRemove;

  const _CartItemCard({required this.product, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(product.imageUrl, width: 80, height: 80, fit: BoxFit.cover),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text('${product.price.toStringAsFixed(2)} EGP', style: TextStyle(fontSize: 15, color: Theme.of(context).primaryColor)),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
              onPressed: onRemove,
            ),
          ],
        ),
      ),
    );
  }
}