import 'package:cloud_firestore/cloud_firestore.dart';

class Chat {
  final String id;
  final String sender1;
  final String sender2;

  Chat({
    required this.id,
    required this.sender1,
    required this.sender2,
  });

  factory Chat.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Chat(
        id: doc.id, sender1: data['senders'][0], sender2: data['senders'][1]);
  }
  static Stream<QuerySnapshot<Map<String, dynamic>>> getChatList(String userId){
    return FirebaseFirestore.instance
    .collection('chats')
    .where('senders', arrayContains: userId)
    .snapshots();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessage(String chatId){
    return FirebaseFirestore.instance
    .collection('chats')
    .doc(chatId)
    .collection("messages")
    .orderBy("created_at", descending: true)
    .limit(1)
    .snapshots();
  }
}
