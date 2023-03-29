import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:neighbour_good/models/ticket.dart';

class TicketCard extends StatefulWidget {
  const TicketCard({Key? key, required this.ticket}) : super(key: key);
  final Ticket ticket;

  @override
  State<TicketCard> createState() => _TicketCardState();
}

class _TicketCardState extends State<TicketCard> {
  late String userName = '';

  @override
  void initState() {
    loadUserDetails();
    super.initState();
  }

  void loadUserDetails() {
    FirebaseFirestore.instance
        .collection('profiles')
        .doc(widget.ticket.ownerId)
        .get()
        .then((value) {
      final data = value.data();
      setState(() {
        userName = data!['name'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(6)),
            color: Colors.white,
            boxShadow: [
              BoxShadow(blurRadius: 6, color: Colors.black.withOpacity(0.3))
            ]),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(widget.ticket.title),
                  Text(userName),
                ],
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text(widget.ticket.createdAt.toDate().toString()),
                Text(widget.ticket.category)
              ]),
              Text(widget.ticket.description),
            ],
          ),
        ),
      ),
    );
  }
}
