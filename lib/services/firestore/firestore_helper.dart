import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:f151/models/chat_message.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreHelper {
  static sendMessage(bool isTeacher, String recieverUID, String message) async {
    final userUID = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance.collection('chat').doc().set(ChatMessage(
            teacherUID: isTeacher ? userUID : recieverUID,
            studentUID: isTeacher ? recieverUID : userUID,
            senderUID: userUID,
            message: message,
            timestamp: Timestamp.now())
        .toMap());
  }
}
