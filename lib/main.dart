import 'package:f151/bloc/ads_bloc.dart';
import 'package:f151/bloc/app_info_bloc.dart';
import 'package:f151/bloc/chat_bloc.dart';
import 'package:f151/bloc/messages_bloc.dart';
import 'package:f151/constants/constants.dart';
import 'package:f151/pages/wrapper.dart';
import 'package:f151/services/firebase_options.dart';
import 'package:f151/services/onesignal/one_signal_api.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //Firebase init
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  OneSignalApi.setupOneSignal();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return MultiBlocProvider(
      providers: [
        //Bloc Providers
        BlocProvider(create: (context) => AppInfoBloc()),
        BlocProvider(create: (context) => ChatBloc()),
        BlocProvider(create: (context) => AdsBloc()),
        BlocProvider(create: (context) => MessagesBloc())
      ],
      child: MaterialApp(
          //disable debug banner
          debugShowCheckedModeBanner: false,
          //App widgets default theme settings
          theme: ThemeData(
              brightness: Brightness.light,
              //Bu renge uyumlu olacak sekilde standart renk paletini degistirir (asagida belirttigimiz temalar haric).
              colorSchemeSeed: kAppSchemeSeedColor,
              elevatedButtonTheme: ElevatedButtonThemeData(
                //Elevated button custom style theme
                style: ElevatedButton.styleFrom(
                  //Button minimum boyutu(yatayda parent sinirlarina )
                  minimumSize: const Size(double.infinity, 45),
                  shape: RoundedRectangleBorder(
                    //Yumusak kenar ayari
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              //AppBar button custom style theme
              appBarTheme:
                  const AppBarTheme(backgroundColor: kAppBarBackgroundColor)),
          darkTheme: ThemeData(
            //Dark Theme settings
            brightness: Brightness.dark,
            colorSchemeSeed: kAppSchemeSeedColor,
            elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 45),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)))),
          ),
          home: const Wrapper()),
    );
  }
}
