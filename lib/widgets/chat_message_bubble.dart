import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:neighbour_good/models/chat_message.dart';
import 'package:neighbour_good/models/user.dart';

import '../screens/user_screen.dart';

class ChatMessageBubble extends StatelessWidget {
  final ChatMessage chatMessage;
  final UserModel user;

  const ChatMessageBubble(
      {Key? key, required this.chatMessage, required this.user})
      : super(key: key);

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
                            chatMessage.message,
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
                          Jiffy(chatMessage.createdAt.toDate()).fromNow(),
                          style: const TextStyle(
                              color: Color.fromARGB(255, 80, 80, 80),
                              fontSize: 13),
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
