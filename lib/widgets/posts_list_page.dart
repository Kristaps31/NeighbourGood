import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:neighbour_good/models/ticket.dart';
import 'package:neighbour_good/models/user.dart';
import 'package:neighbour_good/widgets/ticket_card.dart';
import 'package:tuple/tuple.dart';

import '../models/comment.dart';

class PostsListPage extends StatelessWidget {
  final String type;

  const PostsListPage({Key? key, required this.type}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String typeField = '';
    String equalTo = '';
    String emptyListMessage = '';

    if (type == 'offers') {
      typeField = 'type';
      equalTo = 'offer';
      emptyListMessage = 'No help offers from your neighbours yet';
    }
    if (type == 'pledges') {
      typeField = 'type';
      equalTo = 'help';
      emptyListMessage = 'No help requests from your neighbours yet';
    }
    if (type == 'my_posts') {
      typeField = 'owner_id';
      equalTo = FirebaseAuth.instance.currentUser?.uid ?? '';
      emptyListMessage = "You don't have any posts yet";
    }

    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('tickets')
          .orderBy('created_at', descending: true)
          .where(typeField, isEqualTo: equalTo)
          .snapshots(),
      builder: (parentContext, snapshot) {
        if (snapshot.hasError) return Text('Error = ${snapshot.error}');

        if (snapshot.hasData) {
          final docs = snapshot.data!.docs;

          if (docs.isEmpty) {
            return Center(child: Text(emptyListMessage));
          }

          return ListView.builder(
              padding: const EdgeInsets.only(bottom: 70),
              itemCount: docs.length,
              itemBuilder: (context, index) {
                final data = docs[index];
                Ticket ticket = Ticket.fromFirestore(data);

                Future<Tuple2<UserModel, int>> combinedFuture = Future.wait([
                  UserModel.loadUserDetails(ticket.ownerId),
                  CommentModel.getCommentCount(ticket.id)
                ]).then((results) =>
                    Tuple2<UserModel, int>(results[0] as UserModel, results[1] as int));

                return FutureBuilder<Tuple2<UserModel, int>>(
                  future: combinedFuture,
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.data!.item1.name != '') {
                      UserModel user = snapshot.data!.item1;
                      int commentCount = snapshot.data!.item2;

                      return TicketCard(
                        ticket: ticket,
                        user: user,
                        commentCount: commentCount,
                        parentContext: parentContext,
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
