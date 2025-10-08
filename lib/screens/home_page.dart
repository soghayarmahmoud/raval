// In lib/screens/home_page.dart
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:store/screens/cart_page.dart';
import 'product_detail_page.dart';
import 'package:store/theme.dart';

// ------------------- 1. Models -------------------
class BannerModel {
  final String imageUrl;
  final String id;
  BannerModel({required this.imageUrl, required this.id});
}

class CategoryModel {
  final String name;
  final String id;
  CategoryModel({required this.name, required this.id});
}

class ProductModel {
  final String name;
  final String imageUrl;
  final double price;
  final String id;
  ProductModel({required this.name, required this.imageUrl, required this.price, required this.id});
}

// ------------------- 2. Data Service (Using Online URLs) -------------------
class HomeDataService {
  List<BannerModel> getBanners() {
    return [
      BannerModel(id: 'b1', imageUrl: 'https://cdn.pixabay.com/photo/2022/07/04/18/43/woman-7301933_640.jpg'),
      BannerModel(id: 'b2', imageUrl: 'https://cdn.pixabay.com/photo/2022/09/16/16/34/woman-7459122_640.jpg'),
      BannerModel(id: 'b3', imageUrl: 'https://cdn.pixabay.com/photo/2022/08/11/21/25/street-7380949_640.jpg'),
    ];
  }

  List<CategoryModel> getCategories() {
    return [
      CategoryModel(id: 'c1', name: 'الكل'),
      CategoryModel(id: 'c2', name: 'بناتي'),
      CategoryModel(id: 'c3', name: 'ولادي'),
      CategoryModel(id: 'c4', name: 'بيبي'),
      CategoryModel(id: 'c5', name: 'تنزيلات'),
    ];
  }

  List<ProductModel> getNewArrivals() {
    return [
      ProductModel(id: 'p1', name: 'فستان بناتي ربيعي', price: 450.00, imageUrl: 'https://cdn.pixabay.com/photo/2017/01/21/18/35/fashion-1998394_640.jpg'),
      ProductModel(id: 'p2', name: 'طقم ولادي صيفي', price: 380.50, imageUrl: 'https://cdn.pixabay.com/photo/2015/11/26/00/14/woman-1062084_640.jpg'),
      ProductModel(id: 'p3', name: 'أفرول بيبي قطن', price: 299.99, imageUrl: 'https://cdn.pixabay.com/photo/2018/07/26/08/04/fashion-3562828_640.jpg'),
    ];
  }

  List<ProductModel> getBestOffers() {
     return [
      ProductModel(id: 'p4', name: 'جاكيت شتوي', price: 600.00, imageUrl: 'https://cdn.pixabay.com/photo/2014/08/26/21/48/shirts-428627_640.jpg'),
      ProductModel(id: 'p5', name: 'تنورة قصيرة', price: 320.00, imageUrl: 'https://cdn.pixabay.com/photo/2015/06/25/16/57/dresses-821216_640.jpg'),
      ProductModel(id: 'p6', name: 'بنطلون جينز', price: 410.00, imageUrl: 'https://cdn.pixabay.com/photo/2017/08/01/11/42/skinny-jeans-2565092_640.jpg'),
    ];
  }
}

