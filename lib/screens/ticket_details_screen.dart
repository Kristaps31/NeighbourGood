import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:neighbour_good/models/comment.dart';
import 'package:neighbour_good/models/user.dart';
import 'package:neighbour_good/widgets/ticket_card.dart';
import 'package:neighbour_good/widgets/ticket_comments.dart';

import '../models/ticket.dart';

class TicketDetailsScreen extends StatefulWidget {
  const TicketDetailsScreen(
      {Key? key, required this.ticket, required this.user, required this.commentCount})
      : super(key: key);

  final Ticket ticket;
  final UserModel user;
  final int commentCount;

  @override
  State<TicketDetailsScreen> createState() => _TicketDetailsScreenState();
}

class _TicketDetailsScreenState extends State<TicketDetailsScreen> {
  final ScrollController _scrollController = ScrollController();
  final _messageController = TextEditingController();
  late Stream<DocumentSnapshot<Map<String, dynamic>>> _stream;
  late bool _isOpened = widget.ticket.isOpen;

  final double _appBarVisibleHeight = 15.0;

  bool _isSendButtonDisabled = true;
  bool _isAppBarVisible = false;

  @override
  void initState() {
    super.initState();
    _messageController.addListener(_onMessageChanged);
    _scrollController.addListener(_onScroll);

    _stream = widget.ticket.listenToTicketStatus();
    _stream.listen((DocumentSnapshot<Map<String, dynamic>> querySnapshot) {
      if (mounted) {
        setState(() {
          _isOpened = querySnapshot.data()!['is_opened'] ?? true;
        });
      }
    });
  }

  void _onScroll() {
    if (_scrollController.offset > _appBarVisibleHeight && !_isAppBarVisible) {
      setState(() {
        _isAppBarVisible = true;
      });
    } else if (_scrollController.offset <= _appBarVisibleHeight && _isAppBarVisible) {
      setState(() {
        _isAppBarVisible = false;
      });
    }
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
            message: _messageController.text.trim())
        .addComment(widget.ticket.id)
        .then((value) {
      _messageController.clear();
      FocusScope.of(context).unfocus();
    }).catchError((value) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Something went wrong...')));
    });
  }

  @override
  void dispose() {
    super.dispose();
    _stream.drain();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(_isAppBarVisible
            ? widget.ticket.type == 'help'
                ? 'Help request'
                : 'Offer'
            : ''),
        actions: [
          Visibility(
            visible: FirebaseAuth.instance.currentUser!.uid == widget.ticket.ownerId,
            child: TextButton(
                child: Text(_isOpened == true ? 'Mark as closed' : 'Reopen'),
                onPressed: () {
                  widget.ticket.changeTicketStatus();
                }),
          )
        ],
        elevation: 0,
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Stack(
          children: [
            SingleChildScrollView(
                controller: _scrollController,
                padding: const EdgeInsets.only(bottom: 10),
                physics: const ScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TicketCard(
                      ticket: widget.ticket,
                      user: widget.user,
                      isExpanded: true,
                      commentCount: widget.commentCount,
                      parentContext: context,
                    ),
                    TicketComments(ticketId: widget.ticket.id)
                  ],
                )),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(width: 0.5, color: Theme.of(context).highlightColor),
                  ),
                  color: const Color.fromARGB(255, 255, 248, 248),
                ),
                child: Padding(
                    padding: const EdgeInsets.only(left: 10, right: 0, top: 5, bottom: 5),
                    child: !_isOpened
                        ? SizedBox(
                            height: 47.5,
                            width: double.infinity,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Text('This thread is closed'),
                              ],
                            ),
                          )
                        : Row(
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
                                      width: 0.5, // Change this value to adjust the border width
                                      color: Color.fromARGB(255, 216, 216, 216),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(24),
                                    borderSide: BorderSide(
                                      width: 1, // Change this value to adjust the border width
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(24),
                                    borderSide: const BorderSide(
                                      width: 0.5, // Change this value to adjust the border width
                                      color: Color.fromARGB(255, 216, 216, 216),
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
