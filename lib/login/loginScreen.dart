import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:neighbour_good/login/forgotPasswordScreen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neighbour_good/login/signupScreen.dart';
import 'package:neighbour_good/screens/dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _email = TextEditingController();
  final _pass = TextEditingController();
  final _key = GlobalKey<FormState>();
  String errorMessage = '';
  String visiblePassword = 'false';

  logIn() async {
    if (_key.currentState!.validate()) {
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: _email.text.trim(), password: _pass.text.trim());

        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const DashboardScreen()));
        errorMessage = '';
      } on FirebaseException catch (e) {
        errorMessage = e.message!;
      }
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _key,
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 35),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    child: Image.asset(
                        'assets/neighbourgood-removebg-preview.png'),
                  ),
                  Text(
                    'Login',
                    style: GoogleFonts.lato(
                        fontWeight: FontWeight.bold, fontSize: 32),
                  ),
                  TextFormField(
                    validator: validateEmail,
                    controller: _email,
                    decoration: const InputDecoration(
                      hintText: 'Enter your Email address',
                      icon: Icon(Icons.mail_lock),
                    ),
                  ),
                  TextFormField(
                      keyboardType: TextInputType.text,
                      validator: validatePassword,
                      obscureText: visiblePassword == 'false' ? true : false,
                      controller: _pass,
                      decoration: InputDecoration(
                          hintText: 'Enter your Password',
                          icon: const Icon(Icons.lock),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                visiblePassword = visiblePassword == 'false'
                                    ? 'true'
                                    : 'false';
                              });
                            },
                            icon: Icon(visiblePassword == 'false'
                                ? Icons.visibility
                                : Icons.visibility_off),
                          ))),
                  const SizedBox(height: 10),
                  Center(
                    child: Text(
                      errorMessage,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                  Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ForgotPass()));
                          },
                          child: Text(
                            'Forgot Password',
                            style: GoogleFonts.lato(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue),
                          ))),
                  const SizedBox(height: 15),
                  ElevatedButton(
                      onPressed: logIn,
                      child: Text('Login',
                          style: GoogleFonts.lato(
                              fontSize: 18, fontWeight: FontWeight.bold))),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an Account? ",
                        style: GoogleFonts.lato(fontSize: 16),
                      ),
                      GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignupScreen()));
                          },
                          child: Text(
                            'Signup',
                            style: GoogleFonts.lato(
                                fontSize: 16,
                                color: Colors.blue,
                                fontWeight: FontWeight.bold),
                          )),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
