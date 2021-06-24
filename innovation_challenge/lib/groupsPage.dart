import 'package:DigiHealth/createGroupPage.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:DigiHealth/appPrefs.dart';

class GroupsPage extends StatefulWidget {
  @override
  _GroupsPageState createState() => _GroupsPageState();
}

enum GroupVisibility {
  PUBLIC,
  PRIVATE
}

enum CardTypes {
  MY_GROUP,
  PUBLIC_GROUP,
  GROUP_INVITES
}

class _GroupsPageState extends State<GroupsPage> {


  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: secondaryColor,
        navigationBar: CupertinoNavigationBar(
            transitionBetweenRoutes: false,
            heroTag: "profilePage",
            middle: Text("DigiGroups",
                style: TextStyle(color: Colors.white, fontFamily: 'Nunito')),
            backgroundColor: secondaryColor,
            leading: GestureDetector(
              child: Icon(
                Icons.circle,
                color: secondaryColor,
              ),
            ),
            trailing: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(builder: (context) => CreateGroupPage()),
                );
              },
              child: Icon(
                Icons.create_rounded,
                color: Colors.white,
                size: 30,
              ),
            )),
        child: Scaffold(
          backgroundColor: primaryColor,
          body: ContainedTabBarView(
            tabs: [
              Text("Your Groups", style: TextStyle(fontFamily: 'Nunito')),
              Text("Public Groups", style: TextStyle(fontFamily: 'Nunito')),
              Text("Invites", style: TextStyle(fontFamily: 'Nunito')),
            ],
            tabBarProperties: TabBarProperties(
              height: 52.0,
              indicatorColor: tertiaryColor,
              indicatorWeight: 2.0,
              labelColor: tertiaryColor,
              unselectedLabelColor: Colors.white,
            ),
            views: [yourGroupsPage(), publicGroups(), groupInvites()],
          ),
        ));
  }

  Widget yourGroupsPage() {
    List<Widget> cards = [];

    // FirebaseFirestore.instance

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            groupCardBuilder(groupName: "2x Healthier", imageSrc: "https://img.icons8.com/color-glass/250/000000/like.png", members: 10, activeChallenges: 2, groupVisibility: GroupVisibility.PRIVATE, cardTypes: CardTypes.MY_GROUP),
            groupCardBuilder(groupName: "Mile a Day", imageSrc: "https://img.icons8.com/clouds/250/000000/walking.png", members: 10, activeChallenges: 2, groupVisibility: GroupVisibility.PUBLIC, cardTypes: CardTypes.MY_GROUP),
          ],
        ),
      ),
    );
  }

  Widget publicGroups() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            groupCardBuilder(groupName: "Elite Swimmers", imageSrc: "https://img.icons8.com/emoji/250/000000/person-swimming.png", members: 10, activeChallenges: 2, cardTypes: CardTypes.PUBLIC_GROUP),
            groupCardBuilder(groupName: "Adventurers", imageSrc: "https://img.icons8.com/emoji/250/000000/national-park-emoji.png", members: 10, activeChallenges: 2, cardTypes: CardTypes.PUBLIC_GROUP),
          ],
        ),
      ),
    );
  }

  Widget groupInvites() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            groupCardBuilder(groupName: "Weight... What?", imageSrc: "https://img.icons8.com/cotton/250/000000/weight-1--v2.png", inviter: "Supergamer", cardTypes: CardTypes.GROUP_INVITES),
          ],
        ),
      ),
    );
  }

  Card groupCardBuilder(
      {String groupName,
      String imageSrc,
      int members,
      int activeChallenges,
      String inviter,
      GroupVisibility groupVisibility,
      CardTypes cardTypes}) {
    if (cardTypes == CardTypes.MY_GROUP) {
      return Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        color: secondaryColor,
        shadowColor: Colors.black54,
        child: Container(
            height: MediaQuery.of(context).size.width * 0.2,
            child: Padding(
              padding: EdgeInsets.all(15),
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Image.network(
                          imageSrc,
                          height: MediaQuery.of(context).size.width * 0.3,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                  child: AutoSizeText(groupName,
                                      maxLines: 1,
                                      style: TextStyle(
                                          fontFamily: 'Nunito',
                                          fontSize: 35,
                                          color: Colors.white))),
                              Row(
                                children: [
                                  Card(
                                    elevation: 5,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    color: tertiaryColor,
                                    shadowColor: Colors.black54,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0, vertical: 2.0),
                                      child: Column(
                                        children: [
                                          Icon(Icons.people_alt_rounded,
                                              color: Colors.white),
                                          Text(members.toString(),
                                              style: TextStyle(
                                                  fontFamily: 'Nunito',
                                                  fontSize: 15,
                                                  color: Colors.white))
                                        ],
                                      ),
                                    ),
                                  ),
                                  Card(
                                    elevation: 5,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    color: tertiaryColor,
                                    shadowColor: Colors.black54,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0, vertical: 2.0),
                                      child: Column(
                                        children: [
                                          Icon(Icons.emoji_events,
                                              color: Colors.white),
                                          Text(activeChallenges.toString(),
                                              style: TextStyle(
                                                  fontFamily: 'Nunito',
                                                  fontSize: 15,
                                                  color: Colors.white))
                                        ],
                                      ),
                                    ),
                                  ),
                                  Card(
                                    elevation: 5,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    color: tertiaryColor,
                                    shadowColor: Colors.black54,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0, vertical: 2.0),
                                      child: Column(
                                        children: [
                                          Icon(
                                              groupVisibility ==
                                                      GroupVisibility.PRIVATE
                                                  ? Icons.visibility_off
                                                  : Icons.visibility,
                                              color: Colors.white),
                                          Text(
                                              groupVisibility ==
                                                      GroupVisibility.PRIVATE
                                                  ? "Private"
                                                  : "Public",
                                              style: TextStyle(
                                                  fontFamily: 'Nunito',
                                                  fontSize: 15,
                                                  color: Colors.white))
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.keyboard_arrow_right,
                    color: Colors.white,
                  )
                ],
              ),
            )),
      );
    } else if (cardTypes == CardTypes.PUBLIC_GROUP) {
      return Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        color: secondaryColor,
        shadowColor: Colors.black54,
        child: Container(
            height: MediaQuery.of(context).size.width * 0.2,
            child: Padding(
              padding: EdgeInsets.all(15),
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Image.network(
                          imageSrc,
                          height: MediaQuery.of(context).size.width * 0.3,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                  child: AutoSizeText(groupName,
                                      maxLines: 1,
                                      style: TextStyle(
                                          fontFamily: 'Nunito',
                                          fontSize: 35,
                                          color: Colors.white))),
                              Row(
                                children: [
                                  Card(
                                    elevation: 5,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    color: tertiaryColor,
                                    shadowColor: Colors.black54,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0, vertical: 2.0),
                                      child: Column(
                                        children: [
                                          Icon(Icons.people_alt_rounded,
                                              color: Colors.white),
                                          Text(members.toString(),
                                              style: TextStyle(
                                                  fontFamily: 'Nunito',
                                                  fontSize: 15,
                                                  color: Colors.white))
                                        ],
                                      ),
                                    ),
                                  ),
                                  Card(
                                    elevation: 5,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    color: tertiaryColor,
                                    shadowColor: Colors.black54,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0, vertical: 2.0),
                                      child: Column(
                                        children: [
                                          Icon(Icons.emoji_events,
                                              color: Colors.white),
                                          Text(activeChallenges.toString(),
                                              style: TextStyle(
                                                  fontFamily: 'Nunito',
                                                  fontSize: 15,
                                                  color: Colors.white))
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.keyboard_arrow_right,
                    color: Colors.white,
                  )
                ],
              ),
            )),
      );
    } else if (cardTypes == CardTypes.GROUP_INVITES) {
      return Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        color: secondaryColor,
        shadowColor: Colors.black54,
        child: Container(
            height: MediaQuery.of(context).size.width * 0.2,
            child: Padding(
              padding: EdgeInsets.all(15),
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Image.network(
                          imageSrc,
                          height: MediaQuery.of(context).size.width * 0.3,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                  child: AutoSizeText(groupName,
                                      maxLines: 1,
                                      style: TextStyle(
                                          fontFamily: 'Nunito',
                                          fontSize: 35,
                                          color: Colors.white))),
                              Row(
                                children: [
                                  Card(
                                    elevation: 5,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    color: tertiaryColor,
                                    shadowColor: Colors.black54,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0, vertical: 2.0),
                                      child: Column(
                                        children: [
                                          Icon(Icons.mark_email_unread_rounded,
                                              color: Colors.white),
                                          AutoSizeText(inviter,
                                              style: TextStyle(
                                                  fontFamily: 'Nunito',
                                                  fontSize: 15,
                                                  color: Colors.white))
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.keyboard_arrow_right,
                    color: Colors.white,
                  )
                ],
              ),
            )),
      );
    }
  }
}
