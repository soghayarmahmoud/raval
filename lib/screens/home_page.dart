// In lib/screens/home_page.dart
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:store/screens/category_product_page.dart';
import 'package:store/services/cart_service.dart';
import 'package:store/screens/cart_page.dart';
import 'package:store/models/product_model.dart';
import 'product_detail_page.dart';
import 'package:store/theme.dart';

// --------- 1. Models ---------

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

// ------------------- 2. Data Service -------------------
class HomeDataService {
  List<BannerModel> getBanners() {
    return [
      BannerModel(
          id: 'b1',
          imageUrl:
              'https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.houseofindya.com%2Fkids%2Fgirls-clothing%2Fcat&psig=AOvVaw06qMWDUv5wS6HVG3URP9Wk&ust=1760097979706000&source=images&cd=vfe&opi=89978449&ved=0CBUQjRxqFwoTCLC2soiKl5ADFQAAAAAdAAAAABAE'),
      BannerModel(
          id: 'b2',
          imageUrl:
              'https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.pinterest.com%2Fpin%2F20688479528342559%2F&psig=AOvVaw06qMWDUv5wS6HVG3URP9Wk&ust=1760097979706000&source=images&cd=vfe&opi=89978449&ved=0CBUQjRxqFwoTCLC2soiKl5ADFQAAAAAdAAAAABAK'),
      BannerModel(
          id: 'b3',
          imageUrl:
              'https://africanclothingstore.co.uk/wp-content/uploads/2020/12/DSC_0353.jpg'),
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
      ProductModel(
        id: 'p1',
        name: 'فستان بناتي ربيعي',
        price: 450.00,
        salePrice: 399.00,
        imageUrl:
            'https://africanclothingstore.co.uk/wp-content/uploads/2020/12/DSC_0353.jpg',
        images: [
          'https://www.foreverkidz.in/cdn/shop/files/WhatsAppImage2025-08-29at2.58.50PM.jpg?v=1756462531&width=3000',
          'https://img.faballey.com/images/Product/AIC00007L/4.jpg',
        ],
        description:
            'فستان بناتي رائع مصنوع من أجود أنواع القطن، مناسب لفصل الربيع والخريف. تصميم أنيق بألوان زاهية.',
        tags: ['بناتي', 'فساتين', 'ربيعي'],
        availableSizes: ['S', 'M', 'L'],
        availableColors: ['FF69B4', 'FFFFFF'],
        isFavorite: false,
        stock: 10,
        category: 'بناتي',
        additionalInfo: {
          'المواد': 'قطن',
          'الموسم': 'ربيع/خريف',
          'نمط': 'كاجوال',
        },
      ),
      ProductModel(
        id: 'p2',
        name: 'طقم ولادي صيفي',
        price: 380.50,
        imageUrl:
            'https://images.pexels.com/photos/4263705/pexels-photo-4263705.jpeg',
        description:
            'طقم ولادي مميز مناسب لفصل الصيف، خامة قطنية مريحة وألوان زاهية',
        tags: ['ولادي', 'صيفي'],
        availableSizes: ['M', 'L', 'XL'],
        availableColors: ['0000FF'],
        isFavorite: false,
        stock: 15,
        category: 'ولادي',
        additionalInfo: {
          'المواد': 'قطن',
          'الموسم': 'صيف',
          'نمط': 'سبورت',
        },
      ),
    ];
  }

  List<ProductModel> getBestOffers() {
    return [
      ProductModel(
        id: 'p4',
        name: 'جاكيت شتوي',
        price: 600.00,
        imageUrl:
            'https://images.pexels.com/photos/34222783/pexels-photo-34222783.jpeg',
        description:
            'جاكيت شتوي دافئ مناسب لفصل الشتاء، بتصميم عصري وخامة ممتازة',
        tags: ['شتوي', 'ولادي'],
        availableSizes: ['S', 'M'],
        availableColors: ['000000'],
        isFavorite: false,
        stock: 8,
        category: 'ولادي',
        additionalInfo: {
          'المواد': 'صوف وبوليستر',
          'الموسم': 'شتاء',
          'نمط': 'كاجوال',
          'البطانة': 'مبطن',
        },
      ),
    ];
  }
}

// ------------------- 3. Home Page UI -------------------
class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

