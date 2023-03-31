import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:neighbour_good/models/comment.dart';
import 'package:neighbour_good/models/ticket.dart';
import 'package:neighbour_good/widgets/report_issue_screen.dart';
import 'package:neighbour_good/screens/ticket_details_screen.dart';

import '../models/user.dart';

class TicketCard extends StatelessWidget {
  const TicketCard(
      {Key? key,
      required this.ticket,
      required this.user,
      this.commentCount = 0,
      this.isExpanded = false,
      required this.parentContext})
      : super(key: key);
  final Ticket ticket;
  final UserModel user;
  final bool isExpanded;
  final int commentCount;
  final BuildContext parentContext;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 0),
      child: InkWell(
        onTap: () {
          FocusScope.of(context).unfocus();

          if (!isExpanded) {
            Navigator.of(context).push(CupertinoPageRoute(
                builder: (context) => TicketDetailsScreen(
                      ticket: ticket,
                      user: user,
                      commentCount: commentCount,
                    )));
          }
        },
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(color: Color.fromARGB(255, 231, 230, 230))),
          ),
          child: Padding(
            padding:
                EdgeInsets.only(top: isExpanded == true ? 0 : 12, bottom: 12, left: 12, right: 12),
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
                                border: Border.all(width: 1, color: Theme.of(context).primaryColor),
                                borderRadius: const BorderRadius.all(Radius.circular(3))),
                            child: Text(
                              ticket.category,
                              style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        Jiffy(ticket.createdAt.toDate()).fromNow(),
                        style:
                            const TextStyle(color: Color.fromARGB(255, 80, 80, 80), fontSize: 13),
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
                        overflow: !isExpanded ? TextOverflow.ellipsis : TextOverflow.clip,
                        style: const TextStyle(fontSize: 15),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 5),
                                child: StreamBuilder<int>(
                                    stream: CommentModel.commentCountStream(ticket.id),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasError) {
                                        return const Text('Something went wrong..');
                                      }

                                      if (snapshot.hasData) {
                                        final newCommentCount = snapshot.data!;

                                        return Text('$newCommentCount comments');
                                      }

                                      return Text('$commentCount comments');
                                    }),
                              ),
                              ticket.ownerId == FirebaseAuth.instance.currentUser!.uid
                                  ? SizedBox(
                                      height: 23,
                                      width: 30,
                                      child: TextButton(
                                          style: TextButton.styleFrom(padding: EdgeInsets.zero),
                                          onPressed: () {
                                            showDialog(
                                                context: parentContext,
                                                builder: (context) => AlertDialog(
                                                      title: const Text("Confirm"),
                                                      content: Text(
                                                          "Are you sure you would like to delete ${ticket.title} post?"),
                                                      actions: [
                                                        TextButton(
                                                          child: const Text("Cancel"),
                                                          onPressed: () {
                                                            Navigator.pop(context);
                                                          },
                                                        ),
                                                        TextButton(
                                                          child: const Text("Yes"),
                                                          onPressed: () {
                                                            ticket.removeTicket(parentContext);
                                                            Navigator.pop(context);
                                                          },
                                                        ),
                                                      ],
                                                    ));
                                          },
                                          child: const Icon(
                                            Icons.delete_forever,
                                            color: Colors.red,
                                            size: 25,
                                          )),
                                    )
                                  : SizedBox(
                                      height: 20,
                                      width: 30,
                                      child: TextButton(
                                          style: TextButton.styleFrom(padding: EdgeInsets.zero),
                                          onPressed: () {
                                            Navigator.of(context).push(CupertinoPageRoute(
                                                builder: (context) =>
                                                    ReportIssueScreen(ticketId: ticket.id)));
                                          },
                                          child: const Icon(
                                            Icons.report_problem_rounded,
                                            color: Colors.red,
                                            size: 25,
                                          )),
                                    )
                            ]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
