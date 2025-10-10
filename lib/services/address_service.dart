import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/address_model.dart';

class AddressService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get the collection reference for the current user's addresses
  CollectionReference<Map<String, dynamic>> get _addressesCollection {
    return _firestore
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .collection('addresses');
  }

  // Get all addresses for the current user
  Stream<List<AddressModel>> getAddresses() {
    return _addressesCollection.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => AddressModel.fromFirestore(doc))
          .toList();
    });
  }

  // Add a new address
  Future<String> addAddress(AddressModel address) async {
    final docRef = await _addressesCollection.add(address.toMap());
    return docRef.id;
  }

  // Update an existing address
  Future<void> updateAddress(AddressModel address) async {
    await _addressesCollection.doc(address.id).update(address.toMap());
  }

  // Delete an address
  Future<void> deleteAddress(String addressId) async {
    await _addressesCollection.doc(addressId).delete();
  }

  // Check if user has any saved addresses
  Future<bool> hasAddress() async {
    if (_auth.currentUser == null) return false;

    final snapshot = await _addressesCollection.limit(1).get();
    return snapshot.docs.isNotEmpty;
  }

  // Get the default/primary address if set
  Future<AddressModel?> getDefaultAddress() async {
    if (_auth.currentUser == null) return null;

    final snapshot = await _addressesCollection.limit(1).get();

    if (snapshot.docs.isEmpty) return null;
    return AddressModel.fromFirestore(snapshot.docs.first);
  }
}
