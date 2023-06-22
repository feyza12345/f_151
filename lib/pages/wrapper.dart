import 'dart:async';

import 'package:f151/bloc/app_info_bloc.dart';
import 'package:f151/components/custom_widgets.dart';
import 'package:f151/constants/app_methods.dart';
import 'package:f151/constants/constants.dart';
import 'package:f151/pages/home/frame.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Wrapper extends StatelessWidget {
  /// The Wrapper class is a stateless widget that checks the user's login status and
  /// displays different screens based on the result.
  /// Wrapper sinifi bir stateless widget olup kullanicinin uygulamaya giris durumunu kontrol eder
  /// ve bunun sonucuna gore farkli ekranlar doner.
  /// AnimatedSwitcher widget'lari sayfalar arasindaki degisiklik esnasinda
  /// animasyonlu gecisi saglar.
  const Wrapper({super.key});
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        //Kullanicinin login status'unu stream eder.
        stream: FirebaseAuth.instance.authStateChanges().asBroadcastStream(),
        builder: (context, connectionSnapshot) {
          return AnimatedSwitcher(
            duration: kThemeAnimationDuration,
            transitionBuilder: kDefaultPageTransition,
            //Baglanti bekleniyor durumunda
            child: connectionSnapshot.connectionState == ConnectionState.waiting
                ? const Material(
                    child: Material(
                        child: Center(child: CircularProgressIndicator())))
                //baglantidan data geldiginde (Giris yapildiginda)
                : connectionSnapshot.hasData
                    ? FutureBuilder(
                        //Firestore'dan kullanici bilgileri cekilir ve bloc'a yazilir.
                        future: context.read<AppInfoBloc>().refresh(),
                        builder: (context, userDataSnapshot) {
                          //islem devam ederken
                          return !userDataSnapshot.hasData
                              ? AnimatedSwitcher(
                                  duration: kThemeAnimationDuration,
                                  transitionBuilder: kDefaultPageTransition,
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
                              //islem tamamlandiginda kDefaultSplashDelay hosgeldin splash'i gosterir
                              : FutureBuilder(
                                  future: Future.delayed(kDefaultSplashDuration)
                                      .then((value) => 'done'),
                                  builder: (context, snapshot) {
                                    return AnimatedSwitcher(
                                        duration: 1.seconds,
                                        transitionBuilder:
                                            kDefaultPageTransition,
                                        child: !snapshot.hasData
                                            ? CustomWidgets
                                                .wellcomeSplashScreen(
                                                    userDataSnapshot)
                                            : const Frame());
                                  });
                        })
                    //bir hata yasandiginda
                    : connectionSnapshot.hasError
                        ? const Center(
                            child: Text('Bir seyler ters gitti :('),
                          )
                        //login yapilmamissa
                        : const Frame(),
          );
        });
  }
}
