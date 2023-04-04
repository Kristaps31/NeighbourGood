// ignore_for_file: non_constant_identifier_names, deprecated_member_use
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:neighbour_good/models/chat.dart';
import 'package:neighbour_good/screens/chat_screen.dart';
import 'package:neighbour_good/screens/user_posts_screen.dart';
import '/models/user.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

class UserScreen extends StatefulWidget {
  final UserModel user;

  const UserScreen({Key? key, required this.user}) : super(key: key);

  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  late int _commentCount = -1;

  @override
  void initState() {
    super.initState();
    getCommentCount();
  }

  void getCommentCount() {
    UserModel.getVoteCount(widget.user.id).then((data) {
      setState(() {
        _commentCount = data.count;
      });
    }).catchError((error) {
      setState(() {
        _commentCount = 0;
      });
    });
  }

  void increaseCommentCount(int increaseBy) {
    setState(() {
      _commentCount = _commentCount + increaseBy;
    });
  }

  void onTheVoteHandler() {
    UserModel.updateVoteCount(
            widget.user.id, FirebaseAuth.instance.currentUser!.uid)
        .then((data) {
      if (!data.exists) {
        FirebaseFirestore.instance
            .collection('profiles')
            .doc(widget.user.id)
            .collection('upVoters')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .set({})
            .then((value){
              increaseCommentCount(1);
            });
      } else {
            FirebaseFirestore.instance
            .collection('profiles')
            .doc(widget.user.id)
            .collection('upVoters')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .delete()
            .then((value){
              increaseCommentCount(-1);
            });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("User Details")),
        body: Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          Row(
              // ignore: prefer_const_literals_to_create_immutables
              children: [
                // ignore: prefer_const_constructors
                Expanded(
                  child: FittedBox(
                    child: Container(
                      margin: const EdgeInsets.all(4),
                      // ignore: prefer_const_constructors

                      child: CircleAvatar(
                        backgroundImage: NetworkImage(widget.user.img),
                      ),
                    ),
                  ),
                ),
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.user.name,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2.0),
                      child: Text(
                        widget.user.street,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Row(children: [
                      const Text('Member Since: '),
                      Text(
                        DateFormat('dd/MM/yyyy')
                            .format(widget.user.createdAt.toDate()),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      )
                    ]),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Rating: '),
                        Text(_commentCount != -1 ? '$_commentCount' : ' ',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20)),
                        TextButton(
                            onPressed: () {
                              onTheVoteHandler();
                            },
                            child: const Text('👍',
                                style: TextStyle(
                                    fontSize: 20, color: Colors.black))),
                      ],
                    )
                  ],
                ))
              ]),
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(7.0),
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                border: Border.all(
                    width: 2.0,
                    color: Color.fromARGB(255, 186, 182, 182),
                    style: BorderStyle.solid)),
            child: Text('About me: ${widget.user.aboutMe == '' ? 'No info provided' : widget.user.aboutMe}'),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OutlinedButton(
                onPressed: () {
                  final String myId = FirebaseAuth.instance.currentUser!.uid;
                  final String chatId = myId+widget.user.id;
                   Navigator.of(context).push(CupertinoPageRoute(builder: (context)=> ChatScreen(chat: Chat(id: chatId, sender1: myId, sender2: widget.user.id))));
                },
                style: OutlinedButton.styleFrom(
                  primary: Colors.black,
                  side: const BorderSide(color: Colors.purple),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text('Message Neighbour'),
              ),
              const SizedBox(width: 20),
              OutlinedButton(
                onPressed: () {
                  Navigator.of(context).push(CupertinoPageRoute(builder: (context)=> UserPostsScreen(user: widget.user)));
                },
                style: OutlinedButton.styleFrom(
                  primary: Colors.black,
                  side: const BorderSide(color: Colors.purple),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text('Neighbours Posts'),
              ),
            ],
          )
        ])));
  }
}
