import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessage {
  final String message;
  final String id;
  final Timestamp createdAt;
  final String senderId;
  final String neighbourId;

  ChatMessage({
    required this.message,
    required this.id,
    required this.createdAt,
    required this.senderId,
    this.neighbourId = '',
  });

  factory ChatMessage.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return ChatMessage(
        id: doc.id,
        message: data['message'],
        createdAt: data['created_at'],
        senderId: data['sender']);
  }

  Map<String, dynamic> toFirestore() => {
        'sender': senderId,
        'created_at': createdAt,
        'message': message.trim(),
      };

  Future<DocumentReference<Map<String, dynamic>>> sendMessage(String chatId) async {
    return FirebaseFirestore.instance
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .add(toFirestore());
  }
}
