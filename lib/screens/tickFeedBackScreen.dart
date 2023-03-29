import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:neighbour_good/screens/ask_help_screen.dart';

class TicketFeedBack extends StatelessWidget {
  const TicketFeedBack({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Ticket succesfully submitted'),
            const SizedBox(
              height: 30,
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => const AskHelp()));
                },
                child: const Text('Submit another Request'))
          ],
        ),
      ),
    );
  }
}
