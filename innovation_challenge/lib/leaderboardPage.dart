import 'dart:math';
import 'package:DigiHealth/appPrefs.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lists/lists.dart';
import 'package:vs_scrollbar/vs_scrollbar.dart';

class LeaderboardPage extends StatefulWidget {
  @override
  _LeaderboardPageState createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  static var leaderboardName;

  int i = 50;
  SparseList leaderboardPoints = SparseList<int>();

  setupLeaderboardRankings() async {
    leaderboardName = ValueNotifier<List<String>>(new List<String>());
    Firestore.instance
        //setsup arraylist
        .collection('User Data')
        .orderBy('points', descending: true)
        .getDocuments()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.documents.forEach((doc) {
        leaderboardName.value.add(doc['Name']);
        leaderboardPoints.add(doc['points']);
        leaderboardName.notifyListeners();
      });
    });
  }

  AutoSizeText populateLeaderboardWithName(int index) {
    //get from array at index(passed in)
    return AutoSizeText(
      leaderboardName.value[index].toString(),
      maxLines: 1,
      style:
          TextStyle(color: Colors.white, fontFamily: 'Nunito', fontSize: 100),
    );
    // return leaderboardName.toList()[index];
  }

  AutoSizeText populateLeaderboardWithPoints(int index) {
    //get from array at index(passed in)
    return AutoSizeText(
      leaderboardPoints[index].toString(),
      maxLines: 1,
      style: TextStyle(
          color: Colors.white,
          fontFamily: 'Nunito',
          fontSize: 100,
          fontWeight: FontWeight.bold),
    );
    // return leaderboardName.toList()[index];
  }

  AssetImage classifyRank(int i) {
    if (leaderboardPoints[i] > 5000) {
      return AssetImage('images/diamond1.png');
    }
    if (leaderboardPoints[i] > 4500) {
      return AssetImage('images/platinum2.png');
    }
    if (leaderboardPoints[i] > 4000) {
      return AssetImage('images/platinum1.png');
    }
    if (leaderboardPoints[i] > 3500) {
      return AssetImage('images/gold2.png');
    }
    if (leaderboardPoints[i] > 3000) {
      return AssetImage('images/gold1.png');
    }
    if (leaderboardPoints[i] > 2500) {
      return AssetImage('images/silver2.png');
    }
    if (leaderboardPoints[i] > 2000) {
      return AssetImage('images/silver1.png');
    }
    if (leaderboardPoints[i] > 1500) {
      return AssetImage('images/bronze2.png');
    } else {
      return AssetImage('images/bronze1.png');
    }
  }

  int numberOfUsers() {
    if (leaderboardName.value.length < 51) {
      return leaderboardName.value.length;
    } else {
      return i;
    }
  }

  ScrollController _scrollController = new ScrollController();

  @override
  Widget build(BuildContext context) {
    // Future.delayed(Duration(milliseconds: 1000), () {
    //   if (_scrollController.offset == 0) {
    //     _scrollController.animateTo(1000,
    //         duration: Duration(milliseconds: 750), curve: Curves.easeInOutExpo);
    //   }
    // });

    setupLeaderboardRankings();
    return CupertinoPageScaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: secondaryColor,
      navigationBar: CupertinoNavigationBar(
          transitionBetweenRoutes: false,
          heroTag: "leaderboardPage",
          middle: Text("Leaderboard",
              style: TextStyle(color: Colors.white, fontFamily: 'Nunito')),
          backgroundColor: secondaryColor,
          leading: GestureDetector(
            onTap: () async {},
            child: Icon(
              Icons.center_focus_strong_rounded,
              color: CupertinoColors.white,
              size: 30,
            ),
          )),
      child: ValueListenableBuilder(
        valueListenable: leaderboardName,
        builder: (context, value, widget) {
          return CupertinoPageScaffold(
            key: ObjectKey(Random().nextInt(100)),
            backgroundColor: primaryColor,
            child: VsScrollbar(
              controller: _scrollController,
              scrollDirection: Axis.vertical,
              // @REQUIRED
              allowDrag: false,
              color: quaternaryColor,
              // sets color of vsScrollBar
              child: ListView.builder(
                controller: _scrollController,
                shrinkWrap: false,
                physics: BouncingScrollPhysics(),
                itemCount: value.length,
                scrollDirection: Axis.vertical,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: secondaryColor,
                      ),
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.only(
                          left: 15, right: 15, top: 7.5, bottom: 7.5),
                      child: Padding(
                        padding: EdgeInsets.all(5),
                        child: Row(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                height: 40.0,
                                width: 40.0,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: classifyRank(index),
                                    fit: BoxFit.fill,
                                  ),
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: populateLeaderboardWithName(index),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: populateLeaderboardWithPoints(index),
                            ),
                          ],
                        ),
                      ));
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
