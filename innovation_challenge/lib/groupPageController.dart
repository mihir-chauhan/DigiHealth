import 'package:DigiHealth/groupChallenges.dart';
import 'package:DigiHealth/groupChat.dart';
import 'package:DigiHealth/groupLeaderboard.dart';
import 'package:DigiHealth/groupSearch.dart';
import 'package:DigiHealth/groupSettings.dart';
import 'package:DigiHealth/provider_widget.dart';
import 'package:DigiHealth/services/auth_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:DigiHealth/appPrefs.dart';

class GroupPageController extends StatefulWidget {
  final String groupName;
  final bool isAdmin;

  const GroupPageController(this.groupName, this.isAdmin);

  @override
  _GroupPageControllerState createState() => _GroupPageControllerState();
}

class _GroupPageControllerState extends State<GroupPageController> {
  Icon challengesIcon = Icon(Icons.emoji_events, color: Colors.white);
  Icon chatIcon = Icon(Icons.chat_bubble_outline_rounded, color: Colors.white);
  Icon leaderboardIcon = Icon(Icons.leaderboard_outlined, color: Colors.white);
  Icon searchIcon = Icon(Icons.person_search_outlined, color: Colors.white);
  Icon profileIcon = Icon(Icons.settings_outlined, color: Colors.white);


  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
        tabBar: CupertinoTabBar(
            backgroundColor: secondaryColor,
            items: widget.isAdmin ? [
              BottomNavigationBarItem(icon: challengesIcon),
              BottomNavigationBarItem(icon: chatIcon),
              BottomNavigationBarItem(icon: leaderboardIcon),
              BottomNavigationBarItem(icon: searchIcon),
              BottomNavigationBarItem(icon: profileIcon),
            ] : [
              BottomNavigationBarItem(icon: challengesIcon),
              BottomNavigationBarItem(icon: chatIcon),
              BottomNavigationBarItem(icon: leaderboardIcon),
              BottomNavigationBarItem(icon: profileIcon),
            ],
            onTap: (i) async {
              updateTabBarController(i);
            }),
        tabBuilder: (context, i) {
          if (i == 0) {
            return GroupChallengesPage();
          } else if (i == 1) {
            return GroupChat(widget.groupName);
          } else if (i == 2) {
            return GroupLeaderboard(widget.groupName);
          } else if (i == 3){
            return widget.isAdmin ? GroupSearchPage(widget.groupName) : GroupSettings(widget.groupName);
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
      challengesIcon = (i == 0)
          ? Icon(Icons.emoji_events, color: Colors.white)
          : Icon(Icons.emoji_events_outlined, color: Colors.white);
      chatIcon = (i == 1)
          ? Icon(Icons.chat, color: Colors.white)
          : Icon(Icons.chat_bubble_outline_rounded, color: Colors.white);
      leaderboardIcon = (i == 2)
          ? Icon(Icons.leaderboard, color: Colors.white)
          : Icon(Icons.leaderboard_outlined, color: Colors.white);
      if(widget.isAdmin) {
        searchIcon = (i == 3)
            ? Icon(Icons.person_search, color: Colors.white)
            : Icon(Icons.person_search_outlined, color: Colors.white);
        profileIcon = (i == 4)
            ? Icon(Icons.settings, color: Colors.white)
            : Icon(Icons.settings_outlined, color: Colors.white);
      } else {
        profileIcon = (i == 3)
            ? Icon(Icons.settings, color: Colors.white)
            : Icon(Icons.settings_outlined, color: Colors.white);
      }
    });
  }
}
