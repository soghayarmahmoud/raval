// In lib/screens/cart_page.dart
import 'package:flutter/material.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('سلة المشتريات'),
      ),
      body: const Center(
        child: Text(
          'السلة فارغة حاليًا',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}