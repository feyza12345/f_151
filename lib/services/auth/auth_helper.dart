import 'package:f151/bloc/app_info_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthHelper {
  static Future<void> sendPassResetEmail(String email) {
    return FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }

  static Future<UserCredential> signInWithEmail(
      {required String email, required String password}) {
    return FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  static Future<UserCredential> createUserWithEmail(
      {required String email, required String password}) {
    return FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  static Future<void> signOut(BuildContext context) async {
    await context.read<AppInfoBloc>().clear();
    await FirebaseAuth.instance.signOut();
  }
}
