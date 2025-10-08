// In lib/screens/product_detail_page.dart
import 'package:flutter/material.dart';
import 'package:store/services/cart_service.dart';
import 'home_page.dart'; // We need ProductModel from here

class ProductDetailPage extends StatelessWidget {
  final ProductModel product;
  final CartService _cartService = CartService();

  ProductDetailPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.network(product.imageUrl, height: 400, width: double.infinity, fit: BoxFit.cover),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '${product.price.toStringAsFixed(2)} EGP',
                    style: TextStyle(fontSize: 22, color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'وصف المنتج هنا. هذا النص هو مثال لوصف المنتج ويمكن استبداله بالوصف الحقيقي للمنتج لاحقًا.',
                    style: TextStyle(fontSize: 16, height: 1.5),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        _cartService.addToCart(product);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('تمت إضافة "${product.name}" إلى السلة'),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
                      child: const Text('إضافة إلى السلة', style: TextStyle(fontSize: 18)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}