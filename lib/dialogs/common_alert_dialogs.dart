import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CommonAlertDialogs {
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
              ElevatedButton(
                onPressed: () {
                  final isValid = formKey.currentState!.validate();
                  if (isValid) {
                    FirebaseAuth.instance
                        .sendPasswordResetEmail(
                            email: resetEmailController.text)
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
