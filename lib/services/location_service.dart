import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BranchLocation {
  final String? id;
  final String name;
  final String address;
  final String phone;
  final String workingHours;
  final double latitude;
  final double longitude;
  final String governorate;
  final bool isCustom;
  final String? userId;

  BranchLocation({
    this.id,
    required this.name,
    required this.address,
    required this.phone,
    required this.workingHours,
    required this.latitude,
    required this.longitude,
    required this.governorate,
    this.isCustom = false,
    this.userId,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'address': address,
      'phone': phone,
      'workingHours': workingHours,
      'latitude': latitude,
      'longitude': longitude,
      'governorate': governorate,
      'isCustom': isCustom,
      'userId': userId,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }

  factory BranchLocation.fromMap(Map<String, dynamic> map, String id) {
    return BranchLocation(
      id: id,
      name: map['name'] ?? '',
      address: map['address'] ?? '',
      phone: map['phone'] ?? '',
      workingHours: map['workingHours'] ?? '',
      latitude: map['latitude']?.toDouble() ?? 0.0,
      longitude: map['longitude']?.toDouble() ?? 0.0,
      governorate: map['governorate'] ?? '',
      isCustom: map['isCustom'] ?? false,
      userId: map['userId'],
    );
  }
}

class LocationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get all branches including system and user-created ones
  Stream<List<BranchLocation>> getBranches() {
    return _firestore
        .collection('branches')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => BranchLocation.fromMap(doc.data(), doc.id))
            .toList());
  }

  // Get branches for a specific governorate
  Stream<List<BranchLocation>> getBranchesByGovernorate(String governorate) {
    return _firestore
        .collection('branches')
        .where('governorate', isEqualTo: governorate)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => BranchLocation.fromMap(doc.data(), doc.id))
            .toList());
  }

  // Get user's custom branches
  Stream<List<BranchLocation>> getUserBranches() {
    final user = _auth.currentUser;
    if (user == null) return Stream.value([]);

    return _firestore
        .collection('branches')
        .where('userId', isEqualTo: user.uid)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => BranchLocation.fromMap(doc.data(), doc.id))
            .toList());
  }

  // Add a new branch location
  Future<void> addBranch(BranchLocation branch) async {
    final user = _auth.currentUser;
    if (branch.isCustom && user == null) {
      throw Exception('User must be logged in to add custom branches');
    }

    await _firestore.collection('branches').add(branch.toMap());
  }

  // Update an existing branch location
  Future<void> updateBranch(BranchLocation branch) async {
    if (branch.id == null) throw Exception('Branch ID cannot be null');

    final user = _auth.currentUser;
    if (branch.isCustom && user == null) {
      throw Exception('User must be logged in to update custom branches');
    }

    if (branch.isCustom && branch.userId != user?.uid) {
      throw Exception('User can only update their own custom branches');
    }

    await _firestore
        .collection('branches')
        .doc(branch.id)
        .update(branch.toMap());
  }

  // Delete a branch location
  Future<void> deleteBranch(String branchId) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('User must be logged in to delete branches');
    }

    final branch = await _firestore.collection('branches').doc(branchId).get();
    if (!branch.exists) throw Exception('Branch not found');

    final branchData = branch.data();
    if (branchData?['isCustom'] == true && branchData?['userId'] != user.uid) {
      throw Exception('User can only delete their own custom branches');
    }

    await _firestore.collection('branches').doc(branchId).delete();
  }
}
