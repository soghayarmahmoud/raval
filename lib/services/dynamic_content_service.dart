import 'package:cloud_firestore/cloud_firestore.dart';

class DynamicContentService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'app_content';

  // Get content for a specific key and language
  Future<String> getContent(String key, String languageCode) async {
    try {
      final doc = await _firestore.collection(_collection).doc(key).get();

      if (!doc.exists) {
        return key; // Return the key if content doesn't exist
      }

      final data = doc.data() as Map<String, dynamic>;

      // Check for translation
      if (data.containsKey('translations') &&
          (data['translations'] as Map<String, dynamic>)
              .containsKey(languageCode)) {
        return data['translations'][languageCode];
      }

      // Return default content if translation not found
      return data['defaultContent'] ?? key;
    } catch (e) {
      return key; // Return the key in case of error
    }
  }

  // Get all content for a specific language
  Future<Map<String, String>> getAllContent(String languageCode) async {
    try {
      final snapshot = await _firestore.collection(_collection).get();

      Map<String, String> content = {};
      for (var doc in snapshot.docs) {
        final data = doc.data();
        if (data.containsKey('translations') &&
            (data['translations'] as Map<String, dynamic>)
                .containsKey(languageCode)) {
          content[doc.id] = data['translations'][languageCode];
        } else {
          content[doc.id] = data['defaultContent'] ?? doc.id;
        }
      }

      return content;
    } catch (e) {
      return {};
    }
  }

  // Stream of content changes for a specific key and language
  Stream<String> contentStream(String key, String languageCode) {
    return _firestore.collection(_collection).doc(key).snapshots().map((doc) {
      if (!doc.exists) return key;

      final data = doc.data() as Map<String, dynamic>;

      if (data.containsKey('translations') &&
          (data['translations'] as Map<String, dynamic>)
              .containsKey(languageCode)) {
        return data['translations'][languageCode];
      }

      return data['defaultContent'] ?? key;
    });
  }

  // Stream of all content changes for a specific language
  Stream<Map<String, String>> allContentStream(String languageCode) {
    return _firestore.collection(_collection).snapshots().map((snapshot) {
      Map<String, String> content = {};
      for (var doc in snapshot.docs) {
        final data = doc.data();
        if (data.containsKey('translations') &&
            (data['translations'] as Map<String, dynamic>)
                .containsKey(languageCode)) {
          content[doc.id] = data['translations'][languageCode];
        } else {
          content[doc.id] = data['defaultContent'] ?? doc.id;
        }
      }
      return content;
    });
  }
}
