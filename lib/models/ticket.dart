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
}
