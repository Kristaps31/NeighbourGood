import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../login/loginScreen.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(onPressed: () => {}, child: const Text("Ask For Help")),
            const SizedBox(width: 20),
            ElevatedButton(onPressed: () => {}, child: const Text("Offer Help"))
          ],
        )
      ],
    );
  }
}
