import 'package:cloud_firestore/cloud_firestore.dart';
// ignore_for_file: non_constant_identifier_names

class User {
  final String id;
  final String name;
  final String about_me;
  final int rating;
  final String dob;
  final String street;
  final String img;
  // ignore: prefer_typing_uninitialized_variables
  final created_at;

  User(
      {required this.img,
      required this.id,
      required this.name,
      required this.about_me,
      required this.rating,
      required this.dob,
      required this.street,
      required this.created_at});
}

class UserModel {
  final String id;
  final String name;
  final String profileImgUrl;

  UserModel({required this.id, this.name = '', required this.profileImgUrl});

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return UserModel(
      id: doc.id,
      name: data['name'],
      profileImgUrl: data['img'],
    );
  }

  factory UserModel.empty() {
    return UserModel(id: '', name: '', profileImgUrl: '');
  }

  static Future<UserModel> loadUserDetails(String ownerId) async {
    DocumentSnapshot<Map<String, dynamic>> response = await FirebaseFirestore
        .instance
        .collection('profiles')
        .doc(ownerId)
        .get();
    UserModel user = UserModel.fromFirestore(response);
    return user;
  }
}