// ------------------- 3. Home Page UI (Using Image.network) -------------------
class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // ... (initState, _addToCart, and other logic remains the same)
  final HomeDataService _dataService = HomeDataService();
  late List<CategoryModel> _categories;
  int _cartItemCount = 0;

  @override
  void initState() {
    super.initState();
    _categories = _dataService.getCategories();
  }

  void _addToCart(ProductModel product) {
    setState(() {
      _cartItemCount++;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تمت إضافة "${product.name}" إلى السلة'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // ... (DefaultTabController and Scaffold structure remains the same)
    return DefaultTabController(
      length: _categories.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'RAVAL',
            style: TextStyle(fontFamily: 'Exo2', fontWeight: FontWeight.bold, letterSpacing: 1.5),
          ),
          centerTitle: true,
          actions: [
            _CartIconWithBadge(
              itemCount: _cartItemCount,
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const CartPage()));
              },
            ),
          ],
          bottom: TabBar(
            isScrollable: true,
            tabs: _categories.map((category) => Tab(text: category.name)).toList(),
            labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
          ),
        ),
        body: TabBarView(
          children: _categories.map((category) {
            return _buildCategoryPage();
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildCategoryPage() {
    final banners = _dataService.getBanners();
    final newArrivals = _dataService.getNewArrivals();
    final bestOffers = _dataService.getBestOffers();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CarouselSlider.builder(
            itemCount: banners.length,
            itemBuilder: (context, index, realIndex) {
              return Image.network(
                banners[index].imageUrl, 
                fit: BoxFit.cover, 
                width: double.infinity,
                loadingBuilder: (context, child, progress) {
                  return progress == null ? child : const Center(child: CircularProgressIndicator());
                },
                errorBuilder: (context, error, stackTrace) {
                  return const Center(child: Icon(Icons.error_outline, color: Colors.red, size: 40));
                },
              );
            },
            options: CarouselOptions(height: 220, autoPlay: true, viewportFraction: 1.0),
          ),
          
          _buildProductSection(title: 'وصل حديثًا', products: newArrivals),
          _buildProductSection(title: 'أفضل العروض', products: bestOffers),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
  
  Widget _buildProductSection({required String title, required List<ProductModel> products}) {
    // ... (This widget's structure remains the same)
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
          child: Text(title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        ),
        SizedBox(
          height: 280,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return ProductCard(
                product: product,
                onCardTap: () {
                   Navigator.push(context, MaterialPageRoute(builder: (context) => ProductDetailPage(product: product)));
                },
                onAddToCart: () => _addToCart(product),
              );
            },
          ),
        ),
      ],
    );
  }
}

// --- Widgets (Using Image.network) ---

class _CartIconWithBadge extends StatelessWidget {
  // ... (This widget remains the same)
  final int itemCount;
  final VoidCallback onPressed;

  const _CartIconWithBadge({required this.itemCount, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        IconButton(
          onPressed: onPressed,
          icon: const Icon(Icons.shopping_cart_outlined),
        ),
        if (itemCount > 0)
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(color: AppColors.primaryPink, borderRadius: BorderRadius.circular(10)),
              constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
              child: Text('$itemCount', style: const TextStyle(color: Colors.white, fontSize: 10), textAlign: TextAlign.center),
            ),
          ),
      ],
    );
  }
}

class ProductCard extends StatelessWidget {
  final ProductModel product;
  final VoidCallback onCardTap;
  final VoidCallback onAddToCart;

  const ProductCard({super.key, required this.product, required this.onCardTap, required this.onAddToCart});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onCardTap,
      child: Container(
        width: 180,
        margin: const EdgeInsets.symmetric(horizontal: 4.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: Image.network(
                    product.imageUrl,
                    height: 200,
                    width: 180,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, progress) {
                      return progress == null ? child : Container(height: 200, width: 180, color: Colors.grey[200], child: const Center(child: CircularProgressIndicator()));
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 200,
                        width: 180,
                        decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(12.0)),
                        child: const Center(child: Icon(Icons.image_not_supported_outlined, color: Colors.grey, size: 40)),
                      );
                    },
                  ),
                ),
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: CircleAvatar(
                    backgroundColor: Colors.white.withOpacity(0.8),
                    child: IconButton(
                      icon: Icon(Icons.add_shopping_cart, color: Theme.of(context).primaryColor),
                      onPressed: onAddToCart,
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15), maxLines: 1, overflow: TextOverflow.ellipsis),
            ),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Text('${product.price.toStringAsFixed(2)} EGP', style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 14, fontWeight: FontWeight.w600)),
            ),
          ],
        ),
      ),
    );
  }
}