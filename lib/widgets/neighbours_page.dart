import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:neighbour_good/screens/user_screen.dart';

import '../models/user.dart';

class NeighboursPage extends StatefulWidget {
  const NeighboursPage({Key? key}) : super(key: key);

  @override
  State<NeighboursPage> createState() => _NeighboursPageState();
}

class _NeighboursPageState extends State<NeighboursPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
        future: FirebaseFirestore.instance.collection("profiles").get(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return Text('Error = ${snapshot.error}');

          if (snapshot.hasData) {
            final docs = snapshot.data!.docs;

            return ListView.builder(
                itemCount: docs.length,
                itemBuilder: (context, index) {
                  final data = docs[index];
                  UserModel user = UserModel.fromFirestore(data);
                  debugPrint(user.toString());
                  return ListTile(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UserScreen(
                                      user: user
                                      )));
                    },
                    title: Text(user.name),
                  );
                });
          }
          return const Center(child: CircularProgressIndicator());
        });
  }
}
