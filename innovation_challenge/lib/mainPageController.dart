import 'package:DigiHealth/chatPage.dart';
import 'package:DigiHealth/homePage.dart';
import 'package:DigiHealth/leaderboardPage.dart';
import 'package:DigiHealth/profilePage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MainPageController extends StatefulWidget {
  @override
  _MainPageControllerState createState() => _MainPageControllerState();
}

class _MainPageControllerState extends State<MainPageController> {
  final primaryColor = const Color(0xFF75A2EA);
  var tertiaryColor = const Color(0xFFFFFFFF);
  var hintColor = const Color(0xFF808080);

  final secondaryColor = const Color(0xFF5c7fb8);
  final quaternaryColor = const Color(0xFF395075);
  Icon homeIcon = Icon(Icons.home, color: Colors.white);
  Icon chatIcon = Icon(Icons.chat_bubble_outline_rounded, color: Colors.white);
  Icon leaderboardIcon = Icon(Icons.leaderboard_outlined, color: Colors.white);
  Icon profileIcon = Icon(Icons.person_outline_rounded, color: Colors.white);

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
        tabBar: CupertinoTabBar(
            backgroundColor: secondaryColor,
            items: [
              BottomNavigationBarItem(icon: homeIcon),
              BottomNavigationBarItem(icon: chatIcon),
              BottomNavigationBarItem(icon: leaderboardIcon),
              BottomNavigationBarItem(icon: profileIcon),
            ],
            onTap: (i) async {
              updateTabBarController(i);
            }),
        tabBuilder: (context, i) {
          if (i == 0) {
            return HomePage();
          } else if (i == 1) {
            return ChatPage();
          } else if (i == 2) {
            return LeaderboardPage();
          } else {
            return ProfilePage();
          }
        });
  }

  void updateTabBarController(int i) {
    setState(() {
      homeIcon = (i == 0) ? Icon(Icons.home, color: Colors.white) : Icon(Icons.home_outlined, color: Colors.white);
      chatIcon = (i == 1) ? Icon(Icons.chat, color: Colors.white) : Icon(Icons.chat_bubble_outline_rounded, color: Colors.white);
      leaderboardIcon = (i == 2) ? Icon(Icons.leaderboard, color: Colors.white) : Icon(Icons.leaderboard_outlined, color: Colors.white);
      profileIcon = (i == 3) ? Icon(Icons.person, color: Colors.white) : Icon(Icons.person_outline_rounded, color: Colors.white);
    });
  }
}
