import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:neighbour_good/utils/form_validation.dart';
import 'package:neighbour_good/widgets/dropdown_category.dart';
import 'package:flutter/services.dart';

class ReportIssueScreen extends StatefulWidget {
  const ReportIssueScreen({Key? key, required this.ticketId}) : super(key: key);
  final String ticketId;

  @override
  State<ReportIssueScreen> createState() => _ReportIssueScreenState();
}

class _ReportIssueScreenState extends State<ReportIssueScreen> {
  final reportIssueTitle = TextEditingController();
  final reportIssueDescription = TextEditingController();
  late String _ticketRef = '';
  late List<String> _ticketRefList = [];

  @override
  void initState() {
    getUserTicketRefs();
    super.initState();
  }

  void submitIssue() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      await FirebaseFirestore.instance.collection('issues').doc().set({
        'flagged_by': user?.uid,
        'created_at': DateTime.now().toUtc(),
        'description': reportIssueDescription.text,
        'ticket_ref': widget.ticketId,
        'title': reportIssueTitle.text,
      }).then((value) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Your issue has been successfully reported."),
        ));
        Navigator.pop(context);
      });
    } on FirebaseException catch (e) {
      debugPrint(e.message);
    }
  }

  void getUserTicketRefs() async {
    try {
      await FirebaseFirestore.instance
          .collection('tickets')
          .get()
          .then((querySnapshot) {
        String firstRef = querySnapshot.docs[0].id;
        onIssueChange(firstRef);
        List<String> ticketRef = querySnapshot.docs.map((e) {
          return e.id.toString();
        }).toList();
        debugPrint(ticketRef.toString());
        addTicketRef(ticketRef);
      });
    } catch (e) {
      debugPrint('Error fetching ticket references: $e');
    }
  }

  void addTicketRef(List<String> ticketRefList) {
    setState(() {
      _ticketRefList = ticketRefList;
    });
  }

  void onIssueChange(ticketRef) {
    setState(() {
      _ticketRef = ticketRef;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Report an issue')),
      body: Column(
        children: [
          TextFormField(
            controller: reportIssueTitle,
            decoration: const InputDecoration(
                label: Text('Title *'),
                hintText: 'Enter issue',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.only(bottom: 10)),
            validator: validateNotEmpty,
          ),
          TextFormField(
            controller: reportIssueDescription,
            decoration: const InputDecoration(
                label: Text('Issue *'),
                hintText: 'Description',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.all(10)),
            validator: validateNotEmpty,
          ),
          ElevatedButton(onPressed: submitIssue, child: const Text('Submit'))
        ],
      ),
    );
  }
}
