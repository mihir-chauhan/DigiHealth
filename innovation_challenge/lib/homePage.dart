import 'package:chat_list/chat_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  final quaternaryColor = const Color(0xFF395075);
  Icon homeIcon = Icon(Icons.home, color: Colors.white);
  Icon chatIcon = Icon(Icons.chat_bubble_outline_rounded, color: Colors.white);
  Icon profileIcon = Icon(Icons.person_outline_rounded, color: Colors.white);

  String messageToSend = "";
  final List<MessageWidget> _messageList = [];

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
            onTap: (i) async {
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
                await populateChatListView("Mental Health");
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
                      initialPage: 2,
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
        resizeToAvoidBottomPadding: false,
        body: SafeArea(child: generateChatListView()),
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
                height: _height * 0.0015,
                color: secondaryColor,
              ),
              SizedBox(
                height: _height * 0.1,
              ),
              Text("Your Rank",
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
                height: _height * 0.0015,
                color: secondaryColor,
              )
            ],
          ),
        )),
      );
    }
  }

  sendChatMessage(String message, String chatRoom) async {
    final FirebaseUser user =
        await Provider.of(context).auth.firebaseAuth.currentUser();
    final databaseReference = Firestore.instance;
    await databaseReference
        .collection("Chat")
        .document("Chat Rooms")
        .collection(chatRoom)
        .add({
      "message": message,
      "sentBy": user.displayName,
      "created": Timestamp.now()
    }).then((value) {
      setState(() {
        _messageList.add(
            createMessageWidget(message, OwnerType.sender, user.displayName));
      });
    });
  }


  populateChatListView(String chatRoom) async {
    bool needsToPopulateFromScratch = true;
    final FirebaseUser user = await Provider.of(context).auth.firebaseAuth.currentUser();

    String message;

    final databaseReference = Firestore.instance;
    await databaseReference
        .collection("Chat")
        .document("Chat Rooms")
        .collection(chatRoom)
        .orderBy('created', descending: false)
        .snapshots()
        .listen((data) {
      if(needsToPopulateFromScratch) {
        //prepare previous messages as entering chat view
        _messageList.clear();
        for (int i = 0; i < data.documents.length; i++) {
          data.documents.elementAt(i).data.forEach((key, value) {
            if(key.toString().contains("message")) {
              message = value.toString();
            } else if(key.toString().contains("sentBy")) {
              setState(() {
                _messageList.add(createMessageWidget(message, value.toString().endsWith(user.displayName.toString()) ? OwnerType.sender : OwnerType.receiver, value.toString()));
              });
            }
          });
        }
        needsToPopulateFromScratch = false;
      } else {
        //got message while in chat
        data.documents.last.data.forEach((key, value) {
          if(key.toString().contains("message")) {
            message = value.toString();
          } else if(key.toString().contains("sentBy") && !value.toString().endsWith(user.displayName.toString())) {
            setState(() {
              _messageList.add(createMessageWidget(message, OwnerType.receiver, value.toString()));
            });
          }
        });
      }

    }).asFuture();
  }

  Widget generateChatListView() {
    final ScrollController _scrollController = ScrollController();
    final TextEditingController _controller = new TextEditingController();
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
                                    messageToSend, "Mental Health");
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

  MessageWidget createMessageWidget(
      String text, OwnerType ownerType, String ownerName) {
    return MessageWidget(
        content: text,
        fontSize: 18.0,
        fontFamily: 'Nunito',
        ownerType: ownerType,
        ownerName: ownerName);
  }
}
