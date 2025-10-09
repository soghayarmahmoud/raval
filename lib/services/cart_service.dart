// In lib/services/cart_service.dart
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:store/models/cart_item_model.dart';
import 'package:store/screens/home_page.dart';

class CartService {
  static const String _cartKey = 'cart_items_v2'; // غيرنا المفتاح لتجنب التعارض مع الإصدار القديم

  // إضافة منتج للسلة مع تحديد الكمية
  Future<void> addToCart(ProductModel product, int quantity) async {
    final prefs = await SharedPreferences.getInstance();
    final List<CartItemModel> cartItems = await getCartItems();

    // التحقق إذا كان المنتج موجودًا بالفعل
    final index = cartItems.indexWhere((item) => item.product.id == product.id);

    if (index != -1) {
      // إذا كان موجودًا، قم بزيادة الكمية فقط
      cartItems[index].quantity += quantity;
    } else {
      // إذا لم يكن موجودًا، أضف المنتج الجديد
      cartItems.add(CartItemModel(product: product, quantity: quantity));
    }
    await _saveCartItems(cartItems);
  }

  // حذف منتج من السلة
  Future<void> removeFromCart(String productId) async {
    final List<CartItemModel> cartItems = await getCartItems();
    cartItems.removeWhere((item) => item.product.id == productId);
    await _saveCartItems(cartItems);
  }
  
  // تحديث كمية منتج معين
  Future<void> updateQuantity(String productId, int newQuantity) async {
    final cartItems = await getCartItems();
    final index = cartItems.indexWhere((item) => item.product.id == productId);
    if (index != -1) {
      if (newQuantity > 0) {
        cartItems[index].quantity = newQuantity;
      } else {
        // إذا كانت الكمية صفر أو أقل، احذف المنتج
        cartItems.removeAt(index);
      }
    }
    await _saveCartItems(cartItems);
  }


  // جلب كل المنتجات من السلة
  Future<List<CartItemModel>> getCartItems() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> cartItemsString = prefs.getStringList(_cartKey) ?? [];
    return cartItemsString
        .map((item) => CartItemModel.fromJson(json.decode(item)))
        .toList();
  }

  // دالة داخلية لحفظ التغييرات
  Future<void> _saveCartItems(List<CartItemModel> cartItems) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> cartItemsString =
        cartItems.map((item) => json.encode(item.toJson())).toList();
    await prefs.setStringList(_cartKey, cartItemsString);
  }
}