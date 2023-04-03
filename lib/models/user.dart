import 'package:cloud_firestore/cloud_firestore.dart';

// ignore_for_file: non_constant_identifier_names

class Profile {
  final String id;
  final String name;
  final String about_me;
  late final int upVoters;
  final String dob;
  final String street;
  final String img;
  // ignore: prefer_typing_uninitialized_variables
  final created_at;

  Profile({
    required this.id,
    required this.name,
    required this.about_me,
    required this.img,
    required this.upVoters,
    required this.dob,
    required this.street,
    required this.created_at,
  });
}

class UserModel {
  final String id;
  final String name;
  final String profileImgUrl;

  UserModel({required this.id, this.name = '', required this.profileImgUrl});

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    if (doc.exists) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      return UserModel(
        id: doc.id,
        name: data['name'],
        profileImgUrl: data['img'],
      );
    } else {
      return UserModel.empty();
    }
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

  static Future<AggregateQuerySnapshot> getVoteCount(String profileId) {
    return FirebaseFirestore.instance
        .collection('profiles')
        .doc(profileId)
        .collection('upVoters')
        .count()
        .get();
  }

  static Future<DocumentSnapshot<Map<String, dynamic>>> updateVoteCount(
    profileId,
    userId,
  ) {
    return FirebaseFirestore.instance
        .collection('profiles')
        .doc(profileId)
        .collection('upVoters')
        .doc(userId)
        .get();
  }
}
