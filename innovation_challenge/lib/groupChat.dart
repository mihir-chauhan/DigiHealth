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

class GroupChat extends StatefulWidget {
  final String groupName;

  const GroupChat(this.groupName);
  @override
  _GroupChatState createState() => _GroupChatState();
}

class _GroupChatState extends State<GroupChat> {
  String randomString() {
    final random = Random.secure();
    final values = List<int>.generate(16, (i) => random.nextInt(255));
    return base64UrlEncode(values);
  }

  final List<types.Message> _messageList = [];
  final _user = const types.User(id: '06c33e8b-e835-4736-80f4-63f44b66666c');
  final _others = const types.User(id: '4965d318-cf1c-11eb-b8bc-0242ac130003');

  @override
  Widget build(BuildContext context) {
    populateChatListView();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: secondaryColor,
      appBar: CupertinoNavigationBar(
        transitionBetweenRoutes: false,
        heroTag: "groupChat",
        middle: Text("Group Chat",
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
      body: Chat(
        theme: const DarkChatTheme(
            inputTextStyle:
                TextStyle(fontFamily: 'Nunito', color: Colors.white),
            dateDividerTextStyle:
                TextStyle(fontFamily: 'Nunito', color: Colors.white),
            receivedMessageBodyTextStyle:
                TextStyle(fontFamily: 'Nunito', color: Colors.white),
            sentMessageBodyTextStyle:
                TextStyle(fontFamily: 'Nunito', color: Colors.white),
            emptyChatPlaceholderTextStyle:
                TextStyle(color: Colors.white, fontFamily: 'Nunito'),
            backgroundColor: const Color(0xFF75A2EA),
            inputBackgroundColor: const Color(0xFF395075),
            inputTextColor: Colors.white,
            primaryColor: const Color(0xFF395075),
            secondaryColor: const Color(0xFF395075)),
        messages: _messageList,
        onSendPressed: _handleSendPressed,
        user: _user,
      ),
    );
  }

  void _handleSendPressed(types.PartialText message) {
    sendChatMessage(message.text);
  }

  void _addMessage(types.Message message) {
    setState(() {
      _messageList.insert(0, message);
    });
  }

  bool alreadyPopulatedChat = false;
  var chatChangeListener;

  populateChatListView() {
    if (alreadyPopulatedChat) {
      return;
    }
    alreadyPopulatedChat = true;
    User user = Provider.of(context).auth.firebaseAuth.currentUser;
    chatChangeListener = FirebaseFirestore.instance
        .collection("DigiGroup")
        .doc(widget.groupName)
        .collection("Chat")
        .orderBy('created', descending: false)
        .snapshots()
        .listen((data) {
      data.docChanges.forEach((element) {
        if (element.type == DocumentChangeType.added) {
          DateTime dateCreated = element.doc.get("created").toDate();
          setState(() {
            _addMessage(types.TextMessage(
              author: element.doc
                      .get("sentBy")
                      .toString()
                      .contains(user.displayName.toString())
                  ? _user
                  : _others,
              createdAt: dateCreated.millisecondsSinceEpoch,
              id: randomString(),
              text: element.doc.get("message").toString(),
            ));
          });
        }
      });
    }).asFuture();
  }

  sendChatMessage(String message) {
    final User user = Provider.of(context).auth.firebaseAuth.currentUser;
    if (message.contains("!#clear#!")) {
      FirebaseFirestore.instance
          .collection("DigiGroup")
          .doc(widget.groupName)
          .collection("Chat")
          .get()
          .then((snapshot) {
        for (DocumentSnapshot ds in snapshot.docs) {
          ds.reference.delete();
        }
      });
      return;
    }

    final filter = ProfanityFilter();

    if (filter.hasProfanity(message.toLowerCase()) ||
        message.toLowerCase().contains("stupid") ||
        message.toLowerCase().contains("dumb") ||
        message.toLowerCase().contains("idiot")) {
      FirebaseFirestore.instance.collection("DigiGroup").add({
        "profane_message": message,
        "sentBy": user.email,
        "created": Timestamp.now()
      });
      return;
    }

    FirebaseFirestore.instance
        .collection("DigiGroup")
        .doc(widget.groupName)
        .collection("Chat")
        .add({
      "message": message,
      "sentBy": user.displayName,
      "created": Timestamp.now()
    });
  }
}
