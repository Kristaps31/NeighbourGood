import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:neighbour_good/screens/tickFeedBackScreen.dart';

String categoryValue = '';

class AskHelp extends StatefulWidget {
  const AskHelp({super.key});

  @override
  State<AskHelp> createState() => _AskHelpState();
}

class _AskHelpState extends State<AskHelp> {
  final ticketTitle = TextEditingController();
  final ticketDescription = TextEditingController();

  void submit() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      await FirebaseFirestore.instance.collection('tickets').doc().set({
        'owner_id': user?.uid,
        'Title': ticketTitle.text,
        'Category': categoryValue,
        'Description': ticketDescription.text,
        'created_at': user?.metadata.creationTime,
        'type': 'help',
      });

      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const TicketFeedBack()));
    } on FirebaseException catch (e) {
      debugPrint(e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Ask for help')),
        body: Form(
          child: Center(
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,

              children: [
                const SizedBox(
                  height: 40,
                ),
                const Text(
                  'Request title',
                  style: TextStyle(fontSize: 30),
                ),
                SizedBox(
                  width: 300,
                  height: 40,
                  child: TextFormField(
                    controller: ticketTitle,
                    decoration: const InputDecoration(
                      hintText: 'Enter title',
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 3, color: Colors.blue),
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 3, color: Colors.blue)),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'Category',
                  style: TextStyle(fontSize: 30),
                ),
                const SizedBox(
                  width: 300,
                  height: 40,
                  child: DropDown(),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text('Description', style: TextStyle(fontSize: 30)),
                TextFormField(
                  controller: ticketDescription,
                  maxLines: 8,
                  keyboardType: TextInputType.multiline,
                  decoration: const InputDecoration(
                    hintText: 'Enter description',
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 3, color: Colors.blue),
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 3, color: Colors.blue)),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(onPressed: submit, child: Text('Submit'))
              ],
            ),
          ),
        ));
  }
}

const List<String> categoryList = <String>[
  'Shopping',
  'DIY',
  'Cleaning',
  'Buy/Sell',
  'Local Events',
  'Other'
];

class DropDown extends StatefulWidget {
  const DropDown({super.key});

  @override
  State<DropDown> createState() => _DropDownState();
}

class _DropDownState extends State<DropDown> {
  var dropDownValues = categoryList.first;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: DropdownButton<String>(
        value: dropDownValues,
        elevation: 16,
        style: const TextStyle(color: Colors.black, fontSize: 20),
        onChanged: (String? value) {
          // This is called when the user selects an item.
          setState(() {
            dropDownValues = value!;
          });
          categoryValue = dropDownValues;
        },
        items: categoryList.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }
}
