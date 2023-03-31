import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/comment.dart';
import '../models/user.dart';
import 'ticket_comment.dart';

class TicketComments extends StatelessWidget {
  const TicketComments({Key? key, required this.ticketId}) : super(key: key);
  final String ticketId;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('tickets')
          .doc(ticketId)
          .collection('comments')
          .orderBy('created_at', descending: true)
          .snapshots(),
      builder: (parentContext, snapshot) {
        if (snapshot.hasError) return const Text('Something went wrong..');

        if (snapshot.hasData) {
          final docs = snapshot.data!.docs;

          if (docs.isEmpty) {
            return const Padding(
              padding: EdgeInsets.only(top: 25),
              child: Center(child: Text('No comments yet')),
            );
          }

          return ListView.builder(
              padding: const EdgeInsets.only(bottom: 70, top: 12),
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: docs.length,
              itemBuilder: (context, index) {
                final data = docs[index];
                CommentModel comment = CommentModel.fromFirestore(data);

                return FutureBuilder<UserModel>(
                  future: UserModel.loadUserDetails(comment.senderId),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      UserModel user = snapshot.data!;

                      return TicketComment(
                          user: user,
                          comment: comment,
                          ticketId: ticketId,
                          parentContext: parentContext);
                    } else {
                      return TicketComment(
                          user: UserModel.empty(),
                          comment: comment,
                          ticketId: ticketId,
                          parentContext: parentContext);
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
