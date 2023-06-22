// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:f151/models/chat_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatBloc extends Cubit<List<ChatModel>> {
  ChatBloc() : super([]);

  Future loadAllMessages(bool isTeacher) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance
        .collection('chats')
        .where('participantIds', arrayContains: userId)
        .get()
        .then((snapshot) {
      if (snapshot.docs.isEmpty) return;

      final docs =
          snapshot.docs.map((e) => ChatModel.fromMap(e.data())).toList();
      emit(docs);
    });
  }

  clear() {
    emit([]);
  }

  void refresh(List<ChatModel> newState) {
    clear();
    emit(newState);
  }
}
