import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class OfferHelp extends StatefulWidget {
  const OfferHelp({super.key});

  @override
  State<OfferHelp> createState() => _OfferHelpState();
}

class _OfferHelpState extends State<OfferHelp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Offer help'),
        ],
      ),
    ));
  }
}
