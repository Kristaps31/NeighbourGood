import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:neighbour_good/screens/user_screen.dart';

import '../models/user.dart';

class NeighboursList extends StatefulWidget {
  const NeighboursList({Key? key}) : super(key: key);

  @override
  State<NeighboursList> createState() => _NeighboursListState();
}

class _NeighboursListState extends State<NeighboursList> {
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
                padding: const EdgeInsets.only(top: 10),
                itemCount: docs.length,
                itemBuilder: (context, index) {
                  final data = docs[index];
                  UserModel user = UserModel.fromFirestore(data);
                  debugPrint(user.toString());
                  return ListTile(
                    onTap: () {
                      Navigator.push(
                          context, MaterialPageRoute(builder: (context) => UserScreen(user: user)));
                    },
                    title: Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundImage: NetworkImage(user.img == '' ? '' : user.img),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(user.name),
                              Text(
                                user.street,
                                style: const TextStyle(
                                    fontSize: 13, color: Color.fromARGB(255, 110, 110, 110)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                });
          }
          return const Center(child: CircularProgressIndicator());
        });
  }
}
