import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:neighbour_good/screens/user_screen.dart';
import '/models/user.dart';

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
                  final data = docs[index].data();
                  return ListTile(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UserScreen(
                                      user: Profile(
                                    id: docs[index].id,
                                    name: data['name'],
                                    about_me: data['about_me'] ?? "No Info provided",
                                    upVoters:
                                        data['upVoters'] == null ? 0 : data['upVoters'].length,
                                    dob: data['dob'] ?? "No Info provided",
                                    street: data['street'] ?? "address unavailable",
                                    created_at: data['created_at'] ?? "Not available",
                                    img: data['img'],
                                  ))));
                    },
                    title: Text(data["name"] ?? ''),
                  );
                });
          }
          return const Center(child: CircularProgressIndicator());
        });
  }
}
