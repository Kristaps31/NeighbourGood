import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:image_picker/image_picker.dart';

class CreateProfile extends StatefulWidget {
  const CreateProfile({super.key});

  @override
  State<CreateProfile> createState() => _CreateProfileState();
}

class _CreateProfileState extends State<CreateProfile> {
  final ImagePicker picker = ImagePicker();
  String name = '';
  String dob = '';
  String street = '';
  String img = '';
  String displayUrl = '';
  Future addImg() async {}
  _getData() async {
    debugPrint(displayUrl);
    try {
      await FirebaseFirestore.instance
          .collection('profiles')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .get()
          .then((snapshot) async {
        if (snapshot.exists) {
          setState(() {
            name = snapshot.data()!['name'];
            dob = snapshot.data()!['dob'];
            street = snapshot.data()!['street'];
            img = snapshot.data()!['img'];
          });
        }
      });
    } on FirebaseException catch (e) {
      debugPrint(e.message);
    }
  }

  void submit() async {
    try {
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final file = File(image.path);

      Reference ref = FirebaseStorage.instance.ref().child(name);
      await ref.putFile(file);
      final imgUrl = await ref.getDownloadURL();

      setState(() {
        displayUrl = imgUrl;
      });
      debugPrint(imgUrl);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(children: [
          CircleAvatar(
              radius: 80,
              backgroundImage:
                  NetworkImage(displayUrl == '' ? img : displayUrl),
              child:
                  Column(mainAxisAlignment: MainAxisAlignment.end, children: [
                ElevatedButton.icon(
                  onPressed: submit,
                  icon: const Icon(Icons.edit),
                  label: const Text('change'),
                )
              ])),
          displayUrl != ''
              ? ElevatedButton(
                  onPressed: () async {
                    await FirebaseFirestore.instance
                        .collection('profiles')
                        .doc(FirebaseAuth.instance.currentUser?.uid)
                        .update({'img': displayUrl});
                    setState(() {
                      displayUrl = '';
                    });
                  },
                  child: const Text('save to cloud'),
                )
              : const Text(''),
          const SizedBox(height: 10),
          const Text(
            'Rating',
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          const Text(
            '★★★★☆',
            style: const TextStyle(fontSize: 17),
          ),
          const SizedBox(
            height: 10,
          ),
          const Text(
            'Full Name',
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          Text(
            name,
            style: const TextStyle(fontSize: 17),
          ),
          const SizedBox(
            height: 10,
          ),
          const Text('Date of Birth',
              style: TextStyle(
                fontSize: 20,
              )),
          Text(
            dob,
            style: const TextStyle(fontSize: 17),
          ),
          const SizedBox(
            height: 10,
          ),
          const Text('Address',
              style: TextStyle(
                fontSize: 20,
              )),
          Text(
            street,
            style: const TextStyle(fontSize: 17),
          ),
        ]),
      ),
    );
  }
}
