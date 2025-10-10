import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/faq_model.dart';

class FAQService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'faqs';

  // Get all FAQs
  Stream<List<FAQModel>> getFAQs() {
    return _firestore
        .collection(_collection)
        .where('isActive', isEqualTo: true)
        .orderBy('order')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => FAQModel.fromFirestore(doc)).toList();
    });
  }

  // Get FAQs by category
  Stream<List<FAQModel>> getFAQsByCategory(String category) {
    return _firestore
        .collection(_collection)
        .where('category', isEqualTo: category)
        .where('isActive', isEqualTo: true)
        .orderBy('order')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => FAQModel.fromFirestore(doc)).toList();
    });
  }

  // Search FAQs
  Future<List<FAQModel>> searchFAQs(String query) async {
    // First, search in default language
    final defaultResults = await _firestore
        .collection(_collection)
        .where('isActive', isEqualTo: true)
        .get();
    
    List<FAQModel> faqs = defaultResults.docs
        .map((doc) => FAQModel.fromFirestore(doc))
        .where((faq) {
          return faq.question.toLowerCase().contains(query.toLowerCase()) ||
                 faq.answer.toLowerCase().contains(query.toLowerCase());
        })
        .toList();

    // Then search in translations
    final translationResults = await _firestore
        .collection(_collection)
        .where('isActive', isEqualTo: true)
        .get();
    
    // Add results from translations if not already found
    translationResults.docs.forEach((doc) {
      var faq = FAQModel.fromFirestore(doc);
      if (!faqs.any((f) => f.id == faq.id)) {
        bool foundInTranslations = false;
        faq.translations.forEach((lang, content) {
          if ((content['question']?.toString().toLowerCase() ?? '').contains(query.toLowerCase()) ||
              (content['answer']?.toString().toLowerCase() ?? '').contains(query.toLowerCase())) {
            foundInTranslations = true;
          }
        });
        if (foundInTranslations) {
          faqs.add(faq);
        }
      }
    });

    return faqs;
  }
}