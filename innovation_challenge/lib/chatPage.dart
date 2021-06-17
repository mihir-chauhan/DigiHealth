import 'dart:convert';
import 'dart:math';

import 'package:DigiHealth/provider_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:profanity_filter/profanity_filter.dart';
import 'package:DigiHealth/appPrefs.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  String randomString() {
    final random = Random.secure();
    final values = List<int>.generate(16, (i) => random.nextInt(255));
    return base64UrlEncode(values);
  }

  String currentChatName = "Exercise";
  final List<types.Message> _messageList = [];
  final _user = const types.User(id: '06c33e8b-e835-4736-80f4-63f44b66666c');
  final _others = const types.User(id: '4965d318-cf1c-11eb-b8bc-0242ac130003');

  @override
  Widget build(BuildContext context) {
    populateChatListView(currentChatName);
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: secondaryColor,
        appBar: CupertinoNavigationBar(
            transitionBetweenRoutes: false,
            heroTag: "chatPage",
            middle: Text("$currentChatName Channel",
                style: TextStyle(
                    color: Colors.white, fontFamily: 'Nunito')),
            backgroundColor: secondaryColor,
            leading: GestureDetector(
              onTap: () async {
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
                Icons.mark_chat_unread_outlined,
                color: CupertinoColors.white,
                size: 30,
              ),
            )),
        body: Chat(
            theme: const DarkChatTheme(),
            messages: _messageList,
            onSendPressed: _handleSendPressed,
            user: _user,
          ),
        );
  }

  void _handleSendPressed(types.PartialText message) {
    final textMessage = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: randomString(),
      text: message.text,
    );

    sendChatMessage(message.text, currentChatName);
    _addMessage(textMessage);
  }

  void _addMessage(types.Message message) {
    setState(() {
      _messageList.insert(0, message);
    });
  }



  populateChatListView(String chatRoom) async {
    final User user = Provider.of(context).auth.firebaseAuth.currentUser;
    String message;

    final databaseReference = FirebaseFirestore.instance;
    await databaseReference
        .collection("Chat")
        .doc("Chat Rooms")
        .collection(chatRoom)
        .orderBy('created', descending: false)
        .snapshots()
        .listen((data) {
      for (int i = 0; i < data.docs.length; i++) {
        data.docs
            .elementAt(i)
            .data()
            .forEach((key, value) {
          if (key.toString().contains("message")) {
            message = value.toString();
          } else if (key.toString().contains("sentBy")) {
            setState(() {
              _addMessage(types.TextMessage(
                author: value.toString().endsWith(user.displayName.toString())
                    ? _user
                    : _others,
                createdAt: DateTime.now().millisecondsSinceEpoch,
                id: randomString(),
                text: message,
              ));
            });
          }
        });
      }
    }).asFuture();
  }

  sendChatMessage(String message, String chatRoom) async {
    final User user = Provider.of(context).auth.firebaseAuth.currentUser;
    final databaseReference = FirebaseFirestore.instance;
    if (message.contains("!#clear#!")) {
      databaseReference
          .collection("Chat")
          .doc("Chat Rooms")
          .collection(chatRoom)
          .get()
          .then((snapshot) {
        for (DocumentSnapshot ds in snapshot.docs) {
          ds.reference.delete();
        }
      });
      return;
    }

    final filter = ProfanityFilter();

    if (filter.hasProfanity(message) || message.contains("stupid") || message.contains("dumb") || message.contains("idiot")) {
      await databaseReference.collection("Chat").add({
        "profane_message": message,
        "sentBy": user.email,
        "created": Timestamp.now()
      }).then((value) async {});
      return;
    }

    await databaseReference
        .collection("Chat")
        .doc("Chat Rooms")
        .collection(chatRoom)
        .add({
      "message": message,
      "sentBy": user.displayName,
      "created": Timestamp.now()
    });
  }
}