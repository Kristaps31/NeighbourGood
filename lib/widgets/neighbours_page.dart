import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class NeighboursPage extends StatefulWidget {
  const NeighboursPage({Key? key}) : super(key: key);

  @override
  State<NeighboursPage> createState() => _NeighboursPageState();
}

class _NeighboursPageState extends State<NeighboursPage> {
  @override
  void initState() {
    debugPrint("rendered");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
        future: FirebaseFirestore.instance.collection("profiles").get(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return Text('Error = ${snapshot.error}');

          if (snapshot.hasData) {
            if (snapshot.data == null) {
              return const Text("Something went wrong");
            } else {
              final docs = snapshot.data!.docs;
              return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final data = docs[index].data();
                    return ListTile(
                      onTap: () {
                        debugPrint(docs[index].id);
                      },
                      title: Text(data["name"]),
                    );
                  });
            }
          }
           return const Center(child: CircularProgressIndicator());
        });
        
  }
}
