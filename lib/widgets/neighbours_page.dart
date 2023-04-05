import 'package:flutter/material.dart';
import 'package:neighbour_good/widgets/map.dart';
import 'package:neighbour_good/widgets/neighbours_list.dart';

class NeighboursPage extends StatefulWidget {
  const NeighboursPage({Key? key}) : super(key: key);

  @override
  State<NeighboursPage> createState() => _NeighboursPageState();
}

class _NeighboursPageState extends State<NeighboursPage> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        DefaultTabController(
          length: 2,
          initialIndex: 0,
          child: Scaffold(
            appBar: AppBar(
              title: null,
              bottom: PreferredSize(
                preferredSize: const Size(double.infinity, -18),
                child: TabBar(
                  labelColor: Theme.of(context).primaryColor,
                  unselectedLabelColor: const Color.fromARGB(255, 130, 130, 130),
                  tabs: const [
                    Padding(padding: EdgeInsets.only(top: 6, bottom: 6), child: Text('List')),
                    Padding(padding: EdgeInsets.only(top: 6, bottom: 6), child: Text('Map')),
                  ],
                ),
              ),
            ),
            body: const TabBarView(
              physics: NeverScrollableScrollPhysics(),
              children: [
                // pages
                NeighboursList(),
                MapSample(),
              ],
            ),
          ),
        ),
        //
      ],
    );
  }
}
