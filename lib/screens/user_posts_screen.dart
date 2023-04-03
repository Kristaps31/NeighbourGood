import 'package:flutter/material.dart';
import 'package:neighbour_good/widgets/posts_list_page.dart';
import '../models/user.dart';

class UserPostsScreen extends StatelessWidget {
   final UserModel user;

const UserPostsScreen({ Key? key, required this.user }) : super(key: key);

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: Text('Post`s by ${user.name}')),
      body: PostsListPage(type: 'profile_posts', profileId: user.id,),
    );
  }
}