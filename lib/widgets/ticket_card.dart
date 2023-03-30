import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:neighbour_good/models/ticket.dart';

import '../models/user.dart';

class TicketCard extends StatelessWidget {
  const TicketCard(
      {Key? key, required this.ticket, required this.user, required this.parentContext})
      : super(key: key);
  final Ticket ticket;
  final UserModel user;
  final BuildContext parentContext;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(0)),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  blurRadius: 1, color: Colors.black.withOpacity(0.2), offset: const Offset(0, 0))
            ]),
        child: Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 8, left: 12, right: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  margin: const EdgeInsets.only(right: 8, top: 0),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    color: Color.fromARGB(255, 231, 231, 231),
                  ),
                  width: 40,
                  height: 40,
                  child: user.profileImgUrl.isEmpty
                      ? Center(
                          child: Text(
                          user.name.isNotEmpty ? user.name[0] : '',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ))
                      : ClipOval(
                          child: SizedBox.fromSize(
                            size: const Size.fromRadius(48), // Image radius
                            child: Image.network(
                              user.profileImgUrl,
                              fit: BoxFit.cover,
                            ),
                          ),
                        )),
              Flexible(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              user.name,
                              style: const TextStyle(
                                color: Color.fromARGB(255, 80, 80, 80),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const Text(' · '),
                            Text(
                              ticket.type == 'help' ? 'asked for help ' : 'offered help ',
                              style: const TextStyle(
                                  color: Color.fromARGB(255, 80, 80, 80), fontSize: 13),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.only(left: 7, right: 7),
                          decoration: BoxDecoration(
                              border: Border.all(width: 1, color: const Color(0xFF6750A4)),
                              borderRadius: const BorderRadius.all(Radius.circular(3))),
                          child: Text(
                            ticket.category,
                            style: const TextStyle(color: Color(0xFF6750A4), fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      Jiffy(ticket.createdAt.toDate()).fromNow(),
                      style: const TextStyle(color: Color.fromARGB(255, 80, 80, 80), fontSize: 13),
                    ),
                    const SizedBox(
                      height: 1,
                    ),
                    Text(
                      ticket.title,
                      style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      ticket.description,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 15),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ticket.ownerId == FirebaseAuth.instance.currentUser!.uid
                            ? Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: SizedBox(
                                  height: 20,
                                  width: 30,
                                  child: TextButton(
                                      style: TextButton.styleFrom(padding: EdgeInsets.zero),
                                      onPressed: () {
                                        ticket.removeTicket(parentContext);
                                      },
                                      child: const Icon(
                                        Icons.delete_forever,
                                        color: Colors.red,
                                        size: 25,
                                      )),
                                ),
                              )
                            : Container(),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
