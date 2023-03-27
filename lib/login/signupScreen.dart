import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _email = TextEditingController();
  final _pass = TextEditingController();
  final _name = TextEditingController();
  final _street = TextEditingController();
  final _dob = TextEditingController();

  signUp() async {
    try {
      UserCredential response = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: _email.text, password: _pass.text);
      User? user = response.user;

      await FirebaseFirestore.instance
          .collection('profiles')
          .doc(user?.uid)
          .set({
        'name': _name.text,
        'created_at': user?.metadata.creationTime,
        'street': _street.text,
        'dob': _dob.text,
      });
      Navigator.pop(context);
    } on FirebaseException catch (e) {
      if (e.code == 'weak-password') {
        debugPrint('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        debugPrint('The account already exists for that email.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 35),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Signup',
                style:
                    GoogleFonts.lato(fontWeight: FontWeight.bold, fontSize: 32),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: _name,
                decoration: const InputDecoration(
                    hintText: 'Enter your Full Name',
                    icon: Icon(Icons.verified_user)),
              ),
              TextField(
                controller: _email,
                decoration: const InputDecoration(
                    hintText: 'Enter your Email address',
                    icon: Icon(Icons.mail_lock)),
              ),
              TextField(
                  obscureText: true,
                  controller: _pass,
                  decoration: const InputDecoration(
                      hintText: 'Enter your Your Password',
                      icon: Icon(Icons.lock))),
              TextField(
                controller: _street,
                decoration: const InputDecoration(
                    hintText: 'Enter your Street address',
                    icon: Icon(Icons.home)),
              ),
              TextField(
                controller: _dob,
                decoration: const InputDecoration(
                    hintText: 'Enter Date Of Birth(dd/mm/yy) ',
                    icon: Icon(Icons.calendar_month)),
              ),
              SizedBox(
                height: 15,
              ),
              ElevatedButton(
                  onPressed: signUp,
                  child: Text(
                    'Signup',
                    style: GoogleFonts.lato(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  )),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an Account? ",
                    style: GoogleFonts.lato(fontSize: 16),
                  ),
                  GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Login',
                        style: GoogleFonts.lato(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue),
                      )),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
