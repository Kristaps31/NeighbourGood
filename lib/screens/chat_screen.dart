import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:neighbour_good/models/user.dart';
import 'package:neighbour_good/widgets/chat_message_bubble.dart';

import '../models/chat.dart';
import '../models/chat_message.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key, required this.chat}) : super(key: key);
  final Chat chat;

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _messageController = TextEditingController();
  final ScrollController _controller = ScrollController();
  bool _isSendButtonDisabled = true;

  @override
  void initState() {
    super.initState();
    _messageController.addListener(_onMessageChanged);
  }

  void _sendMessage() {
    ChatMessage message = ChatMessage(
        message: _messageController.text,
        id: "",
        createdAt: Timestamp.fromDate(DateTime.now()),
        senderId: FirebaseAuth.instance.currentUser!.uid);
        message.sendMessage(widget.chat.id).then((value) => {
          _messageController.clear(),
          FocusScope.of(context).unfocus(),
        });
  }

  void _onMessageChanged() {
    setState(() {
      _isSendButtonDisabled = _messageController.text.isEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Name"),
      ),
      body: Stack(
        children: [
          StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: widget.chat.getAllMessages(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
          return const Center(child: Text("Something went wrong"));
        }
              if(snapshot.hasData){
                final docs = snapshot.data!.docs;
                return Align(
                  alignment: Alignment.bottomCenter,
                  child: ListView.builder(
                    controller: _controller,
                  padding: EdgeInsets.only(bottom: 70),
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final ChatMessage message = ChatMessage.fromFirestore(docs[index]);
                    
                    return FutureBuilder<UserModel>(
                      future: UserModel.loadUserDetails(message.senderId),
                      builder: (context, snapshot) {
                        if(snapshot.hasData){
                          final UserModel user = snapshot.data!;
                          return ChatMessageBubble(chatMessage: message, user: user,);
                        } return Container();
                        
                      }
                    );
                  },
                              ),
                );
              }
              return const Center(child: CircularProgressIndicator());
            }
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                      width: 0.5, color: Theme.of(context).highlightColor),
                ),
                color: const Color.fromARGB(255, 255, 248, 248),
              ),
              child: Padding(
                  padding: const EdgeInsets.only(
                      left: 10, right: 0, top: 5, bottom: 5),
                  child: Row(
                    children: [
                      Expanded(
                          child: TextFormField(
                        controller: _messageController,
                        maxLines: 4,
                        minLines: 1,
                        decoration: InputDecoration(
                          hintText: 'Type your comment...',
                          hintStyle: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey),
                          contentPadding: const EdgeInsets.all(10),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: const BorderSide(
                              width:
                                  0.5, // Change this value to adjust the border width
                              color: Color.fromARGB(255, 216, 216, 216),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: BorderSide(
                              width:
                                  1, // Change this value to adjust the border width
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: const BorderSide(
                              width:
                                  0.5, // Change this value to adjust the border width
                              color: Color.fromARGB(255, 216, 216, 216),
                            ),
                          ),
                        ),
                      )),
                      TextButton(
                          onPressed: _isSendButtonDisabled
                              ? null
                              : () {
                                  _sendMessage();
                                },
                          child: const Icon(Icons.send))
                    ],
                  )),
            ),
          )
        ],
      ),
    );
  }
}
