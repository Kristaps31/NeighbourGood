import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:neighbour_good/screens/new_ticket_screen.dart';
import 'package:neighbour_good/widgets/posts_list_page.dart';

import '../login/loginScreen.dart';
import 'fancy_fab.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  User? user = FirebaseAuth.instance.currentUser;
  logout() async {
    try {
      FirebaseAuth.instance.signOut();
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const LoginScreen()));
    } on FirebaseAuthException catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        DefaultTabController(
          length: 3,
          initialIndex: 0,
          child: Scaffold(
            floatingActionButton: FabWithIcons(
              icons: const [Icons.chat_rounded, Icons.waving_hand],
              labels: const ["Ask For Help", "Offer Help"],
              onIconTapped: (index) {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => NewTicketScreen(
                          type: index == 1 ? 'offer' : 'help',
                        )));
              },
            ),
            appBar: AppBar(
              title: null,
              bottom: PreferredSize(
                preferredSize: const Size(double.infinity, -18),
                child: TabBar(
                  labelColor: Theme.of(context).primaryColor,
                  unselectedLabelColor: const Color.fromARGB(255, 130, 130, 130),
                  tabs: const [
                    Padding(padding: EdgeInsets.only(top: 6, bottom: 6), child: Text('Offers')),
                    Padding(padding: EdgeInsets.only(top: 6, bottom: 6), child: Text('Pledges')),
                    Padding(padding: EdgeInsets.only(top: 6, bottom: 6), child: Text('My Posts')),
                  ],
                ),
              ),
            ),
            body: TabBarView(
              children: [
                // pages
                Container(color: Colors.white, child: const PostsListPage(type: "offers")),
                const PostsListPage(type: 'pledges'),
                const PostsListPage(type: 'my_posts'),
              ],
            ),
          ),
        ),
        //
      ],
    );
  }
}
