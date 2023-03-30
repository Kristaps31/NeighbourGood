import 'package:cloud_firestore/cloud_firestore.dart';

class Ticket {
  String id;
  String category;
  Timestamp createdAt;
  String description;
  bool isOpen;
  String ownerId;
  String title;
  String type;

  Ticket(
      {required this.id,
      required this.category,
      required this.createdAt,
      required this.description,
      required this.ownerId,
      required this.isOpen,
      required this.title,
      required this.type});

  factory Ticket.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Ticket(
        id: doc.id,
        category: data['category'],
        createdAt: data['created_at'],
        description: data['description'],
        ownerId: data['owner_id'],
        isOpen: data['is_opened'] ?? true,
        title: data['title'],
        type: data['type']);
  }
}