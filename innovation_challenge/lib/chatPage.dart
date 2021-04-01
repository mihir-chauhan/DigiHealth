import 'package:DigiHealth/provider_widget.dart';
import 'package:chat_list/chat_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:profanity_filter/profanity_filter.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final primaryColor = const Color(0xFF75A2EA);
  var tertiaryColor = const Color(0xFFFFFFFF);
  var hintColor = const Color(0xFF808080);
  final secondaryColor = const Color(0xFF5c7fb8);
  final quaternaryColor = const Color(0xFF395075);

  String currentChatName = "Exercise";

  final TextEditingController _controller = new TextEditingController();
  String messageToSend = "";
  final List<MessageWidget> _messageList = [];

  @override
  Widget build(BuildContext context) {
    populateChatListView(currentChatName);
    return CupertinoPageScaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: secondaryColor,
        navigationBar: CupertinoNavigationBar(
            middle: Text("$currentChatName Channel",
                style: TextStyle(
                    color: Colors.white, fontFamily: 'Nunito')),
            backgroundColor: secondaryColor,
            leading: GestureDetector(
              onTap: () async {
                debugPrint('Menu Tapped');
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
              },
              child: Icon(
                Icons.menu_rounded,
                color: CupertinoColors.white,
                size: 30,
              ),
            )),
        child: Scaffold(
          backgroundColor: primaryColor,
          resizeToAvoidBottomPadding: false,
          body: SafeArea(child: generateChatListView()),
        ));
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

  sendChatMessage(String message, String chatRoom) async {
    messageToSend = "";
    final FirebaseUser user =
    await Provider.of(context).auth.firebaseAuth.currentUser();
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
                                borderRadius: BorderRadius.circular(9),
                              ),
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
                                if (messageToSend.isNotEmpty) {
                                  await sendChatMessage(
                                      messageToSend, currentChatName);
                                }
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


