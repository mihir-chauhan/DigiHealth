import 'package:DigiHealth/provider_widget.dart';
import 'package:DigiHealth/services/auth_service.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:DigiHealth/appPrefs.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class GroupSettings extends StatefulWidget {
  final String groupName;

  const GroupSettings(this.groupName);
  @override
  _GroupSettingsState createState() => _GroupSettingsState();
}

class _GroupSettingsState extends State<GroupSettings> {
  List<Widget> membersList = [];
  bool populatedMembers = false;
  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;
    if(!populatedMembers) {
      populatedMembers = true;
      populateMembers();
    }
    return CupertinoPageScaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: secondaryColor,
        navigationBar: CupertinoNavigationBar(
            transitionBetweenRoutes: false,
            heroTag: "groupSettings",
            middle: Text("Group Settings",
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
            trailing: GestureDetector(
              onTap: () async {
                Alert(
                  context: context,
                  type: AlertType.none,
                  style: AlertStyle(
                      animationDuration:
                      const Duration(milliseconds: 300),
                      animationType: AnimationType.grow,
                      backgroundColor: secondaryColor,
                      descStyle: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Nunito'),
                      titleStyle: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Nunito')),
                  title: "Are you sure you want to leave?",
                  desc:
                  "This action cannot be undone.",
                  image: SizedBox(),
                  closeIcon: Icon(Icons.clear, color: Colors.white),
                  buttons: [
                    DialogButton(
                      child: Text(
                        "Leave",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontFamily: 'Nunito'),
                      ),
                      onPressed: () {
                        final User user =
                            Provider.of(context).auth.firebaseAuth.currentUser;
                        FirebaseFirestore.instance
                            .collection("DigiGroup")
                            .doc(widget.groupName)
                            .collection("Members")
                            .doc(user.email)
                            .delete();
                        Navigator.pop(context);
                      },
                      color: badColor,
                    ),
                  ],
                ).show();

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
                ],
              ),
            )),
          ),
        ));
  }

  populateMembers() async {
    membersList.clear();
    FirebaseFirestore.instance
        .collection('DigiGroup')
        .doc(widget.groupName)
        .collection('Members')
        .get()
        .then((QuerySnapshot snapshot) {
      if (snapshot.docs.length > 0) {
        snapshot.docs.forEach((doc) {
          setState(() {
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
        });
      }
    });
  }
}
