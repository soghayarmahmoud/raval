import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/support_chat_model.dart';

class SupportChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get or create a support ticket for the current user
  Future<SupportTicket> getOrCreateTicket() async {
    if (_auth.currentUser == null) {
      throw Exception('User must be logged in to access support chat');
    }

    // Check for existing active ticket
    final existingTicketQuery = await _firestore
        .collection('supportTickets')
        .where('userId', isEqualTo: _auth.currentUser!.uid)
        .where('isResolved', isEqualTo: false)
        .limit(1)
        .get();

    if (existingTicketQuery.docs.isNotEmpty) {
      return SupportTicket.fromMap(existingTicketQuery.docs.first.data(),
          existingTicketQuery.docs.first.id);
    }

    // Create new ticket if none exists
    final newTicketRef = await _firestore.collection('supportTickets').add({
      'userId': _auth.currentUser!.uid,
      'status': 'pending',
      'createdAt': FieldValue.serverTimestamp(),
      'lastUpdated': FieldValue.serverTimestamp(),
      'isResolved': false,
    });

    final newTicket = await newTicketRef.get();
    return SupportTicket.fromMap(newTicket.data()!, newTicket.id);
  }

  // Send a message
  Future<void> sendMessage(String ticketId, String message,
      {String? imageUrl}) async {
    if (_auth.currentUser == null) {
      throw Exception('User must be logged in to send messages');
    }

    await _firestore
        .collection('supportTickets')
        .doc(ticketId)
        .collection('messages')
        .add({
      'senderId': _auth.currentUser!.uid,
      'message': message,
      'timestamp': FieldValue.serverTimestamp(),
      'isAdmin': false,
      'isRead': false,
      'imageUrl': imageUrl,
    });

    // Update ticket's last message and timestamp
    await _firestore.collection('supportTickets').doc(ticketId).update({
      'lastMessage': message,
      'lastUpdated': FieldValue.serverTimestamp(),
    });
  }

  // Get messages stream for a ticket
  Stream<List<ChatMessage>> getMessages(String ticketId) {
    return _firestore
        .collection('supportTickets')
        .doc(ticketId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => ChatMessage.fromMap(doc.data(), doc.id))
          .toList();
    });
  }

  // Mark messages as read
  Future<void> markMessagesAsRead(String ticketId) async {
    if (_auth.currentUser == null) return;

    final messages = await _firestore
        .collection('supportTickets')
        .doc(ticketId)
        .collection('messages')
        .where('isRead', isEqualTo: false)
        .where('senderId', isNotEqualTo: _auth.currentUser!.uid)
        .get();

    final batch = _firestore.batch();
    for (var doc in messages.docs) {
      batch.update(doc.reference, {'isRead': true});
    }
    await batch.commit();
  }

  // Close ticket
  Future<void> closeTicket(String ticketId) async {
    await _firestore.collection('supportTickets').doc(ticketId).update({
      'isResolved': true,
      'status': 'resolved',
      'lastUpdated': FieldValue.serverTimestamp(),
    });
  }

  // Get user's ticket history
  Stream<List<SupportTicket>> getTicketHistory() {
    if (_auth.currentUser == null) {
      return Stream.value([]);
    }

    return _firestore
        .collection('supportTickets')
        .where('userId', isEqualTo: _auth.currentUser!.uid)
        .orderBy('lastUpdated', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => SupportTicket.fromMap(doc.data(), doc.id))
          .toList();
    });
  }
}
