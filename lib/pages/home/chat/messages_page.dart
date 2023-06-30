import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:f151/bloc/app_info_bloc.dart';
import 'package:f151/bloc/messages_bloc.dart';
import 'package:f151/models/chat_model.dart';
import 'package:f151/models/messages_model.dart';
import 'package:f151/models/person_model.dart';
import 'package:f151/services/onesignal/one_signal_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class MessagesPage extends StatefulWidget {
  final String? adId;
  final String otherUserId;

  const MessagesPage({required this.otherUserId, this.adId, Key? key})
      : super(key: key);

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  bool isLoading = true;
  StreamSubscription? messagesStream;
  late PersonModel otherUser;
  late PersonModel currentUser;

  String? docId;

  @override
  void initState() {
    super.initState();
    currentUser = context.read<AppInfoBloc>().state.currentPerson;
    FirebaseFirestore.instance
        .collection('users')
        .doc(widget.otherUserId)
        .get()
        .then((value) {
      final doc = value.data();
      if (doc != null) {
        otherUser = PersonModel.fromMap(doc);
      }
    }).then((_) async {
      docId = await FirebaseFirestore.instance
          .collection('chats')
          .where('participantIds', isEqualTo: [otherUser.id, currentUser.id])
          .get()
          .then((value) async => value.docs.isNotEmpty
              ? value.docs.first.id
              : await FirebaseFirestore.instance
                  .collection('chats')
                  .where('participantIds',
                      isEqualTo: [currentUser.id, otherUser.id])
                  .get()
                  .then((value) =>
                      value.docs.isNotEmpty ? value.docs.first.id : null));
      if (docId != null) {
        messagesStream = FirebaseFirestore.instance
            .collection('chats')
            .doc(docId)
            .collection('messages')
            .orderBy('timestamp', descending: false)
            .snapshots()
            .listen((event) {
          if (event.docs.isNotEmpty) {
            final docList = event.docs.map((e) => e.data()).toList();
            final messages =
                docList.map((doc) => MessagesModel.fromMap(doc)).toList();
            context.read<MessagesBloc>().load(messages);
          }
        });
      }
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  void dispose() {
    if (messagesStream != null) messagesStream!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final messageController = TextEditingController();
    final theme = Theme.of(context);
    final bubbleColor = theme.colorScheme.primary;
    final myBubbleColor =
        theme.colorScheme.primary.withBlue(-100).withRed(-100).withGreen(170);
    final textColor = theme.colorScheme.onPrimary;
    final timestampColor = theme.colorScheme.onPrimary.withOpacity(0.6);

    return WillPopScope(
      onWillPop: () async {
        context.read<MessagesBloc>().clear();
        return true;
      },
      child: isLoading
          ? const Material(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : Scaffold(
              appBar: AppBar(
                titleSpacing: 0,
                title: Row(
                  children: [
                    const CircleAvatar(
                      radius: 20,
                      child: Icon(
                        Icons.person,
                        size: 30,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(otherUser.name),
                  ],
                ),
              ),
              body: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      reverse: true,
                      child: BlocBuilder<MessagesBloc, List<MessagesModel>>(
                        builder: (context, state) => ListView.builder(
                          itemCount: state.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            final date = state[index].timestamp;
                            final newDate =
                                DateTime(date.year, date.month, date.day);
                            final message = state[index];
                            final isMessageFromCurrentUser =
                                message.senderId == currentUser.id;
                            final content = message.content;
                            final alignment = isMessageFromCurrentUser
                                ? Alignment.centerRight
                                : Alignment.centerLeft;
                            return Column(
                              children: [
                                index == 0 ||
                                        newDate.isAfter(DateTime(
                                            state[index - 1].timestamp.year,
                                            state[index - 1].timestamp.month,
                                            state[index - 1].timestamp.day))
                                    ? Column(
                                        children: [
                                          const SizedBox(
                                              height:
                                                  8.0), // Mesajların üstünde bir boşluk bırakılıyor
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                    color: bubbleColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            40)),
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 10.0,
                                                      vertical: 5),
                                                  child: Text(
                                                    DateFormat('d MMMM y')
                                                        .format(date),
                                                    style: TextStyle(
                                                        color: textColor),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      )
                                    : const SizedBox(),
                                Align(
                                  alignment: alignment,
                                  child: Container(
                                    margin: EdgeInsets.only(
                                        top: 4.0,
                                        bottom: 4.0,
                                        right: isMessageFromCurrentUser
                                            ? 8.0
                                            : 50.0,
                                        left: isMessageFromCurrentUser
                                            ? 50
                                            : 8.0),
                                    padding: const EdgeInsets.all(8.0),
                                    decoration: BoxDecoration(
                                      color: isMessageFromCurrentUser
                                          ? myBubbleColor
                                          : bubbleColor,
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          isMessageFromCurrentUser
                                              ? CrossAxisAlignment.start
                                              : CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          content,
                                          style: TextStyle(
                                            fontSize: 16.0,
                                            color: textColor,
                                          ),
                                        ),
                                        const SizedBox(height: 4.0),
                                        Text(
                                          DateFormat('HH:mm')
                                              .format(message.timestamp),
                                          style: TextStyle(
                                            fontSize: 10.0,
                                            color: timestampColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Row(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            // + düğmesinin işlevselliği burada tanımlanır
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            minimumSize: const Size(45, 45),
                          ),
                          child: const Icon(Icons.add),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Expanded(
                          child: TextField(
                            controller: messageController,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 10),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25)),
                              filled: true,
                            ),
                            minLines: 1,
                            maxLines: 6,
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            final message = messageController.text;
                            if (message.isEmpty) return;
                            final messageModel = MessagesModel(
                              senderId: currentUser.id,
                              content: message,
                              timestamp: DateTime.now(),
                            );
                            messageController.clear();
                            if (docId == null) {
                              docId = FirebaseFirestore.instance
                                  .collection('chats')
                                  .doc()
                                  .id;
                              await FirebaseFirestore.instance
                                  .collection('chats')
                                  .doc(docId)
                                  .set(
                                    ChatModel(participantIds: [
                                      otherUser.id,
                                      currentUser.id
                                    ], lastMessage: messageModel)
                                        .toMap(),
                                  )
                                  .then((_) async {
                                messagesStream = FirebaseFirestore.instance
                                    .collection('chats')
                                    .doc(docId)
                                    .collection('messages')
                                    .orderBy('timestamp', descending: false)
                                    .snapshots()
                                    .listen((event) {
                                  if (event.docs.isNotEmpty) {
                                    final docList = event.docs
                                        .map((e) => e.data())
                                        .toList();
                                    final messages = docList
                                        .map(
                                            (doc) => MessagesModel.fromMap(doc))
                                        .toList();
                                    context.read<MessagesBloc>().load(messages);
                                  }
                                });
                                await FirebaseFirestore.instance
                                    .collection('chats')
                                    .doc(docId)
                                    .collection('messages')
                                    .doc()
                                    .set(
                                      messageModel.toMap(),
                                    )
                                    .then((value) async => await Future.forEach(
                                        otherUser.notificationIds,
                                        (id) => OneSignalApi
                                            .sendMessageNotification(
                                                message: messageModel,
                                                userName: otherUser.id,
                                                otherUserNotificationId: id)));
                              });
                            } else {
                              await FirebaseFirestore.instance
                                  .collection('chats')
                                  .doc(docId)
                                  .set({'lastMessage': messageModel.toMap()},
                                      SetOptions(merge: true));
                              await FirebaseFirestore.instance
                                  .collection('chats')
                                  .doc(docId)
                                  .collection('messages')
                                  .doc()
                                  .set(
                                    MessagesModel(
                                      senderId: currentUser.id,
                                      content: message,
                                      timestamp: DateTime.now(),
                                    ).toMap(),
                                  );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40)),
                            minimumSize: const Size(45, 45),
                          ),
                          child: const Icon(Icons.send),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
