import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:f151/bloc/app_info_bloc.dart';
import 'package:f151/bloc/chat_bloc.dart';
import 'package:f151/models/chat_message.dart';
import 'package:f151/pages/home/categories/categories.dart';
import 'package:f151/pages/home/chat/chat.dart';
import 'package:f151/pages/home/homepage/homepage.dart';
import 'package:f151/pages/home/profile/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Frame extends StatefulWidget {
  const Frame({super.key});

  @override
  State<Frame> createState() => _FrameState();
}

class _FrameState extends State<Frame> {
  StreamSubscription? chatMessagesStream;

  final pages = [
    const Homepage(),
    const Chat(),
    const Categories(),
    const Profile(),
  ];

  void onItemTapped(int index) {
    setState(() {
      context.read<AppInfoBloc>().setPageIndex(index);
    });
  }

  @override
  void initState() {
    final isTeacher = context.read<AppInfoBloc>().state.isTeacher;
    final userUID = FirebaseAuth.instance.currentUser!.uid;
    final Map<String, List<ChatMessage>> newState = {};
    chatMessagesStream = FirebaseFirestore.instance
        .collection('chat')
        .where(isTeacher ? 'teacherUID' : 'studentUID', isEqualTo: userUID)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .listen((event) {
      if (event.docs.isEmpty) return;
      final chatMessages = event.docs
          .map(
            (e) => ChatMessage.fromMap(e.data()),
          )
          .toList();
      final allOtherUIDs = chatMessages
          .map((e) => e.studentUID != userUID ? e.studentUID : e.teacherUID)
          .toSet()
          .toList();
      for (var otherUID in allOtherUIDs) {
        newState[otherUID] = chatMessages
            .where((e) => (isTeacher ? e.studentUID : e.teacherUID) == otherUID)
            .toList();
      }
      context.read<ChatBloc>().refresh(newState);
    });
    super.initState();
  }

  @override
  void dispose() {
    chatMessagesStream!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          final currentIndex = context.read<AppInfoBloc>().state.pageIndex;
          if (currentIndex == 0) {
            return true;
          } else {
            onItemTapped(currentIndex - 1);
            return false;
          }
        },
        child: BlocBuilder<AppInfoBloc, AppInfoState>(
          builder: (context, state) => Scaffold(
            body: Column(
              children: [
                Expanded(
                  flex: 1,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    transitionBuilder:
                        (Widget child, Animation<double> animation) {
                      return FadeTransition(
                        opacity: Tween<double>(
                          begin: 0,
                          end: 1,
                        ).animate(animation),
                        child: child,
                      );
                    },
                    child: pages[state.pageIndex],
                  ),
                ),
              ],
            ),
            bottomNavigationBar: BottomNavigationBar(
              elevation: 0,
              type: BottomNavigationBarType.fixed,
              currentIndex: state.pageIndex,
              onTap: (index) {
                setState(() {
                  onItemTapped(index);
                });
              },
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Anasayfa',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.chat),
                  label: 'Sohbetler',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.apps),
                  label: 'Kategoriler',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'Profil',
                ),
              ],
            ),
          ),
        ));
  }
}
