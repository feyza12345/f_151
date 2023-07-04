import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:f151/bloc/app_info_bloc.dart';
import 'package:f151/components/custom_widgets.dart';
import 'package:f151/constants/constants.dart';
import 'package:f151/models/chat_model.dart';
import 'package:f151/models/person_model.dart';
import 'package:f151/pages/home/chat/messages_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../bloc/chat_bloc.dart';

class Chat extends StatefulWidget {
  const Chat({super.key});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final searchController = TextEditingController();
  bool isSearching = false;
  final focusnode = FocusNode();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomWidgets.appBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset('assets/images/logo/logo.png'),
        ),
        title: AnimatedSwitcher(
          duration: kDefaultAnimationDuration,
          child: isSearching
              ? TextField(
                  controller: searchController,
                  focusNode: focusnode,
                  key: const ValueKey('searchbar'),
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.only(left: 10),
                      hintText: 'Ders ara',
                      filled: true,
                      fillColor: Colors.white),
                )
              : const Text(
                  'Mesajlar',
                  key: ValueKey('appNameHomepage'),
                ),
        ),
        actions: [
          AnimatedSwitcher(
            duration: kDefaultAnimationDuration,
            transitionBuilder: (Widget child, Animation<double> animation) {
              return ScaleTransition(
                scale: animation,
                child: child,
              );
            },
            child: isSearching
                ? IconButton(
                    key: const ValueKey('closeicon'),
                    onPressed: () => setState(() {
                          isSearching = false;
                          searchController
                              .clear(); // TextEditingController'ı temizle
                          FocusScope.of(context).unfocus(); // Klavyeyi kapat
                        }),
                    icon: const Icon(Icons.close))
                : IconButton(
                    key: const ValueKey('searchicon'),
                    onPressed: () => setState(() {
                          focusnode.requestFocus();
                          isSearching = true;
                        }),
                    icon: const Icon(Icons.search)),
          )
        ],
      ),
      body: BlocBuilder<ChatBloc, List<ChatModel>>(
        builder: (context, state) {
          final userId = FirebaseAuth.instance.currentUser?.uid;
          return userId == null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                          'Mesajlarınızı görebilmek için giriş yapmalısınız.'),
                      ElevatedButton(
                        onPressed: () =>
                            context.read<AppInfoBloc>().setPageIndex(3),
                        style: ElevatedButton.styleFrom(
                            minimumSize: const Size(45, 45)),
                        child: const Text('Giriş Yap'),
                      )
                    ],
                  ),
                )
              : state.isEmpty
                  ? const Center(
                      child: Text('Mesajınız bulunmuyor.'),
                    )
                  : ListView.separated(
                      itemCount: state.length,
                      separatorBuilder: (context, index) => const Divider(),
                      itemBuilder: (context, index) {
                        var otherUserUID = state[index]
                            .participantIds
                            .firstWhere((e) => e != userId);
                        return FutureBuilder(
                            future: FirebaseFirestore.instance
                                .collection('users')
                                .doc(otherUserUID)
                                .get(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else {
                                final user =
                                    PersonModel.fromMap(snapshot.data!.data()!);
                                final message = state[index].lastMessage;
                                return ListTile(
                                  contentPadding: const EdgeInsets.all(8),
                                  onTap: () => Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (context) => MessagesPage(
                                              otherUserId: otherUserUID))),
                                  leading: CircleAvatar(
                                      radius: 30,
                                      backgroundColor: kAppBarBackgroundColor2,
                                      foregroundImage: user.imageUrl == null
                                          ? null
                                          : NetworkImage(user.imageUrl!),
                                      child: user.imageUrl != null
                                          ? null
                                          : const Icon(
                                              Icons.person,
                                              size: 50,
                                              color: Colors.white,
                                            )),
                                  title: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          user.name,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(fontSize: 20),
                                        ),
                                        Text(
                                          message.content,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              color: Colors.grey[600]),
                                        )
                                      ]),
                                  trailing: Text(
                                    DateFormat('dd.MM.yyyy')
                                        .format(message.timestamp),
                                    style: const TextStyle(fontSize: 10),
                                  ),
                                );
                              }
                            });
                      });
        },
      ),
    );
  }
}
