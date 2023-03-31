import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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

  Future<void> removeTicket(BuildContext context) {
    return FirebaseFirestore.instance
        .collection('tickets')
        .doc(id)
        .delete()
        .then((value) => {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("Your $type has been successfully deleted!"),
              ))
            })
        .catchError((e) => {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("Something went wrong!"),
              ))
            });
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> listenToTicketStatus() {
    return FirebaseFirestore.instance.collection('tickets').doc(id).snapshots();
  }

  void changeTicketStatus() {
    FirebaseFirestore.instance
        .collection('tickets')
        .doc(id)
        .update({'is_opened': !isOpen}).then((value) {
      isOpen = !isOpen;
    });
  }
}
