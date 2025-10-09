import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store/providers/favorites_provider.dart';
import 'package:store/screens/home_page.dart';
import 'package:store/screens/product_detail_page.dart';
import 'package:store/theme.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    // استدعاء provider الخاص بالمفضلة للاستماع للتغييرات
    final favoritesProvider = Provider.of<FavoritesProvider>(context);
    final favoriteItems = favoritesProvider.favoriteItems;

    return Scaffold(
      appBar: AppBar(
        title: const Text('المفضلة'),
      ),
      body:
          // التحقق إذا كانت قائمة المفضلة فارغة
          favoriteItems.isEmpty
              ? Center(
                  // عرض رسالة للمستخدم في حالة عدم وجود منتجات
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.favorite_border,
                          size: 80, color: Colors.grey[400]),
                      const SizedBox(height: 16),
                      Text(
                        'قائمة المفضلة فارغة',
                        style: TextStyle(fontSize: 20, color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'أضف منتجاتك التي تحبها بالضغط على أيقونة القلب',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ],
                  ),
                )
              // إذا لم تكن فارغة، قم بعرض قائمة المنتجات
              : ListView.builder(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                  itemCount: favoriteItems.length,
                  itemBuilder: (context, index) {
                    final product = favoriteItems[index];
                    // استخدام ويدجت مخصصة لعرض كل منتج
                    return _FavoriteItemCard(
                      product: product,
                      onRemove: () {
                        // عند الضغط على زر الحذف، يتم استدعاء الدالة من الـ provider
                        favoritesProvider.toggleFavorite(product);
                      },
                      onTap: () {
                        // عند الضغط على المنتج نفسه، يتم الانتقال لصفحة التفاصيل
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ProductDetailPage(product: product)),
                        );
                      },
                    );
                  },
                ),
    );
  }
}

/// ويدجت مخصصة لعرض كارت المنتج في صفحة المفضلة
class _FavoriteItemCard extends StatelessWidget {
  final ProductModel product;
  final VoidCallback onRemove;
  final VoidCallback onTap;

  const _FavoriteItemCard({
    required this.product,
    required this.onRemove,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 2,
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              // صورة المنتج
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  product.imageUrl,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.image_not_supported_outlined),
                ),
              ),
              const SizedBox(width: 12),
              // اسم وسعر المنتج
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${product.price.toStringAsFixed(2)} EGP',
                      style: TextStyle(
                          fontSize: 15,
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // زر الحذف من المفضلة
              IconButton(
                icon: const Icon(Icons.favorite, color: AppColors.primaryPink),
                onPressed: onRemove,
                tooltip: 'إزالة من المفضلة',
              ),
            ],
          ),
        ),
      ),
    );
  }
}