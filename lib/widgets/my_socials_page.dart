import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:neighbour_good/models/chat.dart';
import 'package:neighbour_good/widgets/chat_item.dart';

class MySocialsPage extends StatelessWidget {
  const MySocialsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SafeArea(
                    child: Padding(
                  padding: EdgeInsets.only(left: 16, right: 16, top: 10),
                )),
                // Padding(
                //   padding: EdgeInsets.all(16.0),
                //   child: TextField(
                //     decoration: InputDecoration(
                //         hintText: "Search...",
                //         hintStyle: TextStyle(color: Colors.grey.shade400),
                //         prefixIcon: Icon(Icons.search,
                //             color: Colors.grey.shade400, size: 20),
                //         filled: true,
                //         fillColor: Colors.grey.shade100,
                //         contentPadding: EdgeInsets.all(8),
                //         enabledBorder: OutlineInputBorder(
                //             borderRadius: BorderRadius.circular(30),
                //             borderSide:
                //                 BorderSide(color: Colors.grey.shade100))),
                //   ),
                // ),
                StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream:
                      Chat.getChatList(FirebaseAuth.instance.currentUser!.uid),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Center(child: Text("Something went wrong"));
                    }
                    if (snapshot.hasData) {
                      final docs = snapshot.data!.docs;
                      return ListView.builder(
                        itemCount: docs.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          final Chat chat = Chat.fromFirestore(docs[index]);
                          return ChatItem(chat: chat);
                        },
                      );
                    }
                    return const Center(child: CircularProgressIndicator());
                  },
                )
              ])),
    );
  }
}
