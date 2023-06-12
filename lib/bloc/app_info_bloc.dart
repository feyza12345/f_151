import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppInfoBloc extends Cubit<AppInfoState> {
  AppInfoBloc() : super(AppInfoState.initial());

  Future<AppInfoState> refresh() async {
    final name = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then(
          (value) => value.data()!['name'],
        );
    emit(state.copyWith(
      userName: name,
    ));
    return state;
  }

  setPageIndex(int index) {
    emit(state.copyWith(pageIndex: index));
  }
}

class AppInfoState {
  final String? url;
  final String userName;
  final int pageIndex;
  AppInfoState({
    this.url,
    required this.userName,
    required this.pageIndex,
  });

  static initial() => AppInfoState(userName: 'userName', pageIndex: 0);

  AppInfoState copyWith({
    String? url,
    String? userName,
    int? pageIndex,
  }) {
    return AppInfoState(
      url: url ?? this.url,
      userName: userName ?? this.userName,
      pageIndex: pageIndex ?? this.pageIndex,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'url': url,
      'userName': userName,
      'pageIndex': pageIndex,
    };
  }

  factory AppInfoState.fromMap(Map<String, dynamic> map) {
    return AppInfoState(
      url: map['url'] != null ? map['url'] as String : null,
      userName: map['userName'] as String,
      pageIndex: map['pageIndex'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory AppInfoState.fromJson(String source) =>
      AppInfoState.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'AppInfoState(url: $url, userName: $userName, pageIndex: $pageIndex)';

  @override
  bool operator ==(covariant AppInfoState other) {
    if (identical(this, other)) return true;

    return other.url == url &&
        other.userName == userName &&
        other.pageIndex == pageIndex;
  }

  @override
  int get hashCode => url.hashCode ^ userName.hashCode ^ pageIndex.hashCode;
}
