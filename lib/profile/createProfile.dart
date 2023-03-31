import 'dart:io';
import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CreateProfile extends StatefulWidget {
  const CreateProfile({super.key});

  @override
  State<CreateProfile> createState() => _CreateProfileState();
}

class _CreateProfileState extends State<CreateProfile> {
  final update = FirebaseFirestore.instance
      .collection('profiles')
      .doc(FirebaseAuth.instance.currentUser!.uid);
  final _name = TextEditingController();
  final _dob = TextEditingController();
  final _street = TextEditingController();
  final ImagePicker picker = ImagePicker();
  String name = '';
  String dob = '';
  String street = '';
  String img = '';
  String about = '';
  int rating = 0;
  String displayUrl = '';
  String display = '';
  bool nameEditable = false;
  bool dobEditable = false;
  bool streetEditable = false;
  bool aboutEditable = false;
  FToast fToast = FToast();
  _getData() async {
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
            rating = snapshot.data()!['rating'] ?? 0;
            about = snapshot.data()!['about_me'] ?? '';
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
        display = 'show';
      });
      debugPrint(imgUrl);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  void initState() {
    FocusManager.instance.primaryFocus?.unfocus();
    super.initState();
    _getData();
    fToast = FToast();
    fToast.init(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
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
            display != ''
                ? ElevatedButton(
                    onPressed: () async {
                      await FirebaseFirestore.instance
                          .collection('profiles')
                          .doc(FirebaseAuth.instance.currentUser?.uid)
                          .update({'img': displayUrl});
                      setState(() {
                        display = '';
                      });
                      fToast.showToast(
                        child: Text(
                          'Image successfully updated',
                          style: TextStyle(
                              backgroundColor: Colors.black,
                              color: Colors.white,
                              fontSize: 18),
                        ),
                        gravity: ToastGravity.BOTTOM,
                        toastDuration: Duration(seconds: 2),
                      );
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
            Text(
              '${rating == 0 ? '☆☆☆☆☆' : rating == 1 ? '★☆☆☆☆' : rating == 2 ? '★★☆☆☆' : rating == 3 ? '★★★☆☆' : rating == 4 ? '★★★★☆' : rating == 5 ? '★★★★★' : '★★★★★'}',
              style: TextStyle(fontSize: 17),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Full Name',
              style: TextStyle(fontSize: 20),
            ),
            Container(
                margin: EdgeInsets.only(left: 50),
                child: !nameEditable
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            name,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          IconButton(
                            // iconSize: 21,
                            icon: Icon(Icons.edit_note),
                            onPressed: () {
                              setState(() => {nameEditable = true});
                            },
                          ),
                        ],
                      )
                    : TextFormField(
                        autofocus: true,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                        ),
                        textAlign: TextAlign.center,
                        initialValue: name,
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (value) async {
                          if (await confirm(
                            context,
                            title: const Text('Confirm'),
                            content: const Text('Updating Name?'),
                            textOK: const Text('Yes'),
                            textCancel: const Text('No'),
                          )) {
                            fToast.showToast(
                              child: Text(
                                'Name successfully updated',
                                style: TextStyle(
                                    backgroundColor: Colors.black,
                                    color: Colors.white,
                                    fontSize: 18),
                              ),
                              gravity: ToastGravity.BOTTOM,
                              toastDuration: Duration(seconds: 2),
                            );
                            return setState(() => {
                                  nameEditable = false,
                                  name = value,
                                  update.update({'name': value})
                                });
                          }
                          return setState(() {
                            nameEditable = false;
                            name = name;
                          });
                        })),
            const Text('Date of Birth',
                style: TextStyle(
                  fontSize: 20,
                )),
            Container(
                margin: EdgeInsets.only(left: 50),
                child: !dobEditable
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            dob,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          IconButton(
                            // iconSize: 21,
                            icon: Icon(Icons.edit_note),
                            onPressed: () {
                              setState(() => {dobEditable = true});
                            },
                          ),
                        ],
                      )
                    : TextFormField(
                        autofocus: true,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                        ),
                        initialValue: dob,
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (value) async {
                          if (await confirm(
                            context,
                            title: const Text('Confirm'),
                            content: const Text('Updating Date of Birth?'),
                            textOK: const Text('Yes'),
                            textCancel: const Text('No'),
                          )) {
                            fToast.showToast(
                              child: Text(
                                'Date of Birth successfully updated',
                                style: TextStyle(
                                    backgroundColor: Colors.black,
                                    color: Colors.white,
                                    fontSize: 18),
                              ),
                              gravity: ToastGravity.BOTTOM,
                              toastDuration: Duration(seconds: 2),
                            );
                            return setState(() => {
                                  dobEditable = false,
                                  dob = value,
                                  update.update({'dob': value})
                                });
                          }
                          return setState(() {
                            dobEditable = false;
                            dob = dob;
                          });
                        })),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Street Address',
                    style: TextStyle(
                      fontSize: 20,
                    )),
                !streetEditable
                    ? IconButton(
                        // iconSize: 21,
                        icon: Icon(Icons.edit_note),
                        onPressed: () {
                          setState(() => {streetEditable = true});
                        },
                      )
                    : Text(''),
              ],
            ),
            Container(
                child: !streetEditable
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            street,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ],
                      )
                    : TextFormField(
                        autofocus: true,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                        ),
                        initialValue: street,
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (value) async {
                          if (await confirm(
                            context,
                            title: const Text('Confirm'),
                            content: const Text('Updating Street Address?'),
                            textOK: const Text('Yes'),
                            textCancel: const Text('No'),
                          )) {
                            fToast.showToast(
                              child: Text(
                                'Street Address successfully updated',
                                style: TextStyle(
                                    backgroundColor: Colors.black,
                                    color: Colors.white,
                                    fontSize: 18),
                              ),
                              gravity: ToastGravity.BOTTOM,
                              toastDuration: Duration(seconds: 2),
                            );
                            return setState(() => {
                                  streetEditable = false,
                                  street = value,
                                  update.update({'street': value})
                                });
                          }
                          return setState(() {
                            streetEditable = false;
                            street = street;
                          });
                        })),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('About Me',
                    style: TextStyle(
                      fontSize: 20,
                    )),
                !aboutEditable
                    ? IconButton(
                        // iconSize: 21,
                        icon: Icon(Icons.edit_note),
                        onPressed: () {
                          setState(() => {aboutEditable = true});
                        },
                      )
                    : Text(''),
              ],
            ),
            Container(
                padding: EdgeInsets.only(left: 20),
                child: !aboutEditable
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Center(
                              child: Text(
                                about == '' ? 'No Info provided' : about.trim(),
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      )
                    : TextFormField(
                        minLines: null,
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        autofocus: true,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          hintText: 'Write Here',
                          border: InputBorder.none,
                        ),
                        initialValue: about,
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (value) async {
                          if (await confirm(
                            context,
                            title: const Text('Confirm'),
                            content: const Text('Updating About Me?'),
                            textOK: const Text('Yes'),
                            textCancel: const Text('No'),
                          )) {
                            fToast.showToast(
                              child: Text(
                                'About Me successfully updated',
                                style: TextStyle(
                                    backgroundColor: Colors.black,
                                    color: Colors.white,
                                    fontSize: 18),
                              ),
                              gravity: ToastGravity.BOTTOM,
                              toastDuration: Duration(seconds: 2),
                            );
                            return setState(() => {
                                  aboutEditable = false,
                                  about = value,
                                  update.update({
                                    'about_me':
                                        value == '' ? 'No Info provided' : value
                                  })
                                });
                          }
                          return setState(() {
                            aboutEditable = false;
                            about = about;
                          });
                        })),
          ]),
        ),
      ),
    );
  }
}
