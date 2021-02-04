import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:DigiHealth/provider_widget.dart';
import 'package:DigiHealth/services/auth_service.dart';
import 'package:vertical_card_pager/vertical_card_pager.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final primaryColor = const Color(0xFF75A2EA);
  var tertiaryColor = const Color(0xFFFFFFFF);
  var hintColor = const Color(0xFF808080);

  final secondaryColor = const Color(0xFF5c7fb8);
  Icon homeIcon = Icon(Icons.home, color: Colors.white);
  Icon chatIcon = Icon(Icons.chat_bubble_outline_rounded, color: Colors.white);
  Icon profileIcon = Icon(Icons.person_outline_rounded, color: Colors.white);

  final List<String> titles = [
    "Outdoor",
    "Indoor",
    "Meditation",
    "Yoga",
    "Music",
  ];

  final List<Widget> images = [
    ClipRRect(
      borderRadius: BorderRadius.circular(20.0),
      child: Image.asset(
        "images/outdoor.jpg",
        fit: BoxFit.cover,
      ),
    ),
    ClipRRect(
      borderRadius: BorderRadius.circular(20.0),
      child: Image.asset(
        "images/indoor.jpg",
        fit: BoxFit.cover,
      ),
    ),
    ClipRRect(
      borderRadius: BorderRadius.circular(20.0),
      child: Image.asset(
        "images/meditation.jpg",
        fit: BoxFit.cover,
      ),
    ),
    ClipRRect(
      borderRadius: BorderRadius.circular(20.0),
      child: Image.asset(
        "images/yoga.jpg",
        fit: BoxFit.cover,
      ),
    ),
    ClipRRect(
      borderRadius: BorderRadius.circular(20.0),
      child: Image.asset(
        "images/music.jpg",
        fit: BoxFit.cover,
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
        tabBar: CupertinoTabBar(
            backgroundColor: secondaryColor,
            items: [
              BottomNavigationBarItem(icon: homeIcon),
              BottomNavigationBarItem(icon: chatIcon),
              BottomNavigationBarItem(icon: profileIcon),
            ],
            onTap: (i) {
              if (i == 0) {
                setState(() {
                  homeIcon = Icon(Icons.home, color: Colors.white);
                  chatIcon = Icon(Icons.chat_bubble_outline_rounded,
                      color: Colors.white);
                  profileIcon =
                      Icon(Icons.person_outline_rounded, color: Colors.white);
                });
              } else if (i == 1) {
                setState(() {
                  homeIcon = Icon(Icons.home_outlined, color: Colors.white);
                  chatIcon = Icon(Icons.chat, color: Colors.white);
                  profileIcon =
                      Icon(Icons.person_outline_rounded, color: Colors.white);
                });
              } else {
                setState(() {
                  homeIcon = Icon(Icons.home_outlined, color: Colors.white);
                  chatIcon = Icon(Icons.chat_bubble_outline_rounded,
                      color: Colors.white);
                  profileIcon = Icon(Icons.person, color: Colors.white);
                });
              }
            }),
        tabBuilder: (context, i) {
          return CupertinoPageScaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: secondaryColor,
              navigationBar: CupertinoNavigationBar(
                middle: i == 0
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
                backgroundColor: secondaryColor,
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
                trailing: GestureDetector(
                  onTap: () {},
                  child: Icon(
                    Icons.settings,
                    color: CupertinoColors.white,
                    size: 30,
                  ),
                ),
              ),
              child: updateViewBasedOnTab(i));
        });
  }

  Widget updateViewBasedOnTab(int i) {
    if (i == 0) {
      return Scaffold(
        backgroundColor: primaryColor,
        body: SafeArea(
          child: Column(
            children: <Widget>[
              Expanded(
                child: Container(
                  child: VerticalCardPager(
                      titles: titles,
                      // required
                      images: images,
                      // required
                      textStyle: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                      // optional
                      onPageChanged: (page) {
                        // optional
                      },
                      onSelectedItem: (index) {
                        // optional
                      },
                      initialPage: 0,
                      // optional
                      align: ALIGN.CENTER // optional
                      ),
                ),
              ),
            ],
          ),
        ),
      );
    } else if (i == 1) {
      return Scaffold(
        backgroundColor: primaryColor,
        body: SafeArea(
          child: Text("Chat"),
        ),
      );
    } else {
      final _width = MediaQuery.of(context).size.width;
      final _height = MediaQuery.of(context).size.height;
      return Scaffold(
        backgroundColor: primaryColor,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                SizedBox(
                  height: _height * 0.01,
                ),
                Text("Personal Stats",
                    style: TextStyle(fontSize: 48, color: Colors.white, fontFamily: 'Nunito', fontWeight: FontWeight.w200)),
                SizedBox(
                  height: _height * 0.01,
                ),
                Container(
                  width: _width,
                  height: _height * 0.0015,
                  color: secondaryColor,
                ),

                SizedBox(
                  height: _height * 0.1,
                ),
                Text("Your Rank",
                    style: TextStyle(fontSize: 48, color: Colors.white, fontFamily: 'Nunito', fontWeight: FontWeight.w200)),
                SizedBox(
                  height: _height * 0.01,
                ),
                Container(
                  width: _width,
                  height: _height * 0.0015,
                  color: secondaryColor,
                )
              ],
            ),
          )
        ),
      );
    }
  }
}
