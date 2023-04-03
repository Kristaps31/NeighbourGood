import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessage {
  final String message;
  final String id;
  final Timestamp createdAt;

  ChatMessage({
    required this.message,
    required this.id,
    required this.createdAt,
  });

factory ChatMessage.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return ChatMessage(
        id: doc.id, message: data['message'], createdAt: data['created_at']);
  }
}