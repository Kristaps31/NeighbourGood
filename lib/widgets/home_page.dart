import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () => {}, child: const Text("Ask For Help")),
            const SizedBox(width: 20),
            ElevatedButton(onPressed: () => {}, child: const Text("Offer Help"))
          ],
        )
      ],
    );
  }
}
