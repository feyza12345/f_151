import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:f151/models/chat_model.dart';
import 'package:f151/models/messages_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreHelper {
  static Future<void> sendMessage(
      String adId, String teacherId, String content) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final now = DateTime.now();
    final message =
        MessagesModel(senderId: userId, content: content, timestamp: now);
    final docId = await FirebaseFirestore.instance
        .collection('chats')
        .where('participantIds', arrayContains: userId)
        .where('adId', isEqualTo: adId)
        .get()
        .then((value) {
      return value.docs.isEmpty ? null : value.docs.first.id;
    });

    if (docId != null) {
      final chatId = FirebaseFirestore.instance.collection('chats').doc().id;
      return await FirebaseFirestore.instance
          .collection('chats')
          .doc(chatId)
          .set(ChatModel(
              lastMessage: message,
              participantIds: [userId, teacherId]).toMap());
    } else {
      return await FirebaseFirestore.instance
          .collection('chats')
          .doc(docId)
          .collection('messages')
          .doc()
          .set(message.toMap());
    }
  }
}
