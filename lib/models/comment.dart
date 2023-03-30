import 'package:cloud_firestore/cloud_firestore.dart';

class CommentModel {
  final String id;
  final String senderId;
  final Timestamp createdAt;
  final String message;

  CommentModel({
    required this.id,
    required this.senderId,
    required this.createdAt,
    required this.message,
  });

  CommentModel.createNew({
    this.id = '',
    required this.senderId,
    Timestamp? createdAt,
    required this.message,
  }) : createdAt = createdAt ?? Timestamp.now();

  factory CommentModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return CommentModel(
      id: doc.id,
      senderId: data['sender_id'],
      createdAt: data['created_at'],
      message: data['message'],
    );
  }

  Map<String, dynamic> toFirestore() => {
        'sender_id': senderId,
        'created_at': createdAt,
        'message': message,
      };

  Future<DocumentReference<Map<String, dynamic>>> addComment(String ticketId) {
    return FirebaseFirestore.instance
        .collection('tickets')
        .doc(ticketId)
        .collection('comments')
        .add(toFirestore());
  }
}
