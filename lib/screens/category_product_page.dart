// In lib/screens/category_products_page.dart
import 'package:flutter/material.dart';
import 'package:store/models/product_model.dart';
import 'package:store/screens/home_page.dart';

class CategoryProductsPage extends StatefulWidget {
  final String categoryName;
  final List<ProductModel> products;

  const CategoryProductsPage({
    super.key,
    required this.categoryName,
    required this.products,
  });

  @override
  State<CategoryProductsPage> createState() => _CategoryProductsPageState();
}

class _CategoryProductsPageState extends State<CategoryProductsPage> {
  late List<ProductModel> _filteredProducts;

  RangeValues _priceRange = const RangeValues(0, 1000);
  List<String> _selectedColors = [];
  List<String> _selectedSizes = [];

  final List<String> _availableColors = ['وردي', 'أبيض', 'أزرق', 'أسود', 'أخضر'];
  final List<String> _availableSizes = ['S', 'M', 'L', 'XL'];


  @override
  void initState() {
    super.initState();
    _filteredProducts = widget.products;
  }

  void _applyFilters() {
    List<ProductModel> tempProducts = widget.products;

    tempProducts = tempProducts.where((p) {
      return p.price >= _priceRange.start && p.price <= _priceRange.end;
    }).toList();

    // 2. الفلترة باللون
    if (_selectedColors.isNotEmpty) {
      tempProducts = tempProducts.where((p) {
        return p.colors.any((color) => _selectedColors.contains(color));
      }).toList();
    }

    // 3. الفلترة بالمقاس
    if (_selectedSizes.isNotEmpty) {
      tempProducts = tempProducts.where((p) {
        return p.sizes.any((size) => _selectedSizes.contains(size));
      }).toList();
    }

    setState(() {
      _filteredProducts = tempProducts;
    });

    Navigator.of(context).pop(); // إغلاق نافذة الفلاتر
  }

  void _resetFilters() {
      setState(() {
        _priceRange = const RangeValues(0, 1000);
        _selectedColors = [];
        _selectedSizes = [];
        _filteredProducts = widget.products;
      });
      Navigator.of(context).pop();
  }


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
              initialChildSize: 0.6,
              maxChildSize: 0.9,
              builder: (_, scrollController) => Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('الفلاتر', style: Theme.of(context).textTheme.headlineSmall),
                    const Divider(height: 24),
                    
                    // فلتر السعر
                    Text('السعر (EGP)', style: Theme.of(context).textTheme.titleLarge),
                    RangeSlider(
                      values: _priceRange,
                      min: 0,
                      max: 1000,
                      divisions: 20,
                      labels: RangeLabels('${_priceRange.start.round()}', '${_priceRange.end.round()}'),
                      onChanged: (values) {
                        setSheetState(() => _priceRange = values);
                      },
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
                              if (selected) {
                                _selectedColors.add(color);
                              } else {
                                _selectedColors.remove(color);
                              }
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
                              if (selected) {
                                _selectedSizes.add(size);
                              } else {
                                _selectedSizes.remove(size);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Expanded(child: OutlinedButton(onPressed: _resetFilters, child: const Text('إعادة تعيين'))),
                        const SizedBox(width: 12),
                        Expanded(child: ElevatedButton(onPressed: _applyFilters, child: const Text('تطبيق'))),
                      ],
                    ),
                  ],
                ),
              ),
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
        title: Text(widget.categoryName),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterSheet,
          ),
        ],
      ),
      body: _filteredProducts.isEmpty
          ? const Center(child: Text('لا توجد منتجات تطابق هذه الفلاتر'))
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
                return ProductCard(
                  product: _filteredProducts[index],
                  onCardTap: () { /* Navigate to detail page */ },
                  onAddToCart: () { /* Add to cart logic */ },
                );
              },
            ),
    );
  }
}