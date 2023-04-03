import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:neighbour_good/models/chat.dart';
import 'package:neighbour_good/models/chat_message.dart';

class ChatItem extends StatelessWidget {
  final Chat chat;

  const ChatItem({Key? key, required this.chat}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String chatPartnerId =
        chat.sender1 == FirebaseAuth.instance.currentUser!.uid
            ? chat.sender2
            : chat.sender1;
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: Chat.getLastMessage(chat.id),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text("Something went wrong"));
        }
        if (snapshot.hasData) {
          final docs = snapshot.data!.docs[0];
          final ChatMessage chatMessage = ChatMessage.fromFirestore(docs);
          return Container(
            padding: EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
            child: Row(
              children: <Widget>[
                CircleAvatar(
                  backgroundColor: Colors.amber,
                  maxRadius: 30,
                ),
                SizedBox(
                  width: 16,
                ),
                Expanded(
                    child: Container(
                  color: Colors.transparent,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        Text("John Smith"),
                        const SizedBox(width: 110),
                        Text(
                          Jiffy(chatMessage.createdAt.toDate()).fromNow(),
                          style: const TextStyle(
                              color: Color.fromARGB(255, 80, 80, 80),
                              ),
                        ),
                      ]),
                      Text(
                        chatMessage.message,
                        style: TextStyle(
                            fontSize: 14, color: Colors.grey.shade500),
                      ),
                    ],
                  ),
                ))
              ],
            ),
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}


//  Column(
//                         // ignore: prefer_const_literals_to_create_immutables
//                         children: [
//                           // ignore: prefer_const_constructors
//                           CircleAvatar(
//                             backgroundColor: Colors.blueAccent,
//                             maxRadius: 30,
//                           ),
//                           Row(
//                             children: [
//                               Text(chatMessage.message),
//                               Text(chatMessage.createdAt.toDate().toString()),
//                             ],
//                           ),
//                         ],
//                       );