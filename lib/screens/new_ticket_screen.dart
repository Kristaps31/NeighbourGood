import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:neighbour_good/utils/form_validation.dart';
import 'package:neighbour_good/widgets/dropdown_category.dart';

class NewTicketScreen extends StatefulWidget {
  const NewTicketScreen({super.key, this.type = 'help'});

  final String type;

  @override
  State<NewTicketScreen> createState() => _NewTicketScreenState();
}

class _NewTicketScreenState extends State<NewTicketScreen> {
  final ticketTitle = TextEditingController();
  final ticketDescription = TextEditingController();
  final formKey = GlobalKey<FormState>();
  late String _categoryName;
  late List<String> _categories = ['Shopping'];

  @override
  void initState() {
    FocusManager.instance.primaryFocus?.unfocus();

    _categoryName = 'Shopping';
    getCategories();
    super.initState();
  }

  void setInitialCategory(category) {
    setState(() {
      _categoryName = category;
    });
  }

  void addCategories(List<String> categories) {
    setState(() {
      _categories = categories;
    });
  }

  void getCategories() async {
    try {
      await FirebaseFirestore.instance.collection("categories").orderBy('order').get().then(
        (querySnapshot) {
          String firstCategory = querySnapshot.docs[0].data()['name'] ?? 'DIY';
          setInitialCategory(firstCategory);

          List<String> categories = querySnapshot.docs.map((e) {
            return e['name'].toString();
          }).toList();

          addCategories(categories);
        },
        onError: (e) => debugPrint("Error completing: $e"),
      );
    } catch (e) {
      debugPrint('Error fetching categories: $e');
    }
  }

  void submit() async {
    if (!formKey.currentState!.validate()) {
      return;
    }
    try {
      User? user = FirebaseAuth.instance.currentUser;
      await FirebaseFirestore.instance.collection('tickets').doc().set({
        'owner_id': user?.uid,
        'title': ticketTitle.text.trim(),
        'category': _categoryName,
        'description': ticketDescription.text.trim(),
        'is_opened': true,
        'created_at': DateTime.now().toUtc(),
        'type': widget.type,
      }).then((value) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Your ${widget.type} is successfully posted!"),
        ));
        Navigator.pop(context);
      });
    } on FirebaseException catch (e) {
      debugPrint(e.message);
    }
  }

  void _onCategoryChanged(categoryName) {
    setState(() {
      _categoryName = categoryName;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(widget.type == 'help' ? 'Request Help' : 'Offer Help')),
        body: GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);

            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
              child: Form(
                key: formKey,
                child: Center(
                  child: Column(
                    children: [
                      TextFormField(
                          controller: ticketTitle,
                          decoration: const InputDecoration(
                            label: Text('Title'),
                            border: OutlineInputBorder(),
                            hintText: 'Enter title',
                          ),
                          validator: validateNotEmpty,
                          maxLength: 30),
                      SizedBox(
                        child: DropDownCategory(
                          category: _categoryName,
                          onCategoryChanged: _onCategoryChanged,
                          categories: _categories,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: ticketDescription,
                        maxLines: 5,
                        keyboardType: TextInputType.multiline,
                        decoration: const InputDecoration(
                          label: Text('Description'),
                          border: OutlineInputBorder(),
                          hintText: 'Enter description',
                        ),
                        validator: validateNotEmpty,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(onPressed: submit, child: const Text('Submit')),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
