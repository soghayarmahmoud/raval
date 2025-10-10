import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product_model.dart';

class ProductService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'products';

  // Get a single product by ID
  Stream<ProductModel> getProduct(String productId) {
    return _firestore
        .collection(_collection)
        .doc(productId)
        .snapshots()
        .map((doc) => ProductModel.fromJson(doc.data() as Map<String, dynamic>));
  }

  // Get products by category
  Stream<List<ProductModel>> getProductsByCategory(String category) {
    return _firestore
        .collection(_collection)
        .where('category', isEqualTo: category)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => ProductModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    });
  }

  // Get all products
  Stream<List<ProductModel>> getAllProducts() {
    return _firestore.collection(_collection).snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => ProductModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    });
  }

  // Search products
  Stream<List<ProductModel>> searchProducts(String query) {
    // Convert query to lowercase for case-insensitive search
    query = query.toLowerCase();
    return _firestore.collection(_collection).snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => ProductModel.fromJson(doc.data() as Map<String, dynamic>))
          .where((product) {
        return product.name.toLowerCase().contains(query) ||
            product.description.toLowerCase().contains(query) ||
            product.tags.any((tag) => tag.toLowerCase().contains(query));
      }).toList();
    });
  }

  // Get featured products
  Stream<List<ProductModel>> getFeaturedProducts() {
    return _firestore
        .collection(_collection)
        .where('isFeatured', isEqualTo: true)
        .limit(10)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => ProductModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    });
  }

  // Get latest products
  Stream<List<ProductModel>> getLatestProducts() {
    return _firestore
        .collection(_collection)
        .orderBy('createdAt', descending: true)
        .limit(10)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => ProductModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    });
  }

  // Get related products
  Stream<List<ProductModel>> getRelatedProducts(
      String category, String currentProductId) {
    return _firestore
        .collection(_collection)
        .where('category', isEqualTo: category)
        .where(FieldPath.documentId, isNotEqualTo: currentProductId)
        .limit(5)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => ProductModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    });
  }
}
