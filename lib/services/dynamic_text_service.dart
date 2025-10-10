import 'package:cloud_firestore/cloud_firestore.dart';

class DynamicTextService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'dynamic_text';

  Stream<Map<String, String>> getTexts(String locale) {
    return _firestore
        .collection(_collection)
        .doc(locale)
        .snapshots()
        .map((doc) {
      if (!doc.exists) return {};
      final data = doc.data() as Map<String, dynamic>;
      return data.map((key, value) => MapEntry(key, value.toString()));
    });
  }

  Future<void> updateText(String locale, String key, String value) async {
    await _firestore.collection(_collection).doc(locale).set({
      key: value,
    }, SetOptions(merge: true));
  }
}
