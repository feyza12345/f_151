import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:f151/bloc/ads_bloc.dart';
import 'package:f151/bloc/app_info_bloc.dart';
import 'package:f151/bloc/chat_bloc.dart';
import 'package:f151/models/chat_model.dart';
import 'package:f151/models/messages_model.dart';
import 'package:f151/pages/home/categories/categories.dart';
import 'package:f151/pages/home/chat/chat.dart';
import 'package:f151/pages/home/homepage/homepage.dart';
import 'package:f151/pages/home/profile/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Frame extends StatefulWidget {
  const Frame({super.key});

  @override
  State<Frame> createState() => _FrameState();
}

class _FrameState extends State<Frame> {
  StreamSubscription? chatMessagesStream;
  String? userId;

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
    final userId = FirebaseAuth.instance.currentUser?.uid;
    chatMessagesStream = FirebaseFirestore.instance
        .collection('chats')
        .where('participantIds', arrayContains: userId)
        .snapshots()
        .listen((event) async {
      if (event.docs.isEmpty) return;
      final List<ChatModel> chatModelList = [];

      if (userId != null) {
        await Future.forEach(
          event.docs,
          (e) async {
            var chatModel = ChatModel.fromMap(e.data());
            final lastMessageFromFirebase = await FirebaseFirestore.instance
                .collection('chats')
                .doc(e.id)
                .collection('messages')
                .orderBy('timestamp', descending: true)
                .limit(1)
                .get()
                .then((value) {
              if (value.docs.isNotEmpty) {
                return value.docs.first.data();
              }
            });
            if (lastMessageFromFirebase != null) {
              final lastMessage =
                  MessagesModel.fromMap(lastMessageFromFirebase);
              chatModel.copyWith(lastMessage: lastMessage);
            }
            chatModelList.add(chatModel);
          },
        ).then((value) => context.read<ChatBloc>().refresh(chatModelList));
      }
    });
    context.read<AdsBloc>().refresh();
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
                    duration: 500.ms,
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
