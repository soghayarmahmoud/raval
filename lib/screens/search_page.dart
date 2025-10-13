import 'package:flutter/material.dart';
import 'package:store/l10n/app_localizations.dart';
import 'package:store/models/product_model.dart';
import 'package:store/screens/home_page.dart';
import 'package:store/screens/product_detail_page.dart';
import 'package:store/services/cart_service.dart';
import 'package:store/utils/navigation_util.dart';

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
  
  final List<String> _availableSizes = ['S', 'M', 'L', 'XL'];
  bool _didLoadProducts = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_applyAllFilters);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_didLoadProducts) {
      _loadAllProducts();
      _didLoadProducts = true;
    }
  }

  @override
  void dispose() {
    _searchController.removeListener(_applyAllFilters);
    _searchController.dispose();
    super.dispose();
  }

  void _loadAllProducts() {
    final loc = AppLocalizations.of(context)!;
    final products = [..._dataService.getNewArrivals(loc), ..._dataService.getBestOffers(loc)];
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

  void _showFilterSheet() {
    final loc = AppLocalizations.of(context)!;
    final List<String> _availableColors = [loc.colorPink, loc.colorWhite, loc.colorBlue, loc.colorBlack, loc.colorGreen];

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
              initialChildSize: 0.7,
              maxChildSize: 0.9,
              builder: (_, scrollController) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
                  child: Column(
                    children: [
                      Text(loc.filters, style: Theme.of(context).textTheme.headlineSmall),
                      const Divider(height: 24),
                      Expanded(
                        child: ListView( 
                          controller: scrollController, 
                          children: [
                            Text(loc.priceKWD, style: Theme.of(context).textTheme.titleLarge),
                            RangeSlider(
                              values: _priceRange,
                              min: 0,
                              max: 1000,
                              divisions: 20,
                              labels: RangeLabels('${_priceRange.start.round()}', '${_priceRange.end.round()}'),
                              onChanged: (values) => setSheetState(() => _priceRange = values),
                            ),
                            const SizedBox(height: 24),
                            Text(loc.color, style: Theme.of(context).textTheme.titleLarge),
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
                            Text(loc.size, style: Theme.of(context).textTheme.titleLarge),
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
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(child: OutlinedButton(onPressed: _resetFilters, child: Text(loc.reset))),
                          const SizedBox(width: 12),
                          Expanded(child: ElevatedButton(onPressed: () {
                            _applyAllFilters();
                            Navigator.of(context).pop();
                          }, child: Text(loc.apply))),
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: loc.searchForYourFavoriteProducts,
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
          ? Center(child: Text(loc.noProductsMatchFilters))
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
                     navigateWithLoading(context, ProductDetailPage(product: product));
                  },
                  onAddToCart: () {
                     final cartService = CartService();
                     cartService.addToCart(product, 1);
                     ScaffoldMessenger.of(context).showSnackBar(
                       SnackBar(content: Text(loc.addedXToCart(product.name)))
                     );
                  },
                );
              },
            ),
    );
  }
}