class ProductModel {
  final String id;
  final String name;
  final String description;
  final double price;
  final double? salePrice;
  final String imageUrl;
  final List<String> images;
  final List<String> tags;
  final List<String> availableSizes;
  final List<String> availableColors;
  final Map<String, String> additionalInfo;
  bool isFavorite;
  final int stock;
  final double rating;
  final int reviewCount;
  final String category;
  final DateTime? createdAt;
  final List<String> otherImages;
  final List<String> sizes;
  final List<String> colors;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.salePrice,
    required this.imageUrl,
    this.images = const [],
    this.tags = const [],
    this.availableSizes = const [],
    this.availableColors = const [],
    this.additionalInfo = const {},
    this.isFavorite = false,
    this.stock = 0,
    this.rating = 0.0,
    this.reviewCount = 0,
    this.category = '',
    this.createdAt,
    this.otherImages = const [],
    this.sizes = const [],
    this.colors = const [],
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'price': price,
        'salePrice': salePrice,
        'imageUrl': imageUrl,
        'images': images,
        'tags': tags,
        'availableSizes': availableSizes,
        'availableColors': availableColors,
        'additionalInfo': additionalInfo,
        'isFavorite': isFavorite,
        'stock': stock,
        'rating': rating,
        'reviewCount': reviewCount,
        'category': category,
        'createdAt': createdAt?.toIso8601String(),
        'otherImages': otherImages,
        'sizes': sizes,
        'colors': colors,
      };

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        id: json['id'] as String,
        name: json['name'] as String,
        description: json['description'] as String? ?? '',
        price: (json['price'] as num).toDouble(),
        salePrice: (json['salePrice'] as num?)?.toDouble(),
        imageUrl: json['imageUrl'] as String? ?? '',
        images: List<String>.from(json['images'] ?? []),
        tags: List<String>.from(json['tags'] ?? []),
        availableSizes: List<String>.from(json['availableSizes'] ?? []),
        availableColors: List<String>.from(json['availableColors'] ?? []),
        additionalInfo: Map<String, String>.from(json['additionalInfo'] ?? {}),
        isFavorite: json['isFavorite'] as bool? ?? false,
        stock: json['stock'] as int? ?? 0,
        rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
        reviewCount: json['reviewCount'] as int? ?? 0,
        category: json['category'] as String? ?? '',
        createdAt: json['createdAt'] != null
            ? DateTime.parse(json['createdAt'] as String)
            : null,
        otherImages: List<String>.from(json['otherImages'] ?? []),
        sizes: List<String>.from(json['sizes'] ?? []),
        colors: List<String>.from(json['colors'] ?? []),
      );

  ProductModel copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    double? salePrice,
    String? imageUrl,
    List<String>? images,
    List<String>? tags,
    List<String>? availableSizes,
    List<String>? availableColors,
    Map<String, String>? additionalInfo,
    bool? isFavorite,
    int? stock,
    double? rating,
    int? reviewCount,
    String? category,
    DateTime? createdAt,
    List<String>? otherImages,
    List<String>? sizes,
    List<String>? colors,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      salePrice: salePrice ?? this.salePrice,
      imageUrl: imageUrl ?? this.imageUrl,
      images: images ?? this.images,
      tags: tags ?? this.tags,
      availableSizes: availableSizes ?? this.availableSizes,
      availableColors: availableColors ?? this.availableColors,
      additionalInfo: additionalInfo ?? this.additionalInfo,
      isFavorite: isFavorite ?? this.isFavorite,
      stock: stock ?? this.stock,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      category: category ?? this.category,
      createdAt: createdAt ?? this.createdAt,
      otherImages: otherImages ?? this.otherImages,
      sizes: sizes ?? this.sizes,
      colors: colors ?? this.colors,
    );
  }
}
