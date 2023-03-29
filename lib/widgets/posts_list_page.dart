import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:neighbour_good/models/ticket.dart';
import 'package:neighbour_good/widgets/ticket_Card.dart';

class PostsListPage extends StatefulWidget {
  final String type;

  const PostsListPage({Key? key, required this.type}) : super(key: key);

  @override
  State<PostsListPage> createState() => _PostsListPageState();
}

class _PostsListPageState extends State<PostsListPage> {
  String typeField = '';
  String equalTo = '';

  @override
  void initState() {
    super.initState();

    if (widget.type == 'offers') {
      typeField = 'type';
      equalTo = 'offer';
    }
    if (widget.type == 'pledges') {
      typeField = 'type';
      equalTo = 'help';
    }
    if (widget.type == 'my_posts') {
      typeField = 'owner_id';
      equalTo = FirebaseAuth.instance.currentUser?.uid ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('tickets')
          .orderBy('created_at', descending: true)
          .where(typeField, isEqualTo: equalTo)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) return Text('Error = ${snapshot.error}');

        if (snapshot.hasData) {
          final docs = snapshot.data!.docs;
          return Padding(
            padding: const EdgeInsets.only(top: 10),
            child: ListView.builder(
                padding: const EdgeInsets.only(bottom: 70),
                itemCount: docs.length,
                itemBuilder: (context, index) {
                  final data = docs[index].data();
                  Ticket ticket = Ticket(
                      id: docs[index].id,
                      category: data['category'],
                      createdAt: data['created_at'],
                      description: data['description'],
                      ownerId: data['owner_id'],
                      isOpen: data['is_opened'] ?? true,
                      title: data['title'],
                      type: data['type']);

                  return TicketCard(
                    ticket: ticket,
                  );
                }),
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
