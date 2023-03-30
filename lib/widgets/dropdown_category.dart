import 'package:flutter/material.dart';

class DropDownCategory extends StatefulWidget {
  const DropDownCategory(
      {super.key,
      required this.onCategoryChanged,
      required this.category,
      required this.categories});

  final String category;
  final Function(String) onCategoryChanged;
  final List<String> categories;

  @override
  State<DropDownCategory> createState() => _DropDownState();
}

class _DropDownState extends State<DropDownCategory> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: DropdownButtonFormField<String>(
        decoration: const InputDecoration(labelText: 'Category'),
        isExpanded: true,
        value: widget.category,
        style: const TextStyle(color: Colors.black, fontSize: 20),
        onChanged: (String? value) {
          widget.onCategoryChanged(value!);
        },
        items: widget.categories.map<DropdownMenuItem<String>>((String category) {
          return DropdownMenuItem<String>(
            value: category,
            child: Text(category),
          );
        }).toList(),
      ),
    );
  }
}
