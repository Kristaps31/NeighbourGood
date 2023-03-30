import 'package:flutter/material.dart';

class FabWithIcons extends StatefulWidget {
  const FabWithIcons(
      {super.key, required this.icons, required this.onIconTapped, required this.labels});
  final List<IconData> icons;
  final ValueChanged<int> onIconTapped;
  final List<String> labels;

  @override
  State createState() => FabWithIconsState();
}

class FabWithIconsState extends State<FabWithIcons> with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: List.generate(widget.icons.length, (int index) {
        return _buildChild(index);
      }).toList()
        ..add(
          _buildFab(),
        ),
    );
  }

  Widget _buildChild(int index) {
    Color backgroundColor = Theme.of(context).cardColor;
    Color foregroundColor = Theme.of(context).primaryColor;
    return Container(
      height: 70.0,
      alignment: FractionalOffset.centerRight,
      child: ScaleTransition(
        scale: CurvedAnimation(
          parent: _controller,
          curve: Interval(0.0, 1.0 - index / widget.icons.length / 2.0, curve: Curves.easeOut),
        ),
        child: FloatingActionButton.extended(
          heroTag: 'addButtonOnHomeScreen$index',
          backgroundColor: backgroundColor,
          label: Text(widget.labels[index]),
          icon: Icon(widget.icons[index], color: foregroundColor),
          onPressed: () => _onTapped(index),
        ),
      ),
    );
  }

  Widget _buildFab() {
    return FloatingActionButton(
      heroTag: 'addButtonOnHomeFab1',
      onPressed: () {
        if (_controller.isDismissed) {
          _controller.forward();
        } else {
          _controller.reverse();
        }
      },
      tooltip: 'Add',
      elevation: 2.0,
      child: const Icon(Icons.add),
    );
  }

  void _onTapped(int index) {
    _controller.reverse();
    widget.onIconTapped(index);
  }
}
