import 'package:flutter/material.dart';
import 'package:store/screens/home_page.dart'; // لاستيراد ProductModel

class FavoritesProvider with ChangeNotifier {
  final List<ProductModel> _favoriteItems = [];

  List<ProductModel> get favoriteItems => _favoriteItems;

  // دالة للتحقق إذا كان المنتج في المفضلة
  bool isFavorite(ProductModel product) {
    return _favoriteItems.any((item) => item.id == product.id);
  }

  // دالة لإضافة أو إزالة المنتج من المفضلة
  void toggleFavorite(ProductModel product) {
    if (isFavorite(product)) {
      _favoriteItems.removeWhere((item) => item.id == product.id);
    } else {
      _favoriteItems.add(product);
    }
    // لإعلام كل الـ widgets التي تستمع لهذا الـ Provider أن هناك تغييرًا قد حدث
    notifyListeners();
  }
}