import 'package:cloud_firestore/cloud_firestore.dart';

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
    DocumentSnapshot<Map<String, dynamic>> response =
        await FirebaseFirestore.instance.collection('profiles').doc(ownerId).get();
    UserModel user = UserModel.fromFirestore(response);
    return user;
  }
}
