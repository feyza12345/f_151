import 'package:f151/bloc/app_info_bloc.dart';
import 'package:f151/constants/constants.dart';
import 'package:flutter/material.dart';

class CustomWidgets {
  static Material wellcomeSplashScreen(
      AsyncSnapshot<AppInfoState> userDataSnapshot) {
    return Material(
        child: Center(
            child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(width: 100, child: Image.asset('assets/images/logo/logo.png')),
        const SizedBox(
          height: 10,
        ),
        const Text(
          'Hoş Geldin',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 16,
        ),
        Text(
          userDataSnapshot.data!.currentPerson.name,
          style: const TextStyle(fontSize: 20),
        ),
      ],
    )));
  }

  static AppBar appBar(
      {Widget? leading,
      Widget? title,
      List<Widget>? actions,
      double? titleSpacing}) {
    return AppBar(
      titleSpacing: titleSpacing,
      centerTitle: true,
      leading: leading,
      title: title,
      actions: actions,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              kAppBarBackgroundColor2,
              kAppBarBackgroundColor1,
            ],
            begin: Alignment.bottomRight,
            end: Alignment.topLeft,
          ),
        ),
      ),
    );
  }
}
