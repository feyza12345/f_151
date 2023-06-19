import 'package:f151/bloc/app_info_bloc.dart';
import 'package:f151/pages/home/profile/create_advertisement/create_advertisement.dart';
import 'package:f151/services/auth/auth_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  ProfileState createState() => ProfileState();
}

class ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset('assets/images/logo.png'),
        ),
        title: const Text(
          'Profil',
          key: ValueKey('appNameHomepage'),
        ),
        actions: [
          IconButton(onPressed: () => null, icon: Icon(MdiIcons.dotsVertical))
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: BlocBuilder<AppInfoBloc, AppInfoState>(
                builder: (context, state) {
              return Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: state.currentPerson.imageUrl == null
                        ? null
                        : NetworkImage(state.currentPerson.imageUrl!),
                    child: const Icon(
                      Icons.person,
                      size: 100,
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
                    style: const TextStyle(fontSize: 18.0),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    'Telefon: ${state.currentPerson.phone}',
                    style: const TextStyle(fontSize: 18.0),
                  ),
                  ElevatedButton(
                      onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) =>
                                  const CreateAdvertisement())),
                      child: const Text('İlan Ver')),
                  ElevatedButton(
                      onPressed: () => AuthHelper.signOut(context),
                      child: const Text('Cıkıs Yap')),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}
