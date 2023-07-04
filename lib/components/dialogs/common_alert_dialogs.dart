import 'package:f151/services/auth/auth_helper.dart';
import 'package:flutter/material.dart';

class CommonAlertDialogs {
  static Future loadingScreen({required BuildContext context}) async =>
      await showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) => WillPopScope(
              onWillPop: () async => false,
              child: Center(
                  child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                      width: 50,
                      child: Image.asset('assets/images/logo/logo.png')),
                  const SizedBox(
                    height: 16,
                  ),
                  const CircularProgressIndicator(),
                ],
              ))));
  static forgotPassword(BuildContext context) => showDialog(
        context: context,
        builder: (BuildContext context) {
          final resetEmailController = TextEditingController();
          final formKey = GlobalKey<FormState>();
          return AlertDialog(
            title: const Text('Şifre Sıfırlama'),
            content: Form(
              key: formKey,
              child: TextFormField(
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
                controller: resetEmailController,
                decoration:
                    const InputDecoration(hintText: 'Email adresinizi girin'),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('İptal'),
              ),
              TextButton(
                onPressed: () {
                  final isValid = formKey.currentState!.validate();
                  if (isValid) {
                    AuthHelper.sendPassResetEmail(resetEmailController.text)
                        .then((value) {
                      // Show a success message to the user
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Password reset email sent')));
                    }).catchError((error) {
                      // Show an error message to the user
                      if (error.code == 'user-not-found') {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text(
                                'Email address not associated with an account')));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Error resetting password: $error')));
                      }
                    }).then((value) => Navigator.pop(context));
                  }
                },
                child: const Text('Gönder'),
              ),
            ],
          );
        },
      );
}
