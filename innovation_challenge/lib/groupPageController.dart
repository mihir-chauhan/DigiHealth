import 'package:DigiHealth/groupChat.dart';
import 'package:DigiHealth/groupLeaderboard.dart';
import 'package:DigiHealth/groupSettings.dart';
import 'package:DigiHealth/profilePage.dart';
import 'package:DigiHealth/provider_widget.dart';
import 'package:DigiHealth/services/auth_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:DigiHealth/appPrefs.dart';

class GroupPageController extends StatefulWidget {
  final String groupName;

  const GroupPageController(this.groupName);

  @override
  _GroupPageControllerState createState() => _GroupPageControllerState();
}

class _GroupPageControllerState extends State<GroupPageController> {
  Icon homeIcon = Icon(Icons.home, color: Colors.white);
  Icon chatIcon = Icon(Icons.chat_bubble_outline_rounded, color: Colors.white);
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
              BottomNavigationBarItem(icon: chatIcon),
              BottomNavigationBarItem(icon: leaderboardIcon),
              BottomNavigationBarItem(icon: groupsIcon),
              BottomNavigationBarItem(icon: profileIcon),
            ],
            onTap: (i) async {
              updateTabBarController(i);
            }),
        tabBuilder: (context, i) {
          if (i == 0) {
            return ProfilePage();
          } else if (i == 1) {
            return GroupChat(widget.groupName);
          } else if (i == 2) {
            return GroupLeaderboard(widget.groupName);
          } else {
            return GroupSettings(widget.groupName);
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
      chatIcon = (i == 1)
          ? Icon(Icons.chat, color: Colors.white)
          : Icon(Icons.chat_bubble_outline_rounded, color: Colors.white);
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
