import 'package:DigiHealth/provider_widget.dart';
import 'package:DigiHealth/services/auth_service.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:DigiHealth/appPrefs.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String username = "Loading";
  String email = "Loading";

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;
    setEmailNameText();
    return CupertinoPageScaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: secondaryColor,
        navigationBar: CupertinoNavigationBar(
            transitionBetweenRoutes: false,
            heroTag: "profilePage",
            middle: Text("Profile",
                style: TextStyle(color: Colors.white, fontFamily: 'Nunito')),
            backgroundColor: secondaryColor,
            leading: GestureDetector(
              child: Icon(
                Icons.circle,
                color: secondaryColor,
              ),
            ),
            trailing: GestureDetector(
              onTap: () async {
                try {
                  AuthService auth = Provider.of(context).auth;
                  await auth.signOut();
                } catch (e) {
                  print(e);
                }
              },
              child: Icon(
                Icons.exit_to_app_rounded,
                color: CupertinoColors.white,
                size: 30,
              ),
            )),
        child: Scaffold(
          backgroundColor: primaryColor,
          body: SingleChildScrollView(
            child: SafeArea(
                child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  SizedBox(
                    height: _height * 0.01,
                  ),
                  Text("Account Info",
                      style: TextStyle(
                          fontSize: 48,
                          color: Colors.white,
                          fontFamily: 'Nunito',
                          fontWeight: FontWeight.w200)),
                  SizedBox(
                    height: _height * 0.01,
                  ),
                  Container(
                    width: _width,
                    height: _height * 0.001,
                    color: secondaryColor,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text("Username: " + username,
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontFamily: 'Nunito',
                          fontWeight: FontWeight.w200)),
                  SizedBox(
                    height: 10,
                  ),
                  Text("Email: " + email,
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontFamily: 'Nunito',
                          fontWeight: FontWeight.w200)),
                  SizedBox(height: 30),
                  SizedBox(
                    height: _height * 0.01,
                  ),
                  AutoSizeText("Third Party Websites",
                      maxLines: 1,
                      style: TextStyle(
                          fontSize: 30,
                          color: Colors.white,
                          fontFamily: 'Nunito',
                          fontWeight: FontWeight.w200)),
                  SizedBox(
                    height: _height * 0.01,
                  ),
                  Container(
                    width: _width,
                    height: _height * 0.001,
                    color: secondaryColor,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  AutoSizeText(
                      "For DigiDiet, we use recipes from \"food.com\", \"ketodietapp.com\", \"simple-veganista.com\", and \"plantbasedcooking.com\", which are third-party websites that collect cookies. By opening the recipes, you are allowing these websites to collect cookies through this app.",
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontFamily: 'Nunito',
                          fontWeight: FontWeight.w200),
                      maxFontSize: 25,
                      minFontSize: 20,)
                ],
              ),
            )),
          ),
        ));
  }

  void setEmailNameText() async {
    final User user = Provider.of(context).auth.firebaseAuth.currentUser;
    setState(() {
      username = user.displayName;
      email = user.email;
    });
  }
}
