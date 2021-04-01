import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vs_scrollbar/vs_scrollbar.dart';

class LeaderboardPage extends StatefulWidget {
  @override
  _LeaderboardPageState createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  final primaryColor = const Color(0xFF75A2EA);
  var tertiaryColor = const Color(0xFFFFFFFF);
  var hintColor = const Color(0xFF808080);
  final secondaryColor = const Color(0xFF5c7fb8);
  final quaternaryColor = const Color(0xFF395075);
  ScrollController _scrollController = new ScrollController();

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(milliseconds: 1000), () {
      if (_scrollController.offset == 0) {
        _scrollController.animateTo(1000,
            duration: Duration(milliseconds: 750),
            curve: Curves.easeInOutExpo);
      }
    });

    return CupertinoPageScaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: secondaryColor,
        navigationBar: CupertinoNavigationBar(
            middle: Text("Leaderboard",
                style: TextStyle(
                    color: Colors.white, fontFamily: 'Nunito')),
            backgroundColor: secondaryColor,
            leading: GestureDetector(
              onTap: () async {
                debugPrint('Menu Tapped');
              },
              child: Icon(
                Icons.menu_rounded,
                color: CupertinoColors.white,
                size: 30,
              ),
            )),
        child: CupertinoPageScaffold(
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
                itemCount: 51,
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
                                      image: AssetImage('images/outdoor.jpg'),
                                      fit: BoxFit.fill,
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                )),
                            SizedBox(
                              width: 10,
                            ),
                            Align(
                                alignment: Alignment.centerLeft,
                                child: AutoSizeText(
                                    'User ' + (index + 1).toString(),
                                    maxLines: 1,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Nunito',
                                        fontSize: 100))),
                          ],
                        )),
                  );
                },
              ),
            )));
  }
}


