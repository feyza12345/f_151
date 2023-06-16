// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:f151/models/person_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppInfoBloc extends Cubit<AppInfoState> {
  AppInfoBloc() : super(AppInfoState.initial);

  Future<AppInfoState> refresh() async {
    final userUID = FirebaseAuth.instance.currentUser!.uid;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(userUID)
        .get()
        .then((doc) => emit(
            state.copyWith(currentPerson: PersonModel.fromMap(doc.data()!))));
    return state;
  }

  setPageIndex(int index) {
    emit(state.copyWith(pageIndex: index));
  }

  clear() {
    emit(AppInfoState.initial);
  }
}

class AppInfoState {
  final PersonModel currentPerson;
  final int pageIndex;
  final bool isTeacher;
  AppInfoState({
    required this.currentPerson,
    required this.pageIndex,
    required this.isTeacher,
  });

  AppInfoState copyWith({
    PersonModel? currentPerson,
    int? pageIndex,
    bool? isTeacher,
  }) {
    return AppInfoState(
      currentPerson: currentPerson ?? this.currentPerson,
      pageIndex: pageIndex ?? this.pageIndex,
      isTeacher: isTeacher ?? this.isTeacher,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'currentPerson': currentPerson.toMap(),
      'pageIndex': pageIndex,
      'isTeacher': isTeacher,
    };
  }

  factory AppInfoState.fromMap(Map<String, dynamic> map) {
    return AppInfoState(
      currentPerson:
          PersonModel.fromMap(map['currentPerson'] as Map<String, dynamic>),
      pageIndex: map['pageIndex'] as int,
      isTeacher: map['isTeacher'] as bool,
    );
  }

  static AppInfoState get initial => AppInfoState(
      currentPerson: PersonModel.empty, pageIndex: 0, isTeacher: false);
}
