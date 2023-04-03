import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:neighbour_good/utils/form_validation.dart';
import 'package:neighbour_good/widgets/dropdown_category.dart';
import 'package:flutter/services.dart';
import 'package:neighbour_good/widgets/dropdown_issue_type.dart';

class ReportIssueScreen extends StatefulWidget {
  const ReportIssueScreen({Key? key, required this.ticketId}) : super(key: key);
  final String ticketId;

  @override
  State<ReportIssueScreen> createState() => _ReportIssueScreenState();
}

class _ReportIssueScreenState extends State<ReportIssueScreen> {
  final reportIssueTitle = TextEditingController();
  final reportIssueDescription = TextEditingController();
  late String _issueCategory = 'Offensive, harassment or hateful speech';
  final List<String> _issueCategories = [
    'Offensive, harassment or hateful speech',
    'Duplicate listing',
    'Wrong category',
    'Suspicious, spam or fake',
    'Other'
  ];

  @override
  void initState() {
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
        'issue_type': _issueCategory,
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

  void _onIssueChanged(issueCategory) {
    setState(() {
      _issueCategory = issueCategory;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Report an issue')),
      body: GestureDetector(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                    controller: reportIssueTitle,
                    decoration: const InputDecoration(
                        label: Text('Title'),
                        hintText: 'Enter issue',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.only(bottom: 10, left: 15)),
                    validator: validateNotEmpty,
                    maxLength: 40),
              ),
              DropdownIssueType(
                  onIssueChanged: _onIssueChanged,
                  issueCategory: _issueCategory,
                  issueCategories: _issueCategories),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: reportIssueDescription,
                  maxLines: 5,
                  keyboardType: TextInputType.multiline,
                  decoration: const InputDecoration(
                      label: Text('Issue'),
                      hintText: 'Issue description',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.only(bottom: 10, left: 15)),
                  validator: validateNotEmpty,
                ),
              ),
              ElevatedButton(
                  onPressed: submitIssue, child: const Text('Submit'))
            ],
          ),
        ),
      ),
    );
  }
}
