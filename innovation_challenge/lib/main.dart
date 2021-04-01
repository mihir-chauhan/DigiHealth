import 'package:DigiHealth/exercisePage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:DigiHealth/mainPageController.dart';
import 'package:DigiHealth/signUpPage.dart';
import 'welcomePage.dart';
import 'provider_widget.dart';
import 'package:DigiHealth/services/auth_service.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Provider(
      auth: AuthService(),
      child: CupertinoApp(
          debugShowCheckedModeBanner: false,
          theme: CupertinoThemeData(
            textTheme: CupertinoTextThemeData(
                navLargeTitleTextStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 40.0,
                  color: const Color(0x242424),
                )),
          ),
          home: HomeController(),
          routes: <String, WidgetBuilder>{
            '/signUp': (BuildContext context) => SignUpPage(authFormType: AuthFormType.signUp),
            '/signIn': (BuildContext context) => SignUpPage(authFormType: AuthFormType.signIn),
            '/home': (BuildContext context) => HomeController(),
            '/exercise': (BuildContext context) => ExercisePage(),
          }),
    );
  }
}

class HomeController extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AuthService auth = Provider
        .of(context)
        .auth;
    return StreamBuilder(
      stream: auth.onAuthStateChanged,
      builder: (context, AsyncSnapshot<String> snapshot) {
          if(snapshot.connectionState == ConnectionState.active) {
            final bool signedIn = snapshot.hasData;
            return signedIn ? HomePage() : WelcomePage();
          }
          return CupertinoActivityIndicator();
      },
    );

  }
}
