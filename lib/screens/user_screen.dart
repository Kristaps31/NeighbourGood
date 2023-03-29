// ignore_for_file: non_constant_identifier_names, deprecated_member_use
import 'package:flutter/material.dart';
import '/models/user.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

class UserScreen extends StatelessWidget {
  final User user;

const UserScreen({ Key? key, required this.user}) : super(key: key);


  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: const Text("User Details")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              // ignore: prefer_const_literals_to_create_immutables
              children: [ 
                // ignore: prefer_const_constructors
                Expanded(
                  child: FittedBox( 
                    child: Container(
                      margin: EdgeInsets.all(4),
                   // ignore: prefer_const_constructors
                   child: CircleAvatar(
              backgroundColor: const Color.fromARGB(255, 230, 217, 214),
              child: const Text('user'),
              ),
              ),
              ),
              ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        Text(user.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2.0),
                        child: Text(user.street, style: const TextStyle(fontWeight: FontWeight.bold),),
                      ),
                  Row(
                    children: [
                    const Text('Member Since: '),
                    Text(DateFormat('dd/MM/yyyy').format(user.created_at.toDate()), style: const TextStyle(fontWeight: FontWeight.bold),)
                    ]),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Rating: '),
                        Text('${user.rating}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                        TextButton(onPressed: (){}, child: const Text('👍',style: TextStyle(fontSize: 20, color: Colors.black))),
                      ],
                    )
                ],
                ))
                    ]),
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.all(10),
                      padding: const EdgeInsets.all(7.0),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular(10)),
                        border: Border.all(
                          width: 2.0,
                          color: Color.fromARGB(255, 186, 182, 182),
                          style: BorderStyle.solid
                        )
                      ),
                      child: Text('About me: ${user.about_me}'),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        OutlinedButton(onPressed: () {}, style: OutlinedButton.styleFrom(primary: Colors.black,side: const BorderSide(color: Colors.purple),shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20),),),child: const Text('Message Neighbour'),),
                        const SizedBox(width: 20),
                        OutlinedButton(onPressed: () {}, style: OutlinedButton.styleFrom(primary: Colors.black,side: const BorderSide(color: Colors.purple),shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20),),),child: const Text('Neighbours Posts'),),
                      ],
                    )
                    ]
        )));
  }
}