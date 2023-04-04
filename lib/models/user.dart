import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String name;
  final String aboutMe;
  final String dob;
  final String street;
  final String img;
  final Timestamp createdAt;


  UserModel({
    required this.id,
    this.name = "",
    required this.aboutMe,
    required this.img,
    required this.dob,
    required this.street,
    required this.createdAt,});

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    if (doc.exists) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      return UserModel(
        id: doc.id,
        name: data['name'] ?? '',
        img: data['img'] ?? '',
        aboutMe: data['about_me'] ?? "",
        dob: data['dob'] ?? '',
        street: data['street'] ?? '',
        createdAt: data['created_at'] ?? '',
      );
    } else {
      return UserModel.empty();
    }
  }

  factory UserModel.empty() {
    return UserModel(id: '',
        name: '',
        img: '',
        aboutMe: '',
        dob: '',
        street: '',
        createdAt: Timestamp.fromDate(DateTime.now()));
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
