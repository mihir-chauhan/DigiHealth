import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:DigiHealth/appPrefs.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';

class GroupSearchPage extends StatefulWidget {
  final String groupName;

  const GroupSearchPage(this.groupName);

  @override
  _GroupSearchPageState createState() => _GroupSearchPageState();
}

class _GroupSearchPageState extends State<GroupSearchPage> {
  List<String> allUserNames = [];
  List<String> queriedUserNames = [];
  bool readAllUserNames = false;
  @override
  Widget build(BuildContext context) {
    if(!readAllUserNames) {
      readAllUserNames = true;
      allUserNames.clear();
      FirebaseFirestore.instance
          .collection("User Data")
          .get()
          .then((QuerySnapshot allUsers) {
        allUsers.docs.forEach((user) {
          setState(() {
            allUserNames.add(user.get("Name"));
          });
        });
        print("ALL USER NAMES: " + allUserNames.toString());
      });
    }
    return CupertinoPageScaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: secondaryColor,
        navigationBar: CupertinoNavigationBar(
          transitionBetweenRoutes: false,
          heroTag: "profilePage",
          middle: Text("Invite Users",
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
          body: Stack(
            fit: StackFit.expand,
            children: [
              buildFloatingSearchBar(),
            ],
          ),
        ));
  }

  Widget buildFloatingSearchBar() {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return FloatingSearchBar(
      hint: 'Search Users...',
      scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
      transitionDuration: const Duration(milliseconds: 800),
      transitionCurve: Curves.easeInOut,
      physics: const BouncingScrollPhysics(),
      axisAlignment: isPortrait ? 0.0 : -1.0,
      openAxisAlignment: 0.0,
      width: isPortrait ? 600 : 500,
      debounceDelay: const Duration(milliseconds: 500),
      automaticallyImplyBackButton: false,
      accentColor: secondaryColor,
      backgroundColor: secondaryColor,
      shadowColor: Colors.black87,
      backdropColor: primaryColor,
      hintStyle: TextStyle(fontFamily: 'Nunito', color: Colors.white54),
      queryStyle: TextStyle(fontFamily: 'Nunito', color: Colors.white),
      iconColor: Colors.white,
      onQueryChanged: (query) {
        setState(() {
          queriedUserNames.clear();
        });
        for(int i = 0; i < allUserNames.length; i++) {
          if(allUserNames.elementAt(i).contains(query)) {
            setState(() {
              queriedUserNames.add(allUserNames.elementAt(i));
            });
          }
        }
      },
      // Specify a custom transition to be used for
      // animating between opened and closed stated.
      transition: SlideFadeFloatingSearchBarTransition(),
      actions: [
        FloatingSearchBarAction(
          showIfOpened: false,
          child: CircularButton(
            icon: const Icon(Icons.person_search),
            onPressed: () {},
          ),
        ),
        FloatingSearchBarAction.searchToClear(
          showIfClosed: false,
        ),
      ],
      builder: (context, transition) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Material(
            color: Colors.white,
            elevation: 4.0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: queriedUserNames.map((username) {
                return Container(
                    height: 52,
                    width: MediaQuery.of(context).size.width,
                    color: tertiaryColor,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(username, style: TextStyle(fontFamily: 'Nunito', fontSize: 20, color: Colors.white))),
                ));
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}
