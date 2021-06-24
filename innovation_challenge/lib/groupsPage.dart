import 'package:DigiHealth/createGroupPage.dart';
import 'package:DigiHealth/groupPageController.dart';
import 'package:DigiHealth/provider_widget.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:DigiHealth/appPrefs.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class GroupsPage extends StatefulWidget {
  @override
  _GroupsPageState createState() => _GroupsPageState();
}

enum GroupVisibility { PUBLIC, PRIVATE }

enum CardTypes { MY_GROUP, PUBLIC_GROUP, GROUP_INVITES }

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
                ).then((value) {
                  //Called when Create Groups Page pops
                  populatedYourGroupPageCards = false;
                  yourGroups();
                  populatedPublicGroupPageCards = false;
                  publicGroups();
                });
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
            views: [yourGroups(), publicGroups(), groupInvites()],
            onChange: (index) {
              if (index == 0) {
                populatedYourGroupPageCards = false;
                yourGroups();
              } else if (index == 1) {
                populatedPublicGroupPageCards = false;
                publicGroups();
              } else if (index == 2) {}
            },
          ),
        ));
  }

  List<Widget> yourGroupsPageCards = [];
  bool populatedYourGroupPageCards = false;

  Widget yourGroups() {
    if (!populatedYourGroupPageCards) {
      populatedYourGroupPageCards = true;
      User user = Provider.of(context).auth.firebaseAuth.currentUser;
      yourGroupsPageCards.clear();
      FirebaseFirestore.instance
          .collection("DigiGroup")
          .get()
          .then((QuerySnapshot allGroupsSnapshot) {
        allGroupsSnapshot.docs.forEach((groupDoc) {
          FirebaseFirestore.instance
              .collection("DigiGroup")
              .doc(groupDoc.id)
              .collection("Members")
              .get()
              .then((QuerySnapshot membersDocuments) {
            membersDocuments.docs.forEach((member) {
              if (member.id.contains(user.email)) {
                setState(() {
                  yourGroupsPageCards.add(groupCardBuilder(
                      groupName: groupDoc.id,
                      imageSrc: groupDoc.get("image"),
                      members: 10,
                      activeChallenges: 2,
                      groupVisibility: groupDoc.get("visibility") == "Private"
                          ? GroupVisibility.PRIVATE
                          : GroupVisibility.PUBLIC,
                      cardTypes: CardTypes.MY_GROUP,
                      callback: (groupName) {
                        bool userIsInGroup = false;
                        FirebaseFirestore.instance
                            .collection("DigiGroup")
                            .doc(groupName)
                            .collection("Members")
                            .get()
                            .then((QuerySnapshot memberDocs) {
                              memberDocs.docs.forEach((member) {
                                if(member.id.contains(user.email)) {
                                  userIsInGroup = true;
                                  Navigator.push(
                                    context,
                                    CupertinoPageRoute(builder: (context) => GroupPageController(groupName, member.get("isAdmin"))),
                                  );
                                }
                              });
                        }).then((value) {
                          if(!userIsInGroup) {
                            Alert(
                              context: context,
                              type: AlertType.none,
                              style: AlertStyle(
                                  animationDuration:
                                  const Duration(milliseconds: 300),
                                  animationType: AnimationType.grow,
                                  backgroundColor: secondaryColor,
                                  descStyle: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Nunito'),
                                  titleStyle: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Nunito')),
                              title: "You are not a member of '$groupName'",
                              desc:
                              "Would you like to join?",
                              image: SizedBox(),
                              closeIcon: Icon(Icons.clear, color: Colors.white),
                              buttons: [
                                DialogButton(
                                  child: Text(
                                    "Join",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontFamily: 'Nunito'),
                                  ),
                                  onPressed: () {
                                    // TODO: Add User to group and open group
                                    Navigator.pop(context);
                                  },
                                  color: tertiaryColor,
                                ),
                              ],
                            ).show();
                          }
                        });
                      }));
                });
              }
            });
          });
        });
      });
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: yourGroupsPageCards,
        ),
      ),
    );
  }

  List<Widget> publicGroupsPageCards = [];
  bool populatedPublicGroupPageCards = false;

  Widget publicGroups() {
    if (!populatedPublicGroupPageCards) {
      populatedPublicGroupPageCards = true;
      User user = Provider.of(context).auth.firebaseAuth.currentUser;
      publicGroupsPageCards.clear();
      FirebaseFirestore.instance
          .collection("DigiGroup")
          .get()
          .then((QuerySnapshot allGroupsSnapshot) {
        allGroupsSnapshot.docs.forEach((groupDoc) {
          FirebaseFirestore.instance
              .collection("DigiGroup")
              .doc(groupDoc.id)
              .collection("Members")
              .get()
              .then((QuerySnapshot membersDocuments) {
            bool containsMyselfAsAUser = false;
            membersDocuments.docs.forEach((member) {
              if (member.id.contains(user.email)) {
                containsMyselfAsAUser = true;
              }
            });
            if (!containsMyselfAsAUser &&
                groupDoc.get("visibility").toString().contains("Public")) {
              setState(() {
                publicGroupsPageCards.add(groupCardBuilder(
                    groupName: groupDoc.id,
                    imageSrc: groupDoc.get("image"),
                    members: 10,
                    activeChallenges: 2,
                    cardTypes: CardTypes.PUBLIC_GROUP));
              });
            }
          });
        });
      });
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: publicGroupsPageCards,
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
            groupCardBuilder(
                groupName: "Weight... What?",
                imageSrc:
                    "https://img.icons8.com/cotton/250/000000/weight-1--v2.png",
                inviter: "Suporgamer",
                cardTypes: CardTypes.GROUP_INVITES),
          ],
        ),
      ),
    );
  }

  GestureDetector groupCardBuilder(
      {String groupName,
      String imageSrc,
      int members,
      int activeChallenges,
      String inviter,
      GroupVisibility groupVisibility,
      CardTypes cardTypes,
      Function(String) callback}) {
    if (cardTypes == CardTypes.MY_GROUP) {
      return GestureDetector(
        onTap: () {
          callback(groupName);
        },
        child: Card(
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
                                        borderRadius:
                                            BorderRadius.circular(10.0),
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
                                        borderRadius:
                                            BorderRadius.circular(10.0),
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
                                        borderRadius:
                                            BorderRadius.circular(10.0),
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
        ),
      );
    } else if (cardTypes == CardTypes.PUBLIC_GROUP) {
      return GestureDetector(
        child: Card(
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
                                        borderRadius:
                                            BorderRadius.circular(10.0),
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
                                        borderRadius:
                                            BorderRadius.circular(10.0),
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
        ),
      );
    } else if (cardTypes == CardTypes.GROUP_INVITES) {
      return GestureDetector(
        child: Card(
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
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      color: tertiaryColor,
                                      shadowColor: Colors.black54,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0, vertical: 2.0),
                                        child: Column(
                                          children: [
                                            Icon(
                                                Icons.mark_email_unread_rounded,
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
        ),
      );
    }
  }
}
