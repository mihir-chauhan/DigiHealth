import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:DigiHealth/appPrefs.dart';

class GroupChallengesPage extends StatefulWidget {
  @override
  _GroupChallengesPageState createState() => _GroupChallengesPageState();
}

class _GroupChallengesPageState extends State<GroupChallengesPage> {

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    return CupertinoPageScaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: secondaryColor,
        navigationBar: CupertinoNavigationBar(
            transitionBetweenRoutes: false,
            heroTag: "profilePage",
            middle: Text("Group Challenges",
                style: TextStyle(color: Colors.white, fontFamily: 'Nunito')),
            backgroundColor: secondaryColor,
            leading: GestureDetector(
              child: Icon(
                Icons.home_rounded,
                color: Colors.white,
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
        ),
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
                    ],
                  ),
                )),
          ),
        ));
  }
}
