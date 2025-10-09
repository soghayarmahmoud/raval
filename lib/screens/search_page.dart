import 'package:flutter/material.dart';
import 'package:store/screens/home_page.dart';
import 'package:store/screens/product_detail_page.dart';
import 'package:store/theme.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final HomeDataService _dataService = HomeDataService();

  List<ProductModel> _allProducts = [];
  List<ProductModel> _searchResults = [];
  bool _hasSearched = false;

  @override
  void initState() {
    super.initState();
    // نقوم بتحميل كل المنتجات مرة واحدة عند فتح الصفحة
    _loadAllProducts();

    // نضيف مستمعًا لوحدة التحكم لنقوم بالبحث مع كل تغيير في النص
    _searchController.addListener(_performSearch);
  }

  @override
  void dispose() {
    _searchController.removeListener(_performSearch);
    _searchController.dispose();
    super.dispose();
  }

  void _loadAllProducts() {
    // نجمع المنتجات من كل الأقسام في قائمة واحدة
    final List<ProductModel> products = [];
    products.addAll(_dataService.getNewArrivals());
    products.addAll(_dataService.getBestOffers());
    
    // يمكنك إضافة المزيد من المصادر هنا في المستقبل
    
    setState(() {
      _allProducts = products;
    });
  }

  void _performSearch() {
    final query = _searchController.text;

    // إذا كان مربع البحث فارغًا، نعيد القائمة للحالة الأولية
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _hasSearched = false;
      });
      return;
    }

    final lowerCaseQuery = query.toLowerCase();
    
    // نقوم بفلترة قائمة المنتجات الكاملة بناءً على نص البحث
    final results = _allProducts.where((product) {
      final nameMatches = product.name.toLowerCase().contains(lowerCaseQuery);
      final descriptionMatches = product.description.toLowerCase().contains(lowerCaseQuery);
      final tagMatches = product.tags.any((tag) => tag.toLowerCase().contains(lowerCaseQuery));

      return nameMatches || descriptionMatches || tagMatches;
    }).toList();

    setState(() {
      _searchResults = results;
      _hasSearched = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // شريط البحث المدمج في الـ AppBar
        title: TextField(
          controller: _searchController,
          autofocus: true, // لفتح الكيبورد تلقائيًا
          decoration: InputDecoration(
            hintText: 'ابحث عن فستان, بنطلون...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.grey[600]),
          ),
          style: TextStyle(
            color: Theme.of(context).textTheme.bodyLarge?.color,
            fontSize: 18,
          ),
        ),
        actions: [
          // زر لمسح النص في شريط البحث
          if (_searchController.text.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                _searchController.clear();
              },
            ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    // الحالة الأولى: قبل أن يبدأ المستخدم بالبحث
    if (!_hasSearched) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search, size: 80, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'ابحث عن منتجاتك المفضلة',
              style: TextStyle(fontSize: 20, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    // الحالة الثانية: بعد البحث ولكن لا توجد نتائج
    if (_searchResults.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.search_off, size: 80, color: Colors.grey),
            const SizedBox(height: 16),
            const Text(
              'لا توجد نتائج تطابق بحثك',
              style: TextStyle(fontSize: 20, color: Colors.grey),
            ),
            Text(
              '"${_searchController.text}"',
              style: TextStyle(fontSize: 18, color: Colors.grey[600], fontWeight: FontWeight.bold),
            ),
          ],
        ),
      );
    }
    
    // الحالة الثالثة: تم العثور على نتائج، نعرضها في قائمة
    return ListView.builder(
      padding: const EdgeInsets.all(12.0),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final product = _searchResults[index];
        return _SearchResultCard(product: product);
      },
    );
  }
}


/// ويدجت مخصصة لعرض كارت المنتج في صفحة البحث
class _SearchResultCard extends StatelessWidget {
  final ProductModel product;

  const _SearchResultCard({required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          // عند الضغط، يتم الانتقال لصفحة تفاصيل المنتج
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductDetailPage(product: product),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  product.imageUrl,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${product.price.toStringAsFixed(2)} EGP',
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}