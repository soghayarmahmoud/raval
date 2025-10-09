// In lib/screens/search_page.dart
import 'package:flutter/material.dart';
import 'package:store/screens/home_page.dart';
import 'package:store/screens/product_detail_page.dart';
import 'package:store/services/cart_service.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final HomeDataService _dataService = HomeDataService();

  List<ProductModel> _allProducts = [];
  List<ProductModel> _filteredProducts = [];

  RangeValues _priceRange = const RangeValues(0, 1000);
  List<String> _selectedColors = [];
  List<String> _selectedSizes = [];
  
  final List<String> _availableColors = ['وردي', 'أبيض', 'أزرق', 'أسود', 'أخضر'];
  final List<String> _availableSizes = ['S', 'M', 'L', 'XL'];

  @override
  void initState() {
    super.initState();
    _loadAllProducts();
    _searchController.addListener(_applyAllFilters);
  }

  @override
  void dispose() {
    _searchController.removeListener(_applyAllFilters);
    _searchController.dispose();
    super.dispose();
  }

  void _loadAllProducts() {
    final products = [..._dataService.getNewArrivals(), ..._dataService.getBestOffers()];
    setState(() {
      _allProducts = products;
      _filteredProducts = products;
    });
  }

  void _applyAllFilters() {
    List<ProductModel> tempProducts = _allProducts;
    final query = _searchController.text.toLowerCase();

    if (query.isNotEmpty) {
      tempProducts = tempProducts.where((product) {
        final nameMatches = product.name.toLowerCase().contains(query);
        final tagMatches = product.tags.any((tag) => tag.toLowerCase().contains(query));
        return nameMatches || tagMatches;
      }).toList();
    }

    tempProducts = tempProducts.where((p) {
      return p.price >= _priceRange.start && p.price <= _priceRange.end;
    }).toList();

    if (_selectedColors.isNotEmpty) {
      tempProducts = tempProducts.where((p) {
        return p.colors.any((color) => _selectedColors.contains(color));
      }).toList();
    }

    if (_selectedSizes.isNotEmpty) {
      tempProducts = tempProducts.where((p) {
        return p.sizes.any((size) => _selectedSizes.contains(size));
      }).toList();
    }

    setState(() {
      _filteredProducts = tempProducts;
    });
  }

  void _resetFilters() {
      setState(() {
        _priceRange = const RangeValues(0, 1000);
        _selectedColors = [];
        _selectedSizes = [];
      });
      _applyAllFilters();
      Navigator.of(context).pop();
  }

  // --- تم التعديل على هذه الدالة لجعلها متجاوبة ---
  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setSheetState) {
            return DraggableScrollableSheet(
              expand: false,
              initialChildSize: 0.7, // زدنا الحجم المبدئي قليلاً
              maxChildSize: 0.9,
              builder: (_, scrollController) {
                // --- ابدأ التعديل الرئيسي هنا ---
                return Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
                  child: Column(
                    children: [
                      Text('الفلاتر', style: Theme.of(context).textTheme.headlineSmall),
                      const Divider(height: 24),
                      // المحتوى القابل للتمرير
                      Expanded(
                        child: ListView( // استخدمنا ListView لجعل المحتوى قابل للتمرير
                          controller: scrollController, // <-- ربطنا الـ controller هنا
                          children: [
                            Text('السعر (EGP)', style: Theme.of(context).textTheme.titleLarge),
                            RangeSlider(
                              values: _priceRange,
                              min: 0,
                              max: 1000,
                              divisions: 20,
                              labels: RangeLabels('${_priceRange.start.round()}', '${_priceRange.end.round()}'),
                              onChanged: (values) => setSheetState(() => _priceRange = values),
                            ),
                            const SizedBox(height: 24),
                            Text('اللون', style: Theme.of(context).textTheme.titleLarge),
                            Wrap(
                              spacing: 8.0,
                              children: _availableColors.map((color) {
                                final isSelected = _selectedColors.contains(color);
                                return FilterChip(
                                  label: Text(color),
                                  selected: isSelected,
                                  onSelected: (selected) {
                                    setSheetState(() {
                                      isSelected ? _selectedColors.remove(color) : _selectedColors.add(color);
                                    });
                                  },
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 24),
                            Text('المقاس', style: Theme.of(context).textTheme.titleLarge),
                            Wrap(
                              spacing: 8.0,
                              children: _availableSizes.map((size) {
                                final isSelected = _selectedSizes.contains(size);
                                return FilterChip(
                                  label: Text(size),
                                  selected: isSelected,
                                  onSelected: (selected) {
                                    setSheetState(() {
                                      isSelected ? _selectedSizes.remove(size) : _selectedSizes.add(size);
                                    });
                                  },
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                      // الأزرار ثابتة في الأسفل
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(child: OutlinedButton(onPressed: _resetFilters, child: const Text('إعادة تعيين'))),
                          const SizedBox(width: 12),
                          Expanded(child: ElevatedButton(onPressed: () {
                            _applyAllFilters();
                            Navigator.of(context).pop();
                          }, child: const Text('تطبيق'))),
                        ],
                      ),
                    ],
                  ),
                );
                // --- نهاية التعديل الرئيسي ---
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'ابحث عن منتجاتك المفضلة...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.grey[600]),
          ),
          style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color, fontSize: 18),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterSheet,
          ),
        ],
      ),
      body: _filteredProducts.isEmpty
          ? const Center(child: Text('لا توجد منتجات تطابق بحثك أو الفلاتر المختارة'))
          : GridView.builder(
              padding: const EdgeInsets.all(12.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.65,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: _filteredProducts.length,
              itemBuilder: (context, index) {
                final product = _filteredProducts[index];
                return ProductCard(
                  product: product,
                  onCardTap: () {
                     Navigator.push(context, MaterialPageRoute(builder: (context) => ProductDetailPage(product: product)));
                  },
                  onAddToCart: () {
                     final cartService = CartService();
                     cartService.addToCart(product, 1);
                     ScaffoldMessenger.of(context).showSnackBar(
                       SnackBar(content: Text('تمت إضافة "${product.name}" إلى السلة'))
                     );
                  },
                );
              },
            ),
    );
  }
}