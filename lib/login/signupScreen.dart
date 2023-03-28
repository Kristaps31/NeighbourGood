import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neighbour_good/login/home.dart';

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
  final _key = GlobalKey<FormState>();
  String errorMessage = '';

  signUp() async {
    if (_key.currentState!.validate()) {
      try {
        UserCredential response = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: _email.text, password: _pass.text, );
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
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const HomeScreen()));
        errorMessage = '';
      } on FirebaseException catch (e) {
        if (e.code == 'email-already-in-use') {
          errorMessage = 'The account already exists for that email.';
        }
      }
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _key,
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 35),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Signup',
                  style: GoogleFonts.lato(
                      fontWeight: FontWeight.bold, fontSize: 32),
                ),
                const SizedBox(height: 30),
                TextFormField(
                  validator: validateName,
                  controller: _name,
                  decoration: const InputDecoration(
                      hintText: 'Enter your Full Name',
                      icon: Icon(Icons.mail_lock)),
                ),
                TextFormField(
                  validator: validateEmail,
                  controller: _email,
                  decoration: const InputDecoration(
                      hintText: 'Enter your Email address',
                      icon: Icon(Icons.mail_lock)),
                ),
                TextFormField(
                    validator: validatePassword,
                    obscureText: true,
                    controller: _pass,
                    decoration: const InputDecoration(
                        hintText: 'Enter your Your Password',
                        icon: Icon(Icons.lock))),
                TextFormField(
                  validator: validateStreet,
                  controller: _street,
                  decoration: const InputDecoration(
                      hintText: 'Enter your Street address',
                      icon: Icon(Icons.home)),
                ),
                TextFormField(
                  validator: validateDob,
                  controller: _dob,
                  decoration: const InputDecoration(
                      hintText: 'Enter Date Of Birth(dd/mm/yy) ',
                      icon: Icon(Icons.calendar_month)),
                ),
                Text(
                  errorMessage,
                  style: const TextStyle(color: Colors.red),
                ),
                const SizedBox(
                  height: 15,
                ),
                ElevatedButton(
                    onPressed: signUp,
                    child: Text(
                      'Signup',
                      style: GoogleFonts.lato(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    )),
                const SizedBox(height: 10),
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
      ),
    );
  }
}

String? validateEmail(String? formEmail) {
  if (formEmail == null || formEmail.isEmpty) {
    return 'Email address is require';
  }
  String pattern = r'\w+@\w+\.\w+';
  RegExp regex = RegExp(pattern);
  if (!regex.hasMatch(formEmail)) {
    return 'Invalid Email Address Format';
  }
  return null;
}

String? validateName(String? formEmail) {
  if (formEmail == null || formEmail.isEmpty) {
    return 'Name is require';
  }

  return null;
}

String? validateStreet(String? formEmail) {
  if (formEmail == null || formEmail.isEmpty) {
    return 'Address is require';
  }

  return null;
}

String? validateDob(String? formEmail) {
  if (formEmail == null || formEmail.isEmpty) {
    return 'Date of Birth is require';
  }

  return null;
}

String? validatePassword(String? formPassword) {
  if (formPassword == null || formPassword.isEmpty) {
    return 'Password is require';
  }
  String pattern =
      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{6,}$';
  RegExp regex = RegExp(pattern);
  if (!regex.hasMatch(formPassword)) {
    return '''
      Password must be at least 6 characters,
      include an uppercase letter, number and symbol.
      ''';
  }
  return null;
}
