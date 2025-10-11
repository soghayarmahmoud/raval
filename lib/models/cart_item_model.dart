// In lib/models/cart_item_model.dart
import 'package:store/models/product_model.dart';

class CartItemModel {
  final ProductModel product;
  int quantity;

  CartItemModel({required this.product, this.quantity = 1});

  Map<String, dynamic> toJson() => {
        'product': product.toJson(),
        'quantity': quantity,
      };

  factory CartItemModel.fromJson(Map<String, dynamic> json) => CartItemModel(
        product: ProductModel.fromJson(json['product']),
        quantity: json['quantity'],
      );
}