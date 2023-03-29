// ignore_for_file: non_constant_identifier_names
import 'package:flutter/material.dart';
import '/models/user.dart';

class UserScreen extends StatelessWidget {
  final User user;

const UserScreen({ Key? key, required this.user}) : super(key: key);


  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: const Text("User Details")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage("userAvatarUrl"),
              backgroundColor: Color.fromARGB(255, 230, 217, 214),
              child: const Text('user')),
            Text('Name: ${user.name}'),
            Text('DOB: ${user.dob}'),
            Text('Address: ${user.street}'),
            Text('Member since: ${DateTime.parse(user.created_at.toDate().toString())}'),
            Text('About me: ${user.about_me}'),
            Text('User rating: ${user.rating}'),
          ],
        ),
      ),
    );
  }
}