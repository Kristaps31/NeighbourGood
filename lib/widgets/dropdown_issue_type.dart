import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DropdownIssueType extends StatefulWidget {
  const DropdownIssueType(
      {super.key,
      required this.onIssueChanged,
      required this.issueCategory,
      required this.issueCategories});

  final String issueCategory;
  final Function(String) onIssueChanged;
  final List<String> issueCategories;

  @override
  State<DropdownIssueType> createState() => _DropdownIssueTypeState();
}

class _DropdownIssueTypeState extends State<DropdownIssueType> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: DropdownButtonFormField<String>(
        decoration: const InputDecoration(
            labelText: 'Why are you reporting this?',
            contentPadding: EdgeInsets.only(bottom: 10, left: 15)),
        isExpanded: true,
        value: widget.issueCategory,
        style: const TextStyle(color: Colors.black, fontSize: 20),
        onChanged: (String? value) {
          widget.onIssueChanged(value!);
        },
        items: widget.issueCategories
            .map<DropdownMenuItem<String>>((String issueCategory) {
          return DropdownMenuItem<String>(
              value: issueCategory,
              child: Text(
                issueCategory,
                style: const TextStyle(fontSize: 17),
              ));
        }).toList(),
      ),
    );
  }
}
