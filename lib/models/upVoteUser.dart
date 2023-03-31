import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> upVotesUser(String userId) async {
  final loggedInUserId = FirebaseAuth.instance.currentUser!.uid;
  final docRef = FirebaseFirestore.instance.collection('profiles').doc(userId);

  final docSnap = await docRef.get();
  final upVoters = (docSnap.data())?['upVoters'] as List<dynamic>? ?? [];

  if (!upVoters.contains(loggedInUserId)) {
    upVoters.add(loggedInUserId);
    await docRef.update({'upVoters': upVoters});
  }
}
