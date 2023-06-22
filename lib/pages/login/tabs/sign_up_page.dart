import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:f151/constants/constants.dart';
import 'package:f151/models/person_model.dart';
import 'package:f151/services/auth/auth_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Form(
          key: formKey, // Assigning form key
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircleAvatar(
                minRadius: 50,
                backgroundColor: kAppBarBackgroundColor,
                child: Icon(
                  Icons.person,
                  size: 100,
                ),
              ),
              const SizedBox(height: 10),
              // full name
              TextFormField(
                controller: nameController,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
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
                decoration: InputDecoration(
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
              const SizedBox(height: 10),
              // password
              TextFormField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  filled: true,
                  hintText: 'Şifre',
                  hintStyle: TextStyle(color: Colors.grey[500]),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen bir şifre girin.';
                  }
                  if (value.length < 6) {
                    return 'Şifreniz en az 6 karakter olmalıdır.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              // confirm password
              TextFormField(
                controller: confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  filled: true,
                  hintText: 'Şifre Onayla',
                  hintStyle: TextStyle(color: Colors.grey[500]),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen şifreyi onaylayın.';
                  }
                  if (value != passwordController.text) {
                    return 'Şifreler uyuşmuyor.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    // Validate the form
                    try {
                      // Kayıt işlemi
                      await AuthHelper.createUserWithEmail(
                              email: emailController.text,
                              password: passwordController.text)
                          .then((value) async {
                        final userId = FirebaseAuth.instance.currentUser!.uid;
                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(userId)
                            .set(PersonModel(
                              id: userId,
                              name: nameController.text,
                              email: emailController.text,
                              phone: phoneController.text,
                              createDate: DateTime.now(),
                              lastEditedDate: DateTime.now(),
                            ).toMap());
                      });
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'weak-password') {
                        // Şifre zayıf hatası
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                'Şifre zayıf. Lütfen daha güçlü bir şifre seçin.'),
                          ),
                        );
                      } else if (e.code == 'email-already-in-use') {
                        // Email zaten kullanımda hatası
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                'Bu email adresi ile daha önce kayıt olunmuş.'),
                          ),
                        );
                      } else if (e.code == 'invalid-email') {
                        // Geçersiz email hatası
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content:
                                Text('Geçersiz bir email adresi girdiniz.'),
                          ),
                        );
                      } else {
                        // Diğer hata durumları
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content:
                                Text('Kayıt işlemi sırasında bir hata oluştu.'),
                          ),
                        );
                      }
                    }
                  }
                },
                child: const Text('Kayıt Ol'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
