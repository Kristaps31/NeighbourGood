import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class NeighboursPage extends StatelessWidget {
  const NeighboursPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection("profiles").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return Text('Error = ${snapshot.error}');

          if (snapshot.hasData) {
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

          return const Center(child: CircularProgressIndicator());
        });
  }
}
