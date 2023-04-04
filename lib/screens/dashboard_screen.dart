import 'package:flutter/material.dart';
import 'package:neighbour_good/widgets/home_page.dart';
import 'package:neighbour_good/widgets/my_socials_page.dart';
import 'package:neighbour_good/widgets/neighbours_page.dart';
import 'package:neighbour_good/widgets/profile_menu_drawer.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late int _navIndexSelected;

  List<Widget> pages = const [HomePage(), NeighboursPage(), MySocialsPage()];
  List<String> titles = ["NeighbourGood", "Neighbours", "Messages"];

  @override
  void initState() {
    _navIndexSelected = 0;
    super.initState();
  }

  void _onPageChangedHandler(int index) {
    setState(() {
      _navIndexSelected = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          title: Text(titles[_navIndexSelected]),
          elevation: _navIndexSelected == 0 ? 0 : 2,
          automaticallyImplyLeading: false,
        ),
        endDrawer: const ProfileMenuDrawer(),
        body: pages[_navIndexSelected],
        bottomNavigationBar: NavigationBar(destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.people), label: 'Neighbours'),
          NavigationDestination(icon: Icon(Icons.message), label: 'DMs'),
        ], selectedIndex: _navIndexSelected, onDestinationSelected: _onPageChangedHandler),
      ),
      onWillPop: () async => false,
    );
  }
}
