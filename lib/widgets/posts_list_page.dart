import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PostsListPage extends StatefulWidget {
  final String type;

  const PostsListPage({Key? key, required this.type}) : super(key: key);

  @override
  State<PostsListPage> createState() => _PostsListPageState();
}

class _PostsListPageState extends State<PostsListPage> {
  String typeField = '';
  String equalTo = '';

  @override
  void initState() {
    super.initState();

    if (widget.type == 'offers') {
      typeField = 'type';
      equalTo = 'help';
    }
    if (widget.type == 'pledges') {
      typeField = 'type';
      equalTo = 'offer';
    }
    if (widget.type == 'my_posts') {
      typeField = 'owner_id';
      equalTo = FirebaseAuth.instance.currentUser?.uid ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('tickets')
          .where(typeField, isEqualTo: equalTo)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) return Text('Error = ${snapshot.error}');

        if (snapshot.hasData) {
          final docs = snapshot.data!.docs;
          return ListView.builder(
              itemCount: docs.length,
              itemBuilder: (context, index) {
                final data = docs[index].data();
                if (data["title"] != null) {
                  return ListTile(
                    onTap: () {
                      debugPrint(docs[index].id);
                    },
                    title: Text(data["title"] ?? ''),
                  );
                } else {
                  return null;
                }
              });
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
