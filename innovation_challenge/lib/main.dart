import 'package:DigiHealth/digidietPage.dart';
import 'package:DigiHealth/digifitPage.dart';
import 'package:DigiHealth/groupChat.dart';
import 'package:DigiHealth/groupLeaderboard.dart';
import 'package:DigiHealth/groupSettings.dart';
import 'package:DigiHealth/introScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:DigiHealth/mainPageController.dart';
import 'package:DigiHealth/signUpPage.dart';
import 'package:flutter/services.dart';
import 'welcomePage.dart';
import 'provider_widget.dart';
import 'package:DigiHealth/services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return Provider(
      auth: AuthService(),
      child: CupertinoApp(
          localizationsDelegates: [
            DefaultMaterialLocalizations.delegate,
            DefaultCupertinoLocalizations.delegate,
            DefaultWidgetsLocalizations.delegate,
          ],
          // builder: (context, child) {
          //   final mediaQueryData = MediaQuery.of(context);
          //   final scale = mediaQueryData.textScaleFactor.clamp(1.0, 1.1);
          //   return MediaQuery(
          //     child: child,
          //     data: MediaQuery.of(context).copyWith(textScaleFactor: scale),
          //   );
          // },
          builder: (context, child) {
            return MediaQuery(
              child: child,
              data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            );
          },
          debugShowCheckedModeBanner: false,
          theme: CupertinoThemeData(
            brightness: Brightness.dark,
            textTheme: CupertinoTextThemeData(
                navLargeTitleTextStyle: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 40.0,
              color: const Color(0x242424),
            )),
          ),
          home: HomeController(),
          routes: <String, WidgetBuilder>{
            '/signUp': (BuildContext context) =>
                SignUpPage(authFormType: AuthFormType.signUp),
            '/signIn': (BuildContext context) =>
                SignUpPage(authFormType: AuthFormType.signIn),
            '/home': (BuildContext context) => HomeController(),
            '/digifit': (BuildContext context) => DigiFitPage(),
            '/digidiet': (BuildContext context) => DigiDietPage(),
            '/welcome': (BuildContext context) => WelcomePage(),
          }),
    );
  }
}

class HomeController extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AuthService auth = Provider.of(context).auth;
    return StreamBuilder(
      stream: auth.onAuthStateChanged,
      builder: (context, AsyncSnapshot<String> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final bool signedIn = snapshot.hasData;
          return signedIn ? MainPageController() : IntroScreen();
        }
        return CupertinoActivityIndicator();
      },
    );
  }
}
