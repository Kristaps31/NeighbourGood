import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:neighbour_good/screens/my_profile_screen.dart';

import '../login/loginScreen.dart';

class ProfileMenuDrawer extends StatefulWidget {
  const ProfileMenuDrawer({Key? key}) : super(key: key);

  @override
  State<ProfileMenuDrawer> createState() => _ProfileMenuDrawerState();
}

class _ProfileMenuDrawerState extends State<ProfileMenuDrawer> {
  User? user = FirebaseAuth.instance.currentUser;

  void logout() async {
    try {
      FirebaseAuth.instance.signOut();
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const LoginScreen()));
    } on FirebaseAuthException catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
      padding: EdgeInsets.zero,
      children: [
        const SizedBox(
          height: 100,
          child: DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Text(
              'Profile Menu',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
        ),
        ListTile(
          title: const Text('My profile'),
          onTap: () {
            Navigator.pop(context);
            Navigator.push(
                context, CupertinoPageRoute(builder: (context) => const MyProfileScreen()));
          },
        ),
        ListTile(
          title: const Text('Log out'),
          onTap: () {
            logout();
          },
        ),
      ],
    ));
  }
}
