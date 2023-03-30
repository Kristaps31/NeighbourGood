import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:neighbour_good/models/ticket.dart';
import 'package:neighbour_good/models/user.dart';
import 'package:neighbour_good/widgets/ticket_card.dart';

class PostsListPage extends StatelessWidget {
  final String type;

  const PostsListPage({Key? key, required this.type}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String typeField = '';
    String equalTo = '';

    if (type == 'offers') {
      typeField = 'type';
      equalTo = 'offer';
    }
    if (type == 'pledges') {
      typeField = 'type';
      equalTo = 'help';
    }
    if (type == 'my_posts') {
      typeField = 'owner_id';
      equalTo = FirebaseAuth.instance.currentUser?.uid ?? '';
    }

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

          return ListView.builder(
              padding: const EdgeInsets.only(bottom: 70, top: 12),
              itemCount: docs.length,
              itemBuilder: (context, index) {
                final data = docs[index];
                Ticket ticket = Ticket.fromFirestore(data);

                return FutureBuilder<UserModel>(
                  future: UserModel.loadUserDetails(ticket.ownerId),
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.data!.name != '') {
                      return TicketCard(
                        ticket: ticket,
                        user: snapshot.data!,
                      );
                    } else {
                      return Container();
                    }
                  },
                );
              });
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
