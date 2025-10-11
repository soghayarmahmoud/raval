import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:store/models/cart_item_model.dart';
import 'package:store/models/product_model.dart';

class CartService {
  static const String _cartKey = 'cart_items_v2'; 
  Future<void> addToCart(ProductModel product, int quantity) async {
    final prefs = await SharedPreferences.getInstance();
    final List<CartItemModel> cartItems = await getCartItems();
    final index = cartItems.indexWhere((item) => item.product.id == product.id);
    if (index != -1) {
      cartItems[index].quantity += quantity;
    } else {
      cartItems.add(CartItemModel(product: product, quantity: quantity));
    }
    await _saveCartItems(cartItems);
  }

  Future<void> removeFromCart(String productId) async {
    final List<CartItemModel> cartItems = await getCartItems();
    cartItems.removeWhere((item) => item.product.id == productId);
    await _saveCartItems(cartItems);
  }
  
  Future<void> updateQuantity(String productId, int newQuantity) async {
    final cartItems = await getCartItems();
    final index = cartItems.indexWhere((item) => item.product.id == productId);
    if (index != -1) {
      if (newQuantity > 0) {
        cartItems[index].quantity = newQuantity;
      } else {
        cartItems.removeAt(index);
      }
    }
    await _saveCartItems(cartItems);
  }


  Future<List<CartItemModel>> getCartItems() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> cartItemsString = prefs.getStringList(_cartKey) ?? [];
    return cartItemsString
        .map((item) => CartItemModel.fromJson(json.decode(item)))
        .toList();
  }

  Future<void> _saveCartItems(List<CartItemModel> cartItems) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> cartItemsString =
        cartItems.map((item) => json.encode(item.toJson())).toList();
    await prefs.setStringList(_cartKey, cartItemsString);
  }
}