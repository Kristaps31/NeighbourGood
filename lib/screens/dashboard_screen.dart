import 'package:flutter/material.dart';
import 'package:neighbour_good/widgets/home_page.dart';
import 'package:neighbour_good/widgets/my_socials_page.dart';
import 'package:neighbour_good/widgets/neighbours_page.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late int _navIndexSelected;

  late List<Widget> pages = const [
    HomePage(),
    NeighboursPage(),
    MySocialsPage()
  ];

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
    return Scaffold(
      appBar: AppBar(
        title: const Text("NeighbourGood"),
      ),
      body: pages[_navIndexSelected],
      bottomNavigationBar: NavigationBar(
          destinations: const [
            NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
            NavigationDestination(
                icon: Icon(Icons.people), label: 'Neighbours'),
            NavigationDestination(
                icon: Icon(Icons.message), label: 'My Socials'),
          ],
          selectedIndex: _navIndexSelected,
          onDestinationSelected: _onPageChangedHandler),
    );
  }
}
