import 'dart:async';

import 'package:f151/bloc/app_info_bloc.dart';
import 'package:f151/constants/app_methods.dart';
import 'package:f151/pages/home/switcher_frame.dart';
import 'package:f151/pages/login/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({super.key});

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  final Stream _checkLogin =
      FirebaseAuth.instance.authStateChanges().asBroadcastStream();

  @override
  Widget build(BuildContext context) => StreamBuilder(
      stream: _checkLogin,
      builder: (context, connectionSnapshot) {
        return AnimatedSwitcher(
          duration: kThemeAnimationDuration,
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(
              opacity: Tween<double>(
                begin: 0,
                end: 1,
              ).animate(animation),
              child: child,
            );
          },
          child: connectionSnapshot.connectionState == ConnectionState.waiting
              ? const Material(
                  child: Material(
                      child: Center(child: CircularProgressIndicator())))
              : connectionSnapshot.hasData
                  ? FutureBuilder(
                      future: context.read<AppInfoBloc>().refresh(),
                      builder: (context, userDataSnapshot) {
                        return !userDataSnapshot.hasData
                            ? AnimatedSwitcher(
                                duration: kThemeAnimationDuration,
                                transitionBuilder: (Widget child,
                                    Animation<double> animation) {
                                  return FadeTransition(
                                    opacity: Tween<double>(
                                      begin: 0,
                                      end: 1,
                                    ).animate(animation),
                                    child: child,
                                  );
                                },
                                child: Material(
                                    child: Center(
                                        child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SizedBox(
                                        width: 100,
                                        child: Image.asset(
                                            'assets/images/logo.png')),
                                    const SizedBox(
                                      height: 16,
                                    ),
                                    const CircularProgressIndicator(),
                                  ],
                                ))),
                              )
                            : FutureBuilder(
                                future:
                                    Future.delayed(const Duration(seconds: 2))
                                        .then((value) => 'done'),
                                builder: (context, snapshot) {
                                  return AnimatedSwitcher(
                                      duration: const Duration(seconds: 1),
                                      transitionBuilder:
                                          kDefaultPageTransition(),
                                      child: !snapshot.hasData
                                          ? wellcomeSplashScreen(
                                              userDataSnapshot)
                                          : const SwitcherFrame());
                                });
                      })
                  : connectionSnapshot.hasError
                      ? const Center(
                          child: Text('Bir seyler ters gitti :('),
                        )
                      : const LoginPage(),
        );
      });

  Material wellcomeSplashScreen(AsyncSnapshot<AppInfoState> userDataSnapshot) {
    return Material(
        child: Center(
            child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(width: 100, child: Image.asset('assets/images/logo.png')),
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
          userDataSnapshot.data!.userName,
          style: const TextStyle(fontSize: 20),
        ),
      ],
    )));
  }
}
