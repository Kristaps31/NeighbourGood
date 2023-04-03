import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';

import '../models/comment.dart';
import '../models/user.dart';
import '../screens/user_screen.dart';

class TicketComment extends StatelessWidget {
  const TicketComment({
    super.key,
    required this.user,
    required this.comment,
    required this.ticketId,
    required this.parentContext,
  });

  final UserModel user;
  final CommentModel comment;
  final String ticketId;
  final BuildContext parentContext;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => UserScreen(user: user)));
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: CircleAvatar(backgroundImage: NetworkImage(user.img)),
              ),
            ),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                          bottomRight: Radius.circular(10)),
                      color: Color.fromARGB(255, 249, 240, 240),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 6, bottom: 6, left: 8, right: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.name,
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            comment.message,
                            style: const TextStyle(fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Row(
                      children: [
                        Text(
                          Jiffy(comment.createdAt.toDate()).fromNow(),
                          style: const TextStyle(
                              color: Color.fromARGB(255, 80, 80, 80),
                              fontSize: 13),
                        ),
                        if (comment.senderId ==
                            FirebaseAuth.instance.currentUser!.uid)
                          Padding(
                            padding: const EdgeInsets.only(left: 5),
                            child: TextButton(
                              onPressed: () {
                                comment.deleteComment(
                                    ticketId, comment.id, parentContext);
                              },
                              style: TextButton.styleFrom(
                                  padding: const EdgeInsets.only(
                                      top: 0, left: 5, right: 0, bottom: 0),
                                  minimumSize: const Size(50, 30),
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  alignment: Alignment.centerLeft),
                              child: const Text(
                                'delete',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 80, 80, 80)),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
