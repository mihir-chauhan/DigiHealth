import 'package:DigiHealth/createGroupPage.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:DigiHealth/appPrefs.dart';

class GroupsPage extends StatefulWidget {
  @override
  _GroupsPageState createState() => _GroupsPageState();
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
              labelColor: Colors.black,
              unselectedLabelColor: Colors.white70,
            ),
            views: [yourGroupsPage(), publicGroups(), groupInvites()],
          ),
        ));
  }

  Widget yourGroupsPage() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Card(
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
                                "https://img.icons8.com/clouds/250/000000/walking.png",
                                height: MediaQuery.of(context).size.width * 0.3,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                        child: AutoSizeText("Group Name",
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
                                                Text("10",
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
                                                Text("2",
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
                                                Icon(Icons.visibility,
                                                    color: Colors.white),
                                                Text("Public",
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
            Card(
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
                                "https://img.icons8.com/clouds/250/000000/walking.png",
                                height: MediaQuery.of(context).size.width * 0.3,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                        child: AutoSizeText("Group Name",
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
                                                Text("10",
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
                                                Text("2",
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
                                                Icon(Icons.visibility,
                                                    color: Colors.white),
                                                Text("Public",
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
            Card(
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
                                "https://img.icons8.com/clouds/250/000000/walking.png",
                                height: MediaQuery.of(context).size.width * 0.3,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                        child: AutoSizeText("Group Name",
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
                                                Text("10",
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
                                                Text("2",
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
                                                Icon(Icons.visibility,
                                                    color: Colors.white),
                                                Text("Public",
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
            Card(
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
                                "https://img.icons8.com/clouds/250/000000/walking.png",
                                height: MediaQuery.of(context).size.width * 0.3,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                        child: AutoSizeText("Group Name",
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
                                                Text("10",
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
                                                Text("2",
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
                                                Icon(Icons.visibility,
                                                    color: Colors.white),
                                                Text("Public",
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
            Card(
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
                                "https://img.icons8.com/clouds/250/000000/walking.png",
                                height: MediaQuery.of(context).size.width * 0.3,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                        child: AutoSizeText("Group Name",
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
                                                Text("10",
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
                                                Text("2",
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
                                                Icon(Icons.visibility,
                                                    color: Colors.white),
                                                Text("Public",
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
            Card(
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
                                "https://img.icons8.com/clouds/250/000000/walking.png",
                                height: MediaQuery.of(context).size.width * 0.3,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                        child: AutoSizeText("Group Name",
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
                                                Text("10",
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
                                                Text("2",
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
                                                Icon(Icons.visibility,
                                                    color: Colors.white),
                                                Text("Public",
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
            Card(
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
                                "https://img.icons8.com/clouds/250/000000/walking.png",
                                height: MediaQuery.of(context).size.width * 0.3,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                        child: AutoSizeText("Group Name",
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
                                                Text("10",
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
                                                Text("2",
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
                                                Icon(Icons.visibility,
                                                    color: Colors.white),
                                                Text("Public",
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
            Card(
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
                                "https://img.icons8.com/clouds/250/000000/walking.png",
                                height: MediaQuery.of(context).size.width * 0.3,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                        child: AutoSizeText("Group Name",
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
                                                Text("10",
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
                                                Text("2",
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
                                                Icon(Icons.visibility,
                                                    color: Colors.white),
                                                Text("Public",
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
            Card(
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
                                "https://img.icons8.com/clouds/250/000000/walking.png",
                                height: MediaQuery.of(context).size.width * 0.3,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                        child: AutoSizeText("Group Name",
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
                                                Icon(Icons.mark_email_unread_rounded,
                                                    color: Colors.white),
                                                AutoSizeText("Suporgamer",
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
          ],
        ),
      ),
    );
  }
}
