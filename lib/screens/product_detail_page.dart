// In lib/screens/product_detail_page.dart

import 'package:flutter/material.dart';
import 'home_page.dart'; // سنحتاج ProductModel من هذا الملف

class ProductDetailPage extends StatelessWidget {
  final ProductModel product;

  const ProductDetailPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(product.imageUrl, height: 300),
            const SizedBox(height: 20),
            Text(
              product.name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              '${product.price.toStringAsFixed(2)} EGP', // السعر
              style: TextStyle(fontSize: 20, color: Theme.of(context).primaryColor),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {},
              child: const Text('إضافة إلى السلة'),
            ),
          ],
        ),
      ),
    );
  }
}