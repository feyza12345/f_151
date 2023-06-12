import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Profile'),
          ElevatedButton(
              onPressed: () => FirebaseAuth.instance.signOut(),
              child: const Text('Cıkıs Yap'))
        ],
      )),
    );
  }
}
