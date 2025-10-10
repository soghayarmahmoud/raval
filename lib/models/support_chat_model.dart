import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessage {
  final String id;
  final String senderId;
  final String message;
  final DateTime timestamp;
  final bool isAdmin;
  final bool isRead;
  final String? imageUrl;

  ChatMessage({
    required this.id,
    required this.senderId,
    required this.message,
    required this.timestamp,
    required this.isAdmin,
    this.isRead = false,
    this.imageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'message': message,
      'timestamp': timestamp,
      'isAdmin': isAdmin,
      'isRead': isRead,
      'imageUrl': imageUrl,
    };
  }

  factory ChatMessage.fromMap(Map<String, dynamic> map, String documentId) {
    return ChatMessage(
      id: documentId,
      senderId: map['senderId'] ?? '',
      message: map['message'] ?? '',
      timestamp: (map['timestamp'] as Timestamp).toDate(),
      isAdmin: map['isAdmin'] ?? false,
      isRead: map['isRead'] ?? false,
      imageUrl: map['imageUrl'],
    );
  }
}

class SupportTicket {
  final String id;
  final String userId;
  final String status;
  final DateTime createdAt;
  final DateTime? lastUpdated;
  final String? lastMessage;
  final bool isResolved;

  SupportTicket({
    required this.id,
    required this.userId,
    required this.status,
    required this.createdAt,
    this.lastUpdated,
    this.lastMessage,
    this.isResolved = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'status': status,
      'createdAt': createdAt,
      'lastUpdated': lastUpdated ?? createdAt,
      'lastMessage': lastMessage,
      'isResolved': isResolved,
    };
  }

  factory SupportTicket.fromMap(Map<String, dynamic> map, String documentId) {
    return SupportTicket(
      id: documentId,
      userId: map['userId'] ?? '',
      status: map['status'] ?? 'pending',
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      lastUpdated: map['lastUpdated'] != null
          ? (map['lastUpdated'] as Timestamp).toDate()
          : null,
      lastMessage: map['lastMessage'],
      isResolved: map['isResolved'] ?? false,
    );
  }
}
