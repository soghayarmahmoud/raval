import 'package:cloud_firestore/cloud_firestore.dart';

class FAQModel {
  final String id;
  final String question;
  final String answer;
  final int order;
  final String category;
  final Map<String, dynamic> translations;
  final bool isActive;

  FAQModel({
    required this.id,
    required this.question,
    required this.answer,
    required this.order,
    required this.category,
    required this.translations,
    this.isActive = true,
  });

  // Get translated content based on language code
  String getQuestion(String languageCode) {
    if (translations.containsKey(languageCode) &&
        translations[languageCode]['question'] != null) {
      return translations[languageCode]['question'];
    }
    return question; // Default to main question if translation not found
  }

  String getAnswer(String languageCode) {
    if (translations.containsKey(languageCode) &&
        translations[languageCode]['answer'] != null) {
      return translations[languageCode]['answer'];
    }
    return answer; // Default to main answer if translation not found
  }

  Map<String, dynamic> toMap() {
    return {
      'question': question,
      'answer': answer,
      'order': order,
      'category': category,
      'translations': translations,
      'isActive': isActive,
    };
  }

  factory FAQModel.fromMap(Map<String, dynamic> map, String documentId) {
    return FAQModel(
      id: documentId,
      question: map['question'] ?? '',
      answer: map['answer'] ?? '',
      order: map['order'] ?? 0,
      category: map['category'] ?? 'general',
      translations: Map<String, dynamic>.from(map['translations'] ?? {}),
      isActive: map['isActive'] ?? true,
    );
  }

  factory FAQModel.fromFirestore(DocumentSnapshot doc) {
    return FAQModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
  }
}
