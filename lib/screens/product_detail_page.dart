// In lib/screens/product_detail_page.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:photo_view/photo_view.dart';

import 'package:store/models/product_model.dart';
import 'package:store/providers/favorites_provider.dart';
import 'package:store/services/cart_service.dart';
import 'package:store/services/auth_service.dart';
import 'package:store/screens/login_page.dart';
import 'package:store/screens/location_validation_page.dart';
import 'package:store/screens/cart_page.dart';
import 'package:store/screens/checkout_page.dart';
import 'package:store/l10n/app_localizations.dart';

class ProductDetailPage extends StatefulWidget {
  final ProductModel product;

  const ProductDetailPage({super.key, required this.product});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage>
    with SingleTickerProviderStateMixin {
  final CartService _cartService = CartService();
  late final AnimationController _slideController;
  int _currentImageIndex = 0;
  int _quantity = 1;
  String? _selectedColor;
  String? _selectedSize;

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _slideController.dispose();
    super.dispose();
  }

  void _showFullScreenImage(BuildContext context, String imageUrl) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Scaffold(
          backgroundColor: Colors.black,
          body: Stack(
            children: [
              PhotoView(
                imageProvider: NetworkImage(imageUrl),
                minScale: PhotoViewComputedScale.contained,
                maxScale: PhotoViewComputedScale.covered * 2,
                heroAttributes:
                    PhotoViewHeroAttributes(tag: 'product-image-$imageUrl'),
              ),
              Positioned(
                top: 40,
                right: 20,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _buyNowFlow(BuildContext context) async {
    final authService = AuthService();
    var isLoggedIn = await authService.isLoggedIn();
    if (!mounted) return;
    if (!isLoggedIn) {
      final result = await Navigator.push<bool>(
        context,
        MaterialPageRoute(builder: (c) => const LoginPage()),
      );
      isLoggedIn = result == true;
    }

    if (!isLoggedIn || !mounted) return;

    await Navigator.push(
      context,
      MaterialPageRoute(builder: (c) => const LocationValidationPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final favoritesProvider = Provider.of<FavoritesProvider>(context);
    final isFavorite = favoritesProvider.isFavorite(widget.product);
    final theme = Theme.of(context);
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 400,
            pinned: true,
            backgroundColor: theme.scaffoldBackgroundColor,
            actions: [
              IconButton(
                icon: const Icon(Icons.shopping_cart_outlined),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CartPage()),
                  );
                },
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                children: [
                  CarouselSlider(
                    options: CarouselOptions(
                      height: double.infinity,
                      viewportFraction: 1,
                      autoPlay: true,
                      autoPlayInterval: const Duration(seconds: 3),
                      onPageChanged: (index, reason) {
                        setState(() => _currentImageIndex = index);
                      },
                    ),
                    items: widget.product.images.map((url) {
                      return GestureDetector(
                        onTap: () => _showFullScreenImage(context, url),
                        child: Hero(
                          tag: 'product-image-$url',
                          child: Image.network(
                            url,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  Positioned(
                    bottom: 20,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:
                          widget.product.images.asMap().entries.map((entry) {
                        return GestureDetector(
                          onTap: () {},
                          child: Container(
                            width: 8,
                            height: 8,
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: theme.primaryColor.withOpacity(
                                  _currentImageIndex == entry.key ? 1 : 0.4),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          widget.product.name,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite ? Colors.red : null,
                        ),
                        onPressed: () {
                          favoritesProvider.toggleFavorite(widget.product);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${widget.product.price.toStringAsFixed(2)} ${loc.currency}',
                    style: TextStyle(
                      fontSize: 24,
                      color: theme.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  if (widget.product.availableColors.isNotEmpty) ...[
                    Text(
                      loc.available_colors,
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 50,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: widget.product.availableColors.length,
                        itemBuilder: (context, index) {
                          final color = widget.product.availableColors[index];
                          final isSelected = color == _selectedColor;
                          Color parsed;
                          try {
                            parsed = Color(int.parse('0xFF$color'));
                          } catch (_) {
                            parsed = Colors.grey;
                          }
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: GestureDetector(
                              onTap: () =>
                                  setState(() => _selectedColor = color),
                              child: CircleAvatar(
                                radius: 25,
                                backgroundColor: parsed,
                                child: isSelected
                                    ? const Icon(Icons.check,
                                        color: Colors.white)
                                    : null,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                  if (widget.product.availableSizes.isNotEmpty) ...[
                    Text(
                      loc.available_sizes,
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: widget.product.availableSizes.map((size) {
                        final isSelected = size == _selectedSize;
                        return ChoiceChip(
                          label: Text(size),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(
                                () => _selectedSize = selected ? size : null);
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),
                  ],
                  Text(
                    loc.quantity,
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: theme.primaryColor),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: () {
                                if (_quantity > 1) {
                                  setState(() => _quantity--);
                                }
                              },
                            ),
                            Text(
                              '$_quantity',
                              style: const TextStyle(fontSize: 18),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () {
                                setState(() => _quantity++);
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    loc.description,
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.product.description,
                    style: theme.textTheme.bodyLarge?.copyWith(height: 1.5),
                  ),
                  const SizedBox(height: 24),
                  if (widget.product.additionalInfo.isNotEmpty) ...[
                    Text(
                      loc.additional_info,
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    ...widget.product.additionalInfo.entries.map((entry) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${entry.key}: ',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Expanded(child: Text(entry.value)),
                          ],
                        ),
                      );
                    }),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              offset: const Offset(0, -4),
              blurRadius: 8,
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  _cartService.addToCart(widget.product, _quantity);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(loc.added_to_cart),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(loc.add_to_cart),
              ),
            ),
            const SizedBox(width: 12),
            SizedBox(
              width: 140,
              child: OutlinedButton(
                onPressed: () => _buyNowFlow(context),
                child: Text(loc.buy_now),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              onPressed: () {
                favoritesProvider.toggleFavorite(widget.product);
              },
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: isFavorite ? Colors.red : null,
              ),
            ),
            IconButton(
              onPressed: () {
              },
              icon: const Icon(Icons.share),
            ),
          ],
        ),
      ),
    );
  }
}