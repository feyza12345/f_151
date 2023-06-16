// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:f151/models/chat_message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatBloc extends Cubit<Map<String, List<ChatMessage>>> {
  ChatBloc() : super({});

  Future loadAllMessages(bool isTeacher) async {
    final userUID = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance
        .collection('chat')
        .where(isTeacher ? 'teacherUId' : 'studentUID', isEqualTo: userUID)
        .orderBy('timestamp', descending: true)
        .get()
        .then((snapshot) {
      if (snapshot.docs.isEmpty) return;

      final docs =
          snapshot.docs.map((e) => ChatMessage.fromMap(e.data())).toList();
      emit(Map.fromIterable(
        docs,
        key: (element) {
          final e = (element as ChatMessage);
          return isTeacher ? e.studentUID : e.teacherUID;
        },
        value: (element) => element,
      ));
    });
  }

  void clear() {
    emit({});
  }

  void refresh(Map<String, List<ChatMessage>> newState) {
    clear();
    emit(newState);
  }
}
