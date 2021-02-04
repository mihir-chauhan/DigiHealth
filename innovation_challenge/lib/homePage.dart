import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:DigiHealth/provider_widget.dart';
import 'package:DigiHealth/services/auth_service.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final primaryColor = const Color(0xFF75A2EA);

  final secondaryColor = const Color(0xFF5c7fb8);
  Icon homeIcon = Icon(Icons.home, color: Colors.white);
  Icon chatIcon = Icon(Icons.chat_bubble_outline_rounded, color: Colors.white);
  Icon profileIcon = Icon(Icons.person_outline_rounded, color: Colors.white);
  @override
  Widget build(BuildContext context) {


    return CupertinoTabScaffold(
        tabBar: CupertinoTabBar(
          backgroundColor: secondaryColor,
          items: [
            BottomNavigationBarItem(
                icon: homeIcon),
            BottomNavigationBarItem(
                icon: chatIcon),
            BottomNavigationBarItem(
                icon: profileIcon),
          ],
          onTap: (i) {
            if(i == 0) {
              print(0);
              setState(() {
                homeIcon = Icon(Icons.home, color: Colors.white);
                chatIcon = Icon(Icons.chat_bubble_outline_rounded, color: Colors.white);
                profileIcon = Icon(Icons.person_outline_rounded, color: Colors.white);
              });
            } else if(i == 1) {
              print(1);
              setState(() {
                homeIcon = Icon(Icons.home_outlined, color: Colors.white);
                chatIcon = Icon(Icons.chat, color: Colors.white);
                profileIcon = Icon(Icons.person_outline_rounded, color: Colors.white);
              });
            } else {
              print(2);
              setState(() {
                homeIcon = Icon(Icons.home_outlined, color: Colors.white);
                chatIcon = Icon(Icons.chat_bubble_outline_rounded, color: Colors.white);
                profileIcon = Icon(Icons.person, color: Colors.white);
              });
            }
          }
        ),
        tabBuilder: (context, i) {
          return CupertinoPageScaffold(
              backgroundColor: primaryColor,
              child: CustomScrollView(slivers: <Widget>[
                CupertinoSliverNavigationBar(
                  backgroundColor: primaryColor,
                  leading: GestureDetector(
                    onTap: () async {
                      debugPrint('Menu Tapped');
                      try {
                        AuthService auth = Provider.of(context).auth;
                        await auth.signOut();
                        print("Signed Out!");
                      } catch (e) {
                        print(e);
                      }
                    },
                    child: Icon(
                      Icons.exit_to_app_rounded,
                      color: CupertinoColors.white,
                      size: 35,
                    ),
                  ),
                  largeTitle: i == 0
                      ? Text("Home",
                          style: TextStyle(
                              color: Colors.white, fontFamily: 'Nunito'))
                      : i == 1
                          ? Text("Chat",
                              style: TextStyle(
                                  color: Colors.white, fontFamily: 'Nunito'))
                          : Text("Profile",
                              style: TextStyle(
                                  color: Colors.white, fontFamily: 'Nunito')),
                  trailing: GestureDetector(
                    onTap: () {},
                    child: Icon(
                      Icons.directions_run_rounded,
                      color: CupertinoColors.white,
                      size: 30,
                    ),
                  ),
                )
              ]));
        });
  }
}
