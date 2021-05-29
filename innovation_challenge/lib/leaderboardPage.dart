import 'dart:math';
import 'package:DigiHealth/appPrefs.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:vs_scrollbar/vs_scrollbar.dart';

class LeaderboardPage extends StatefulWidget {
  @override
  _LeaderboardPageState createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  static var leaderboardName;
  static var leaderboardPoints;
  int i = 50;

  setupLeaderboardRankings() async {
    leaderboardName = ValueNotifier<List<String>>(<String>[]);
    leaderboardPoints = ValueNotifier<List<int>>(<int>[]);
    FirebaseFirestore.instance
        //setsup arraylist
        .collection('User Data')
        .orderBy('Points', descending: true)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        leaderboardName.value.add(doc['Name']);
        leaderboardPoints.value.add(doc['Points']);
        leaderboardName.notifyListeners();
      });
    });
  }

  AutoSizeText populateLeaderboardWithName(int index) {
    return AutoSizeText(
      leaderboardName.value[index].toString(),
      maxLines: 1,
      style:
          TextStyle(color: Colors.white, fontFamily: 'Nunito', fontSize: 100),
    );
  }

  AutoSizeText populateLeaderboardWithPoints(int index) {
    return AutoSizeText(
      leaderboardPoints.value[index].toString(),
      maxLines: 1,
      style: TextStyle(
          color: Colors.white,
          fontFamily: 'Nunito',
          fontSize: 100,
          fontWeight: FontWeight.bold),
    );
  }

  AssetImage classifyRank(int i) {
    if(i == 0) {
      return AssetImage('images/rank.png');
    }

    if (leaderboardPoints.value[i] > 5000) {
      return AssetImage('images/diamond1.png');
    }
    if (leaderboardPoints.value[i] > 4500) {
      return AssetImage('images/platinum2.png');
    }
    if (leaderboardPoints.value[i] > 4000) {
      return AssetImage('images/platinum1.png');
    }
    if (leaderboardPoints.value[i] > 3500) {
      return AssetImage('images/gold2.png');
    }
    if (leaderboardPoints.value[i] > 3000) {
      return AssetImage('images/gold1.png');
    }
    if (leaderboardPoints.value[i] > 2500) {
      return AssetImage('images/silver2.png');
    }
    if (leaderboardPoints.value[i] > 2000) {
      return AssetImage('images/silver1.png');
    }
    if (leaderboardPoints.value[i] > 1500) {
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
  //   Future.delayed(Duration(milliseconds: 1000), () {
  //     if (_scrollController.offset == 0) {
  //       _scrollController.animateTo(1000,
  //           duration: Duration(milliseconds: 750), curve: Curves.easeInOutExpo);
  //     }
  //   });

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
              color: secondaryColor,
              size: 30,
            ),
          )),
      child: ValueListenableBuilder2<List<String>, List<int>>(
        leaderboardName,
        leaderboardPoints,
        builder: (context, leaderboardName, leaderboardPoints, child) {
          return CupertinoPageScaffold(
            key: ObjectKey(Random().nextInt(100)),
            backgroundColor: primaryColor,
            child: VsScrollbar(
              controller: _scrollController,
              scrollDirection: Axis.vertical,
              // @REQUIRED
              allowDrag: false,
              color: tertiaryColor,
              // sets color of vsScrollBar
              child: ListView.builder(
                controller: _scrollController,
                shrinkWrap: false,
                physics: BouncingScrollPhysics(),
                itemCount: leaderboardName.length,
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
                            Expanded(
                              child: Row(
                                children: [
                                  Align(
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
                                  SizedBox(width: 10),
                                  Align(
                                    child: populateLeaderboardWithName(index),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 25),
                              child: Align(
                                child: populateLeaderboardWithPoints(index),
                              ),
                            ),
                          ],
                        ),
                      ));
                },
              ),
            ),
          );
        },
      )
    );
  }
}

class ValueListenableBuilder2<A, B> extends StatelessWidget {
  ValueListenableBuilder2(
      this.first,
      this.second, {
        Key key,
        this.builder,
        this.child,
      }) : super(key: key);

  final ValueListenable<A> first;
  final ValueListenable<B> second;
  final Widget child;
  final Widget Function(BuildContext context, A a, B b, Widget child) builder;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<A>(
      valueListenable: first,
      builder: (_, a, __) {
        return ValueListenableBuilder<B>(
          valueListenable: second,
          builder: (context, b, __) {
            return builder(context, a, b, child);
          },
        );
      },
    );
  }
}

