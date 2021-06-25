import 'package:DigiHealth/chatPage.dart';
import 'package:DigiHealth/groupsPage.dart';
import 'package:DigiHealth/homePage.dart';
import 'package:DigiHealth/leaderboardPage.dart';
import 'package:DigiHealth/mentalHealthAudio.dart';
import 'package:DigiHealth/profilePage.dart';
import 'package:DigiHealth/provider_widget.dart';
import 'package:DigiHealth/services/auth_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:DigiHealth/appPrefs.dart';

class MainPageController extends StatefulWidget {
  @override
  _MainPageControllerState createState() => _MainPageControllerState();
}

class _MainPageControllerState extends State<MainPageController> {
  Icon homeIcon = Icon(Icons.home, color: Colors.white);
  Icon podcastsIcon = Icon(Icons.radio_outlined, color: Colors.white);
  Icon leaderboardIcon = Icon(Icons.leaderboard_outlined, color: Colors.white);
  Icon groupsIcon = Icon(Icons.groups_outlined, color: Colors.white);
  Icon profileIcon = Icon(Icons.settings_outlined, color: Colors.white);

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
        tabBar: CupertinoTabBar(
            backgroundColor: secondaryColor,
            items: [
              BottomNavigationBarItem(icon: homeIcon),
              BottomNavigationBarItem(icon: podcastsIcon),
              BottomNavigationBarItem(icon: leaderboardIcon),
              BottomNavigationBarItem(icon: groupsIcon),
              BottomNavigationBarItem(icon: profileIcon),
            ],
            onTap: (i) async {
              updateTabBarController(i);
            }),
        tabBuilder: (context, i) {
          if (i == 0) {
            return HomePage();
          } else if (i == 1) {
            return MentalHealthAudio();
          } else if (i == 2) {
            return LeaderboardPage();
          } else if (i == 3) {
            return GroupsPage();
          } else {
            return ProfilePage();
          }
        });
  }

  void logOut() async {
    try {
      AuthService auth = Provider.of(context).auth;
      await auth.signOut();
    } catch (e) {
      print(e);
    }
  }

  void updateTabBarController(int i) {
    setState(() {
      homeIcon = (i == 0)
          ? Icon(Icons.home, color: Colors.white)
          : Icon(Icons.home_outlined, color: Colors.white);
      podcastsIcon = (i == 1)
          ? Icon(Icons.radio, color: Colors.white)
          : Icon(Icons.radio_outlined, color: Colors.white);
      leaderboardIcon = (i == 2)
          ? Icon(Icons.leaderboard, color: Colors.white)
          : Icon(Icons.leaderboard_outlined, color: Colors.white);
      groupsIcon = (i == 3)
          ? Icon(Icons.groups, color: Colors.white)
          : Icon(Icons.groups_outlined, color: Colors.white);
      profileIcon = (i == 4)
          ? Icon(Icons.settings, color: Colors.white)
          : Icon(Icons.settings_outlined, color: Colors.white);
    });
  }
}
