import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:f151/bloc/ads_bloc.dart';
import 'package:f151/bloc/app_info_bloc.dart';
import 'package:f151/bloc/chat_bloc.dart';
import 'package:f151/components/custom_widgets.dart';
import 'package:f151/pages/home/profile/create_advertisement/create_advertisement.dart';
import 'package:f151/pages/login/login_page.dart';
import 'package:f151/services/auth/auth_helper.dart';
import 'package:f151/services/onesignal/one_signal_api.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  ProfileState createState() => ProfileState();
}

class ProfileState extends State<Profile> {
  final String? userId = FirebaseAuth.instance.currentUser?.uid;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomWidgets.appBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset('assets/images/logo/logo.png'),
        ),
        title: Text(
          userId != null ? 'Profil' : 'Giriş Yap',
          key: const ValueKey('appNameHomepage'),
        ),
        actions: [
          IconButton(onPressed: () => null, icon: Icon(MdiIcons.dotsVertical))
        ],
      ),
      body: userId == null
          ? const LoginPage()
          : Center(
              child: BlocBuilder<AppInfoBloc, AppInfoState>(
                  builder: (context, state) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        CircleAvatar(
                          backgroundColor:
                              const Color.fromRGBO(143, 110, 196, 1),
                          radius: 50,
                          backgroundImage: state.currentPerson.imageUrl == null
                              ? null
                              : NetworkImage(state.currentPerson.imageUrl!),
                          child: const Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 70,
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        Text(
                          state.currentPerson.name,
                          style: const TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          'E-posta: ${state.currentPerson.email}',
                          style: const TextStyle(fontSize: 16.0),
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          'Telefon: ${state.currentPerson.phone}',
                          style: const TextStyle(fontSize: 16.0),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        TextButton(
                          onPressed: () {
                            context.read<AppInfoBloc>().setPageIndex(1);
                          },
                          child: const Text(
                            'Mesajlar',
                            style: TextStyle(
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            // Bildirimler sayfasına yönlendirme kodu buraya gelecek
                          },
                          child: const Text(
                            'Bildirimler',
                            style: TextStyle(
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const CreateAdvertisement(),
                            ),
                          ),
                          child: const Text(
                            'İlan Ver',
                            style: TextStyle(
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            // Ayarlar sayfasına yönlendirme kodu buraya gelecek
                          },
                          child: const Text(
                            'Ayarlar',
                            style: TextStyle(
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: ElevatedButton(
                        onPressed: () async {
                          final currentPerson =
                              context.read<AppInfoBloc>().state.currentPerson;
                          final newNotificaitonIds = [
                            ...currentPerson.notificationIds
                          ];
                          final thisDevicePlayerId =
                              await OneSignalApi.getPlayerId;
                          newNotificaitonIds.remove(thisDevicePlayerId);
                          final newPerson = currentPerson.copyWith(
                              notificationIds: newNotificaitonIds);
                          context
                            ..read<AppInfoBloc>().clear()
                            ..read<AdsBloc>().clear()
                            ..read<ChatBloc>().clear();
                          await FirebaseFirestore.instance
                              .collection('users')
                              .doc(FirebaseAuth.instance.currentUser!.uid)
                              .set(newPerson.toMap())
                              .then((value) => AuthHelper.signOut(context));
                        },
                        child: const Text('Çıkış Yap'),
                      ),
                    ),
                  ],
                );
              }),
            ),
    );
  }
}
