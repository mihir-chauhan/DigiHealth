import 'dart:math';

import 'package:DigiHealth/exercisePage.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:chat_list/chat_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:draw_graph/draw_graph.dart';
import 'package:draw_graph/models/feature.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:DigiHealth/provider_widget.dart';
import 'package:DigiHealth/services/auth_service.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:profanity_filter/profanity_filter.dart';
import 'package:vertical_card_pager/vertical_card_pager.dart';
import 'package:vs_scrollbar/vs_scrollbar.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final primaryColor = const Color(0xFF75A2EA);
  var tertiaryColor = const Color(0xFFFFFFFF);
  var hintColor = const Color(0xFF808080);

  final secondaryColor = const Color(0xFF5c7fb8);
  final quaternaryColor = const Color(0xFF395075);
  Icon homeIcon = Icon(Icons.home, color: Colors.white);
  Icon chatIcon = Icon(Icons.chat_bubble_outline_rounded, color: Colors.white);
  Icon profileIcon = Icon(Icons.person_outline_rounded, color: Colors.white);
  Icon leaderboardIcon = Icon(Icons.leaderboard_outlined, color: Colors.white);

  IconData topLeftAppBarIcon = Icons.menu_rounded;

  String currentChatName = "Exercise";

  final TextEditingController _controller = new TextEditingController();
  String messageToSend = "";
  final List<MessageWidget> _messageList = [];

  final List<Feature> features = [
    Feature(
      title: "Yoga",
      color: Colors.blue,
      data: [0.2, 0.8, 0.4, 0.7, 0.6],
    ),
    Feature(
      title: "Exercise",
      color: Colors.pink,
      data: [1, 0.8, 0.6, 0.7, 0.3],
    )
  ];

  final List<String> titles = [
    "DigiFit",
    "DigiDiet",
  ];

  final List<Widget> images = [
    ClipRRect(
      borderRadius: BorderRadius.circular(20.0),
      child: Image.asset(
        "images/digifit.jpg",
        fit: BoxFit.cover,
      ),
    ),
    ClipRRect(
      borderRadius: BorderRadius.circular(20.0),
      child: Image.asset(
        "images/dietplanner2.png",
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
              BottomNavigationBarItem(icon: leaderboardIcon),
              BottomNavigationBarItem(icon: profileIcon),
            ],
            onTap: (i) async {
              if (i == 0) {
                setState(() {
                  homeIcon = Icon(Icons.home, color: Colors.white);
                  chatIcon = Icon(Icons.chat_bubble_outline_rounded,
                      color: Colors.white);
                  profileIcon =
                      Icon(Icons.person_outline_rounded, color: Colors.white);
                  leaderboardIcon =
                      Icon(Icons.leaderboard_outlined, color: Colors.white);
                  topLeftAppBarIcon = Icons.menu_rounded;
                });
              } else if (i == 1) {
                setState(() {
                  homeIcon = Icon(Icons.home_outlined, color: Colors.white);
                  chatIcon = Icon(Icons.chat, color: Colors.white);
                  profileIcon =
                      Icon(Icons.person_outline_rounded, color: Colors.white);
                  leaderboardIcon =
                      Icon(Icons.leaderboard_outlined, color: Colors.white);
                  topLeftAppBarIcon = Icons.mark_chat_unread_outlined;
                });
                await populateChatListView(currentChatName);
              } else if (i == 2) {
                setState(() {
                  homeIcon = Icon(Icons.home_outlined, color: Colors.white);
                  chatIcon = Icon(Icons.chat_bubble_outline_rounded,
                      color: Colors.white);
                  profileIcon =
                      Icon(Icons.person_outline_rounded, color: Colors.white);
                  leaderboardIcon =
                      Icon(Icons.leaderboard, color: Colors.white);
                  topLeftAppBarIcon = Icons.center_focus_strong_rounded;
                });
              } else {
                setState(() {
                  homeIcon = Icon(Icons.home_outlined, color: Colors.white);
                  chatIcon = Icon(Icons.chat_bubble_outline_rounded,
                      color: Colors.white);
                  profileIcon = Icon(Icons.person, color: Colors.white);
                  leaderboardIcon =
                      Icon(Icons.leaderboard_outlined, color: Colors.white);
                  topLeftAppBarIcon = Icons.exit_to_app_rounded;
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
                      ? Text("$currentChatName Channel",
                      style: TextStyle(
                          color: Colors.white, fontFamily: 'Nunito'))
                      : i == 2
                      ? Text("Leaderboard",
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Nunito'))
                      : Text("Profile",
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Nunito')),
                  backgroundColor: secondaryColor,
                  leading: GestureDetector(
                    onTap: () async {
                      debugPrint('Menu Tapped');
                      if (i == 0) {
                        //do nothing yet
                      } else if (i == 1) {
                        showCupertinoModalPopup(
                            context: context,
                            builder: (context) {
                              return CupertinoActionSheet(
                                title: Text("Channels",
                                    style: TextStyle(
                                        color: Colors.black87,
                                        fontFamily: 'Nunito')),
                                actions: [
                                  CupertinoActionSheetAction(
                                    child: Text("Exercise",
                                        style: TextStyle(
                                            color: primaryColor,
                                            fontFamily: 'Nunito')),
                                    onPressed: () async {
                                      currentChatName = "Exercise";
                                      Navigator.pop(context);
                                      await populateChatListView(
                                          currentChatName);
                                    },
                                  ),
                                  CupertinoActionSheetAction(
                                    child: Text("Mental Health",
                                        style: TextStyle(
                                            color: primaryColor,
                                            fontFamily: 'Nunito')),
                                    onPressed: () async {
                                      currentChatName = "Mental Health";
                                      Navigator.pop(context);
                                      await populateChatListView(
                                          currentChatName);
                                    },
                                  ),
                                  CupertinoActionSheetAction(
                                    child: Text("Other",
                                        style: TextStyle(
                                            color: primaryColor,
                                            fontFamily: 'Nunito')),
                                    onPressed: () async {
                                      currentChatName = "Other";
                                      Navigator.pop(context);
                                      await populateChatListView(
                                          currentChatName);
                                    },
                                  )
                                ],
                              );
                            });
                      } else if (i == 2) {
                        //nothing yet
                      } else if (i == 3) {
                        try {
                          AuthService auth = Provider
                              .of(context)
                              .auth;
                          await auth.signOut();
                          print("Signed Out!");
                        } catch (e) {
                          print(e);
                        }
                      }
                    },
                    child: Icon(
                      topLeftAppBarIcon,
                      color: CupertinoColors.white,
                      size: 30,
                    ),
                  )),
              child: updateViewBasedOnTab(i));
        });
  }

  bool hasShownDialog = false;

  void popupInSeconds(int time) async {
    await Future.delayed(Duration(milliseconds: time), () {
      if (!hasShownDialog) {
        showCupertinoDialog(
            context: context,
            builder: (_) =>
                NetworkGiffyDialog(
                  image: Image.asset("welcome.gif"),
                  title: Text("Welcome!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 17,
                          color: Colors.black,
                          fontFamily: 'Nunito',
                          fontWeight: FontWeight.w600)),
                  description: Text(
                    "Choose a workout customized by our intelligent AI, get healthy diet recommendations from our AI-based diet recommendation engine, encourage and compete with others using the chat, and view your personal stats!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.black87,
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.w400),
                  ),
                  entryAnimation: EntryAnimation.BOTTOM,
                  onOkButtonPressed: () {},
                  buttonCancelText: Text(
                    "I'm Ready!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.w300),
                  ),
                  buttonCancelColor: primaryColor,
                  onlyCancelButton: true,
                ));
        hasShownDialog = true;
        Provider
            .of(context)
            .auth
            .madeNewAccount = false;
      }
    });
  }

  Widget updateViewBasedOnTab(int i) {
    if (i == 0) {
      if (Provider
          .of(context)
          .auth
          .madeNewAccount) {
        popupInSeconds(1000);
      }
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
                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) =>
                                  ExercisePage(exerciseType: titles[index])));
                    },
                    initialPage: 0,
                    // optional
                    align: ALIGN.CENTER, // optional
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
        resizeToAvoidBottomPadding: false,
        body: SafeArea(child: generateChatListView()),
      );
    } else if (i == 2) {
      ScrollController _scrollController = new ScrollController();
      Future.delayed(Duration(milliseconds: 1000), () {
        if(_scrollController.offset == 0) {
          _scrollController.animateTo(1000,
              duration: Duration(milliseconds: 750), curve: Curves.easeInOutExpo);
        }
      });
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
              itemCount: 51,
              scrollDirection: Axis.vertical,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: secondaryColor,
                  ),
                  height: 50,
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
                  margin:
                  EdgeInsets.only(left: 15, right: 15, top: 7.5, bottom: 7.5),
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
                                  image: AssetImage(
                                      'images/outdoor.jpg'),
                                  fit: BoxFit.fill,
                                ),
                                shape: BoxShape.circle,
                              ),
                            )
                        ),
                        SizedBox(width: 10,),
                        Align(
                            alignment: Alignment.centerLeft,
                            child: AutoSizeText('User ' + (index + 1).toString(),
                                maxLines: 1,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Nunito',
                                    fontSize: 100))
                        ),
                      ],
                    )
                  ),
                );
              },
            ),
          ));
    } else {
      final _width = MediaQuery
          .of(context)
          .size
          .width;
      final _height = MediaQuery
          .of(context)
          .size
          .height;
      return Scaffold(
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
                    Text("My Stats",
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
                    Container(
                        decoration: BoxDecoration(
                            color: secondaryColor,
                            borderRadius: BorderRadius.all(
                                Radius.circular(10))),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: LineGraph(
                            features: features,
                            size: Size(320, 300),
                            labelX: [
                              'Day 1',
                              'Day 5',
                              'Day 10',
                              'Day 15',
                              'Day 20'
                            ],
                            labelY: ['20', '40', '60', '80', '100'],
                            showDescription: true,
                            graphColor: Colors.white60,
                          ),
                        )),
                    SizedBox(
                      height: _height * 0.1,
                    ),
                    Text("My Rank",
                        style: TextStyle(
                            fontSize: 48,
                            color: Colors.white,
                            fontFamily: 'Nunito',
                            fontWeight: FontWeight.w200)),
                    Container(
                      width: _width,
                      height: _height * 0.001,
                      color: secondaryColor,
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Image.asset("rank.png"),
                    SizedBox(
                      height: 10,
                    ),
                    Text("Ranking: 1st Place",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 30,
                            color: Colors.white,
                            fontFamily: 'Nunito',
                            fontWeight: FontWeight.w200)),
                  ],
                ),
              )),
        ),
      );
    }
  }

  sendChatMessage(String message, String chatRoom) async {
    final FirebaseUser user =
    await Provider
        .of(context)
        .auth
        .firebaseAuth
        .currentUser();
    final databaseReference = Firestore.instance;
    if (message.endsWith("!#clear#!")) {
      databaseReference
          .collection("Chat")
          .document("Chat Rooms")
          .collection(chatRoom)
          .getDocuments()
          .then((snapshot) {
        for (DocumentSnapshot ds in snapshot.documents) {
          ds.reference.delete();
        }
      });
      return;
    }

    ProfanityFilter.filterAdditionally(["stupid", "dumb", "idiot"]);
    final filter = ProfanityFilter();

    if (filter.hasProfanity(message)) {
      await databaseReference.collection("Chat").add({
        "profane_message": message,
        "sentBy": user.email,
        "created": Timestamp.now()
      }).then((value) async {});
      return;
    }

    await databaseReference
        .collection("Chat")
        .document("Chat Rooms")
        .collection(chatRoom)
        .add({
      "message": message,
      "sentBy": user.displayName,
      "created": Timestamp.now()
    });
  }

  populateChatListView(String chatRoom) async {
    final FirebaseUser user =
    await Provider
        .of(context)
        .auth
        .firebaseAuth
        .currentUser();

    String message;

    final databaseReference = Firestore.instance;
    await databaseReference
        .collection("Chat")
        .document("Chat Rooms")
        .collection(chatRoom)
        .orderBy('created', descending: false)
        .snapshots()
        .listen((data) {
      _messageList.clear();
      for (int i = 0; i < data.documents.length; i++) {
        data.documents
            .elementAt(i)
            .data
            .forEach((key, value) {
          if (key.toString().contains("message")) {
            message = value.toString();
          } else if (key.toString().contains("sentBy")) {
            setState(() {
              _messageList.add(createMessageWidget(
                  message,
                  value.toString().endsWith(user.displayName.toString())
                      ? OwnerType.sender
                      : OwnerType.receiver,
                  value.toString()));
            });
          }
        });
      }
    }).asFuture();
  }

  Widget generateChatListView() {
    final ScrollController _scrollController = ScrollController();
    return Container(
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ChatList(
                  children: _messageList, scrollController: _scrollController),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Container(
                color: primaryColor,
                child: Row(
                  children: [
                    Expanded(
                        child: Column(
                          children: [
                            CupertinoTextField(
                              controller: _controller,
                              style: TextStyle(
                                  fontSize: 22,
                                  color: Colors.black87,
                                  fontFamily: 'Nunito',
                                  fontWeight: FontWeight.w300),
                              onChanged: (String value) {
                                messageToSend = value;
                              },
                              placeholder: "Message",
                              placeholderStyle: TextStyle(color: hintColor),
                              cursorColor: Colors.black87,
                              keyboardType: TextInputType.name,
                              decoration: BoxDecoration(
                                  color: tertiaryColor,
                                  borderRadius: BorderRadius.circular(9)),
                            ),
                          ],
                        )),
                    Container(
                        width: 50,
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: () async {
                                _controller.clear();
                                await sendChatMessage(
                                    messageToSend, currentChatName);
                              },
                              child: Icon(
                                Icons.send_rounded,
                                color: CupertinoColors.white,
                                size: 35,
                              ),
                            )
                          ],
                        ))
                  ],
                )),
          ),
          SizedBox(height: 15)
        ],
      ),
    );
  }

  MessageWidget createMessageWidget(String text, OwnerType ownerType,
      String ownerName) {
    return MessageWidget(
        content: text,
        fontSize: 18.0,
        fontFamily: 'Nunito',
        ownerType: ownerType,
        ownerName: ownerName);
  }
}
