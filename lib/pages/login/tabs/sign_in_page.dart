import 'package:f151/components/dialogs/common_alert_dialogs.dart';
import 'package:f151/constants/constants.dart';
import 'package:f151/services/auth/auth_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  TextEditingController emailController = TextEditingController(text: '');
  TextEditingController passwordController = TextEditingController(text: '');
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(35),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                height: 10,
              ),
              const Center(
                child: SizedBox(
                  height: 200,
                  child: Image(image: AssetImage("assets/images/logo.png")),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Form(
                key: formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: emailController,
                      obscureText: false,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Bu alan boş bırakılamaz';
                        }
                        if (value == '') return null;
                        final bool emailValid = RegExp(
                                r"^[a-zA-Z0-9.a-zA-Z0-9!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(value);
                        if (!emailValid) {
                          return 'Geçersiz email adresi';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        filled: true,
                        hintText: 'Email',
                        hintStyle: TextStyle(color: Colors.grey[500]),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        filled: true,
                        hintText: 'Şifre',
                        hintStyle: TextStyle(color: Colors.grey[500]),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            try {
                              // Giriş işlemi
                              await AuthHelper.signInWithEmail(
                                  email: emailController.text,
                                  password: passwordController.text);
                            } on FirebaseAuthException catch (e) {
                              if (e.code == 'invalid-email') {
                                // Geçersiz email hatası
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        'Geçersiz bir email adresi girdiniz.'),
                                  ),
                                );
                              } else if (e.code == 'user-disabled') {
                                // Kullanıcı devre dışı bırakılmış hatası
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        'Hesabınız devre dışı bırakılmış durumda.'),
                                  ),
                                );
                              } else if (e.code == 'user-not-found' ||
                                  e.code == 'wrong-password') {
                                // Kullanıcı bulunamadı veya yanlış şifre hatası
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content:
                                        Text('Email adresi veya şifre hatalı.'),
                                  ),
                                );
                              } else {
                                // Diğer hata durumları
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        'Giriş işlemi sırasında bir hata oluştu.'),
                                  ),
                                );
                              }
                            } catch (e) {
                              // Genel hata durumu
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      'Giriş işlemi sırasında bir hata oluştu.'),
                                ),
                              );
                            }
                          }
                        },
                        child: const Text(
                          'Giriş yap',
                          style: TextStyle(fontSize: 17),
                        )),
                    //forgot Password
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RichText(
                          text: TextSpan(
                            text: 'Şifremi unuttum?',
                            style: const TextStyle(
                              color: kLinkTextColor,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () =>
                                  CommonAlertDialogs.forgotPassword(context),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
