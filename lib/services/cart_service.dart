// In lib/cart_service.dart
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:store/screens/home_page.dart';

class CartService {
  static const String _cartKey = 'cart_items';

  // إضافة منتج للسلة
  Future<void> addToCart(ProductModel product) async {
    final prefs = await SharedPreferences.getInstance();
    final List<ProductModel> cartItems = await getCartItems();
    
    // منع إضافة نفس المنتج مرتين
    if (!cartItems.any((item) => item.id == product.id)) {
      cartItems.add(product);
      await _saveCartItems(cartItems);
    }
  }

  // حذف منتج من السلة
  Future<void> removeFromCart(String productId) async {
    final List<ProductModel> cartItems = await getCartItems();
    cartItems.removeWhere((item) => item.id == productId);
    await _saveCartItems(cartItems);
  }

  // جلب كل المنتجات من السلة
  Future<List<ProductModel>> getCartItems() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> cartItemsString = prefs.getStringList(_cartKey) ?? [];
    return cartItemsString
        .map((item) => ProductModel.fromJson(json.decode(item)))
        .toList();
  }
  
  // دالة داخلية لحفظ التغييرات
  Future<void> _saveCartItems(List<ProductModel> cartItems) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> cartItemsString =
        cartItems.map((item) => json.encode(item.toJson())).toList();
    await prefs.setStringList(_cartKey, cartItemsString);
  }
}