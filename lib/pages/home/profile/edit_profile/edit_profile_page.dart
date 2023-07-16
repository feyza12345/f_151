import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:f151/bloc/app_info_bloc.dart';
import 'package:f151/components/custom_widgets.dart';
import 'package:f151/components/dialogs/common_alert_dialogs.dart';
import 'package:f151/components/photo_selector_widget.dart';
import 'package:f151/constants/constants.dart';
import 'package:f151/services/auth/auth_helper.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    final currentPerson = context.read<AppInfoBloc>().state.currentPerson;
    nameController.text = currentPerson.name;
    emailController.text = currentPerson.email;
    phoneController.text = currentPerson.phone;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomWidgets.appBar(
          title: const Text(
            'Profili Düzenle',
          ),
        ),
        body: BlocBuilder<AppInfoBloc, AppInfoState>(builder: (context, state) {
          final currentPerson = state.currentPerson;
          final userId = currentPerson.id;
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Form(
                key: formKey, // Assigning form key
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Stack(
                      children: [
                        CircleAvatar(
                          backgroundColor:
                              const Color.fromRGBO(143, 110, 196, 1),
                          radius: 80,
                          foregroundImage: currentPerson.imageUrl == null
                              ? null
                              : NetworkImage(currentPerson.imageUrl!),
                          child: currentPerson.imageUrl != null
                              ? null
                              : const Icon(
                                  Icons.person,
                                  size: 150,
                                  color: Colors.white,
                                ),
                        ),
                        Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                                height: 40,
                                decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white54),
                                child: FittedBox(
                                    fit: BoxFit.contain,
                                    child: IconButton(
                                        padding: EdgeInsets.zero,
                                        onPressed: () => PhotoSelectorWidget
                                                    .selectPhotoDialog(context)
                                                .then((value) async {
                                              if (value == null) return;
                                              CommonAlertDialogs.loadingScreen(
                                                  context: context);
                                              FirebaseStorage.instance
                                                  .ref('users')
                                                  .child('$userId/profile.jpg')
                                                  .putFile(File(value.path))
                                                  .snapshotEvents
                                                  .listen((event) async {
                                                if (event.state ==
                                                    TaskState.success) {
                                                  await event.ref
                                                      .getDownloadURL()
                                                      .then((url) {
                                                    var currentPerson = context
                                                        .read<AppInfoBloc>()
                                                        .state
                                                        .currentPerson
                                                        .copyWith(
                                                            lastEditedDate:
                                                                DateTime.now(),
                                                            imageUrl: url);
                                                    FirebaseFirestore.instance
                                                        .collection('users')
                                                        .doc(userId)
                                                        .set(currentPerson
                                                            .toMap())
                                                        .then((value) {
                                                      context
                                                          .read<AppInfoBloc>()
                                                          .refresh();
                                                      Navigator.of(context)
                                                          .pop();
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                              const SnackBar(
                                                                  content: Text(
                                                                      'Fotograf kaydedildi!')));
                                                    });
                                                  });
                                                } else if (event.state ==
                                                    TaskState.error) {
                                                  Navigator.of(context).pop();
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(const SnackBar(
                                                          content: Text(
                                                              'Fotograf yukleme basarisiz oldu')));
                                                }
                                              });
                                            }),
                                        icon: const Icon(
                                          Icons.edit,
                                          color: kAppBarBackgroundColor2,
                                          size: 30,
                                        ))))),
                        if (currentPerson.imageUrl != null)
                          Positioned(
                            left: 0,
                            bottom: 0,
                            child: Container(
                              height: 40,
                              decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white54),
                              child: FittedBox(
                                fit: BoxFit.contain,
                                child: IconButton(
                                  padding: EdgeInsets.zero,
                                  onPressed: () {
                                    CommonAlertDialogs.loadingScreen(
                                        context: context);
                                    FirebaseStorage.instance
                                        .ref('users')
                                        .child('$userId/profile.jpg')
                                        .delete()
                                        .then((value) {
                                      var currentPerson = context
                                          .read<AppInfoBloc>()
                                          .state
                                          .currentPerson
                                          .copyWith(
                                              lastEditedDate: DateTime.now(),
                                              imageUrl: null);
                                      FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(userId)
                                          .set(currentPerson.toMap())
                                          .then((value) {
                                        context.read<AppInfoBloc>().refresh();
                                        Navigator.of(context).pop();
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                                content:
                                                    Text('Fotograf silindi!')));
                                      });
                                    });
                                  },
                                  icon: const Icon(
                                    Icons.delete,
                                    size: 30,
                                    color: Colors.redAccent,
                                  ),
                                ),
                              ),
                            ),
                          )
                      ],
                    ),
                    const SizedBox(height: 10),
                    // full name
                    TextFormField(
                      controller: nameController,
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        label: const Text('İsim'),
                        filled: true,
                        hintText: 'Ad Soyad',
                        hintStyle: TextStyle(color: Colors.grey[500]),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Lütfen adınızı ve soyadınızı girin.';
                        }
                        if (!value.contains(' ')) {
                          return 'Lütfen tam adınızı girin (Ad ve soyad arasında boşluk olmalıdır).';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    // email
                    TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      enabled: false,
                      decoration: InputDecoration(
                        label: const Text('Email'),
                        filled: true,
                        hintText: 'Email',
                        hintStyle: TextStyle(color: Colors.grey[500]),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Lütfen bir email adresi girin.';
                        }
                        if (!RegExp(
                                r'^[\w-]+(\.[\w-]+)*@([a-z\d-]+(\.[a-z\d-]+)*\.)+[a-z]{2,}$')
                            .hasMatch(value)) {
                          return 'Lütfen geçerli bir email adresi girin.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    // phone
                    TextFormField(
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: InputDecoration(
                        label: const Text('Telefon Numarası'),
                        filled: true,
                        hintText: 'Telefon Numarası',
                        hintStyle: TextStyle(color: Colors.grey[500]),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Lütfen bir telefon numarası girin.';
                        }
                        RegExp regex = RegExp(
                            r'^((\+|00)?90[\s-]?)?[1-9]\d{2}[\s-]?\d{3}[\s-]?\d{2}[\s-]?\d{2}$');

                        if (!regex.hasMatch(value)) {
                          return 'Geçerli bir telefon numarası girin.';
                        }
                        return null;
                      },
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                          onPressed: () =>
                              AuthHelper.sendPassResetEmail(currentPerson.email)
                                  .then((value) => ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                          content:
                                              Text('E-posta gönderildi')))),
                          child: const Text('Şifreni sıfırla')),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          CommonAlertDialogs.loadingScreen(context: context);
                          await FirebaseFirestore.instance
                              .collection('users')
                              .doc(userId)
                              .set(currentPerson
                                  .copyWith(
                                    name: nameController.text,
                                    phone: phoneController.text,
                                    lastEditedDate: DateTime.now(),
                                  )
                                  .toMap())
                              .then((value) => context
                                  .read<AppInfoBloc>()
                                  .refresh()
                                  .then((value) => Navigator.of(context)
                                    ..pop()
                                    ..pop()))
                              .then((value) => ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                      content:
                                          Text('Değişiklikler kaydedildi'))));
                        }
                      },
                      child: const Text('Kaydet'),
                    ),
                    Text(
                        'Son güncelleme: ${DateFormat('dd/MM/yyyy : HH:mm').format(currentPerson.lastEditedDate)}')
                  ],
                ),
              ),
            ),
          );
        }));
  }
}
