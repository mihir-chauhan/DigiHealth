import 'package:DigiHealth/provider_widget.dart';
import 'package:DigiHealth/services/auth_service.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:DigiHealth/appPrefs.dart';

class GroupSettings extends StatefulWidget {
  final String groupName;

  const GroupSettings(this.groupName);
  @override
  _GroupSettingsState createState() => _GroupSettingsState();
}

class _GroupSettingsState extends State<GroupSettings> {
  String username = "Loading";
  String email = "Loading";
  List<Widget> membersList = [];

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;
    setEmailNameText();
    populateMembers();
    return CupertinoPageScaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: secondaryColor,
        navigationBar: CupertinoNavigationBar(
            transitionBetweenRoutes: false,
            heroTag: "groupSettings",
            middle: Text("Settings",
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
                  //TODO: Change name
                  Text(widget.groupName,
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
                  //TODO: Add code
                  Text("Code: ASDFGHJKL",
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
                  AutoSizeText("Members",
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
                    height: _height * 0.01,
                  ),
                  Column(
                    children: membersList,
                  ),
                  SizedBox(
                    height: _height * 0.05,
                  ),
                  CupertinoButton(
                    padding: EdgeInsets.all(8.0),
                    color: Colors.red,
                    child: Text('Leave Group',
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Nunito',
                            fontSize: 17.0,
                            fontWeight: FontWeight.bold)),
                    onPressed: () async {
                      final User user =
                          Provider.of(context).auth.firebaseAuth.currentUser;
                      //TODO: Change database stuff
                      FirebaseFirestore.instance
                          .collection("DigiGroup")
                          .doc(widget.groupName)
                          .collection("Members")
                          .doc(user.email)
                          .delete();
                      Navigator.pushNamed(context, "/home");
                    },
                  ),
                ],
              ),
            )),
          ),
        ));
  }

  populateMembers() async {
    FirebaseFirestore.instance
        //setsup arraylist
        //TODO: Update Database Stuff
        .collection('DigiGroup')
        .doc(widget.groupName)
        .collection('Members')
        .get()
        .then((QuerySnapshot snapshot) {
      if (snapshot.docs.length > 0) {
        snapshot.docs.forEach((doc) {
          membersList.add(
            AutoSizeText(
              doc["Name"],
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontFamily: 'Nunito',
                  fontWeight: FontWeight.w200),
            ),
          );
        });
      } else {
        membersList.add(
          AutoSizeText(
            "No Members",
            style: TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontFamily: 'Nunito',
                fontWeight: FontWeight.w200),
          ),
        );
      }
    });
  }

  void setEmailNameText() async {
    final User user = Provider.of(context).auth.firebaseAuth.currentUser;
    setState(() {
      username = user.displayName;
      email = user.email;
    });
  }
}