// --- تم التعديل هنا ---
class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  final HomeDataService _dataService = HomeDataService();
  final CartService _cartService = CartService();
  late List<CategoryModel> _categories;
  int _cartItemCount = 0;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _categories = _dataService.getCategories();
    _loadCartCount();

    _tabController = TabController(length: _categories.length, vsync: this);
    _tabController.addListener(_handleTabSelection);
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabSelection);
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      if (_tabController.index != 0) {
        final selectedCategory = _categories[_tabController.index];

        // في تطبيق حقيقي، ستقوم بجلب المنتجات من قاعدة البيانات بناءً على الصنف
        // حاليًا، سنقوم بتمرير كل المنتجات كمثال
        final allProducts = [
          ..._dataService.getNewArrivals(),
          ..._dataService.getBestOffers()
        ];
        final categoryProducts = allProducts
            .where((p) => p.tags.contains(selectedCategory.name))
            .toList();

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CategoryProductsPage(
              categoryName: selectedCategory.name,
              products: categoryProducts.isEmpty
                  ? allProducts
                  : categoryProducts, // fallback to all if empty
            ),
          ),
        ).then((_) {
          // لمنع بقاء التاب معلمًا عند العودة
          _tabController.animateTo(0);
        });
      }
    }
  }

  void _loadCartCount() async {
    final items = await _cartService.getCartItems();
    if (mounted) {
      setState(() {
        _cartItemCount = items.length;
      });
    }
  }

  void _addToCart(ProductModel product, int quantity) async {
    await _cartService.addToCart(product, quantity);
    _loadCartCount();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('تمت إضافة "${product.name}" إلى السلة')),
      );
    }
  }

  void _navigateToProductDetail(ProductModel product) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ProductDetailPage(product: product)),
    ).then((_) => _loadCartCount());
  }

  void _navigateToCart() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CartPage()),
    ).then((_) => _loadCartCount());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RAVAL',
            style: TextStyle(
                fontFamily: 'Exo2',
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5)),
        centerTitle: true,
        actions: [
          _CartIconWithBadge(
            itemCount: _cartItemCount,
            onPressed: _navigateToCart,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs:
              _categories.map((category) => Tab(text: category.name)).toList(),
          labelStyle:
              const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
        ),
      ),
      // --- تم حذف TabBarView من هنا ---
      body: _buildCategoryPage(),
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
                  return progress == null
                      ? child
                      : const Center(child: CircularProgressIndicator());
                },
                errorBuilder: (context, error, stackTrace) {
                  return const Center(
                      child: Icon(Icons.error_outline,
                          color: Colors.red, size: 40));
                },
              );
            },
            options: CarouselOptions(
                height: 220, autoPlay: true, viewportFraction: 1.0),
          ),
          _buildProductSection(title: 'وصل حديثًا', products: newArrivals),
          _buildProductSection(title: 'أفضل العروض', products: bestOffers),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildProductSection(
      {required String title, required List<ProductModel> products}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
          child: Text(title,
              style:
                  const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
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
                onCardTap: () => _navigateToProductDetail(product),
                onAddToCart: () => _addToCart(product, 1),
              );
            },
          ),
        ),
      ],
    );
  }
}

// --- Helper Widgets ---

class _CartIconWithBadge extends StatelessWidget {
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
              decoration: BoxDecoration(
                color: AppColors.primaryPink,
                borderRadius: BorderRadius.circular(10),
              ),
              constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
              child: Text(
                '$itemCount',
                style: const TextStyle(color: Colors.white, fontSize: 10),
                textAlign: TextAlign.center,
              ),
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

  const ProductCard({
    super.key,
    required this.product,
    required this.onCardTap,
    required this.onAddToCart,
  });

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
                      return progress == null
                          ? child
                          : Container(
                              height: 200,
                              width: 180,
                              color: Colors.grey[200],
                              child: const Center(
                                  child: CircularProgressIndicator()));
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 200,
                        width: 180,
                        decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(12.0)),
                        child: const Center(
                            child: Icon(Icons.image_not_supported_outlined,
                                color: Colors.grey, size: 40)),
                      );
                    },
                  ),
                ),
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: CircleAvatar(
                    backgroundColor: Colors.white.withAlpha(204),
                    child: IconButton(
                      icon: Icon(Icons.add_shopping_cart,
                          color: Theme.of(context).primaryColor),
                      onPressed: onAddToCart,
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Text(
                product.name,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Text(
                '${product.price.toStringAsFixed(2)} EGP',
                style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
