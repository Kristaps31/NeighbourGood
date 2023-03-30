import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:neighbour_good/models/comment.dart';
import 'package:neighbour_good/models/user.dart';
import 'package:neighbour_good/widgets/ticket_card.dart';
import 'package:neighbour_good/widgets/ticket_comments.dart';

import '../models/ticket.dart';

class TicketDetailsScreen extends StatefulWidget {
  const TicketDetailsScreen({Key? key, required this.ticket, required this.user}) : super(key: key);

  final Ticket ticket;
  final UserModel user;

  @override
  State<TicketDetailsScreen> createState() => _TicketDetailsScreenState();
}

class _TicketDetailsScreenState extends State<TicketDetailsScreen> {
  final _messageController = TextEditingController();
  bool _isSendButtonDisabled = true;

  @override
  void initState() {
    super.initState();
    _messageController.addListener(_onMessageChanged);
  }

  void _onMessageChanged() {
    setState(() {
      _isSendButtonDisabled = _messageController.text.isEmpty;
    });
  }

  _sendMessage(BuildContext context) {
    CommentModel.createNew(
            senderId: FirebaseAuth.instance.currentUser != null
                ? FirebaseAuth.instance.currentUser!.uid
                : '',
            message: _messageController.text)
        .addComment(widget.ticket.id)
        .then((value) {
      _messageController.text = '';
      FocusScope.of(context).unfocus();
    }).catchError((value) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Something went wrong...')));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.ticket.title),
        elevation: 2,
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Stack(
          children: [
            SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 10),
                physics: const ScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TicketCard(
                      ticket: widget.ticket,
                      user: widget.user,
                      isExpanded: true,
                    ),
                    TicketComments(ticketId: widget.ticket.id)
                  ],
                )),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(width: 0.5, color: Color.fromARGB(255, 204, 204, 204)),
                  ),
                  color: Color.fromARGB(255, 245, 245, 245),
                ),
                child: Padding(
                    padding: const EdgeInsets.only(left: 10, right: 0, top: 5, bottom: 5),
                    child: Row(
                      children: [
                        Expanded(
                            child: TextFormField(
                          controller: _messageController,
                          maxLines: null,
                          decoration: InputDecoration(
                            hintText: 'Type your comment...',
                            hintStyle: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w400, color: Colors.grey),
                            contentPadding: const EdgeInsets.all(6),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                width: 1.0, // Change this value to adjust the border width
                                color: Color.fromARGB(255, 235, 235, 235),
                              ),
                            ),
                          ),
                        )),
                        TextButton(
                            onPressed: _isSendButtonDisabled
                                ? null
                                : () {
                                    _sendMessage(context);
                                  },
                            child: const Icon(Icons.send))
                      ],
                    )),
              ),
            )
          ],
        ),
      ),
    );
  }
}
