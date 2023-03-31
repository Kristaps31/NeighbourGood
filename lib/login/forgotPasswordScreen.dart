import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neighbour_good/login/loginScreen.dart';
import 'package:neighbour_good/login/signupScreen.dart';

class ForgotPass extends StatefulWidget {
  const ForgotPass({Key? key}) : super(key: key);

  @override
  State<ForgotPass> createState() => _ForgetPassState();
}

class _ForgetPassState extends State<ForgotPass> {
  final _email = TextEditingController();
  final _key = GlobalKey<FormState>();
  String errorMessage = '';

  forgetPassword() async {
    if (_key.currentState!.validate()) {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        FirebaseAuth.instance.sendPasswordResetEmail(email: _email.text);
        Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
        errorMessage = '';
      } else {
        setState(() {
          errorMessage = 'Email is not register';
        });
      }
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
              children: <Widget>[
                const Text(
                  'Forgot Password',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  validator: validateEmail,
                  controller: _email,
                  decoration: const InputDecoration(
                      hintText: 'Enter your Email address', icon: Icon(Icons.mail_lock)),
                ),
                Center(
                  child: Text(
                    errorMessage,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                ElevatedButton(
                    onPressed: forgetPassword,
                    child: Text(
                      'Forgot Password',
                      style: GoogleFonts.lato(fontSize: 18, fontWeight: FontWeight.bold),
                    )),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Another Try? ',
                      style: GoogleFonts.lato(fontSize: 16),
                    ),
                    GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context, MaterialPageRoute(builder: (context) => LoginScreen()));
                        },
                        child: Text(
                          'Login',
                          style: GoogleFonts.lato(
                              color: Colors.blue, fontSize: 16, fontWeight: FontWeight.bold),
                        ))
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
