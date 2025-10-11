import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ServiceBoxConfig {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final bool isEnabled;
  final Map<String, dynamic> customData;

  ServiceBoxConfig({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    this.isEnabled = true,
    this.customData = const {},
  });

  factory ServiceBoxConfig.fromMap(Map<String, dynamic> map, String id) {
    return ServiceBoxConfig(
      id: id,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      icon:
          IconData(map['iconCodePoint'] ?? 0xe000, fontFamily: 'MaterialIcons'),
      color: Color(map['color'] ?? 0xFF000000),
      isEnabled: map['isEnabled'] ?? true,
      customData: map['customData'] ?? {},
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'iconCodePoint': icon.codePoint,
      'color': color.value,
      'isEnabled': isEnabled,
      'customData': customData,
    };
  }
}

class ServiceBoxService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get all service box configurations
  Stream<List<ServiceBoxConfig>> getServiceBoxConfigs() {
    return _firestore.collection('serviceBoxes').snapshots().map((snapshot) =>
        snapshot.docs
            .map((doc) => ServiceBoxConfig.fromMap(doc.data(), doc.id))
            .toList());
  }

  // Get a specific service box configuration
  Future<ServiceBoxConfig?> getServiceBoxConfig(String id) async {
    final doc = await _firestore.collection('serviceBoxes').doc(id).get();
    if (!doc.exists) return null;
    return ServiceBoxConfig.fromMap(doc.data()!, doc.id);
  }

  // Update a service box configuration
  Future<void> updateServiceBoxConfig(ServiceBoxConfig config) async {
    await _firestore
        .collection('serviceBoxes')
        .doc(config.id)
        .update(config.toMap());
  }

  // Create a new service box configuration
  Future<String> createServiceBoxConfig(ServiceBoxConfig config) async {
    final docRef =
        await _firestore.collection('serviceBoxes').add(config.toMap());
    return docRef.id;
  }

  // Delete a service box configuration
  Future<void> deleteServiceBoxConfig(String id) async {
    await _firestore.collection('serviceBoxes').doc(id).delete();
  }
}
