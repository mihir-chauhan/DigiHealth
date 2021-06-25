import 'package:auto_size_text/auto_size_text.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:DigiHealth/appPrefs.dart';

class GroupChallengesPage extends StatefulWidget {
  @override
  _GroupChallengesPageState createState() => _GroupChallengesPageState();
}

class _GroupChallengesPageState extends State<GroupChallengesPage> {
  var _height;
  var _width;
  DateTime upcomingChallengeExpiryDate = DateTime(1970, 1, 1);
  List<Widget> challengeCards = [];
  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    PopulateChallenges();
    return CupertinoPageScaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: secondaryColor,
        navigationBar: CupertinoNavigationBar(
          transitionBetweenRoutes: false,
          heroTag: "profilePage",
          middle: Text("Group Challenges",
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
        child: Scaffold(
          backgroundColor: primaryColor,
          body: SingleChildScrollView(
            child: SafeArea(
                child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: challengeCards,
              ),
            )),
          ),
        ));
  }

  Widget buildChallengeCard(
      {String challengeName,
      String imageSource,
      String difficulty,
      String goal,
      DateTime finishDate,
      String challengeType,
      int points,
      bool isParticipating}) {
    return FlipCard(
        // key: cardKey,
        back: Container(),
        front: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          color: secondaryColor,
          shadowColor: Colors.black54,
          child: Container(
              width: _width * 0.9,
              child: Padding(
                padding: EdgeInsets.all(15),
                child: Column(
                  children: [
                    Image.network(imageSource),
                    SizedBox(height: _height * 0.0125),
                    Padding(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        child: AutoSizeText(challengeName,
                            maxLines: 1,
                            maxFontSize: 30,
                            style: TextStyle(
                                fontSize: 30,
                                color: Colors.white,
                                fontFamily: 'Nunito',
                                fontWeight: FontWeight.w200))),
                    SizedBox(height: _height * 0.0125),
                    Padding(
                        padding: EdgeInsets.only(left: 20, right: 20),
                        child: AutoSizeText(goal,
                            maxLines: 2,
                            maxFontSize: 22,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 22,
                                color: Colors.white,
                                fontFamily: 'Nunito',
                                fontWeight: FontWeight.w200))),
                    SizedBox(height: _height * 0.0125),
                    Text("Complexity: $difficulty",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 22,
                            color: Colors.white,
                            fontFamily: 'Nunito',
                            fontWeight: FontWeight.w200)),
                    Text("Points: $points",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 22,
                            color: Colors.white,
                            fontFamily: 'Nunito',
                            fontWeight: FontWeight.w200)),
                    SizedBox(height: _height * 0.0125),
                    CupertinoButton(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      child: Text("View Competitors",
                          style: TextStyle(
                              fontSize: 20,
                              color: primaryColor,
                              fontFamily: 'Nunito',
                              fontWeight: FontWeight.w200)),
                      onPressed: () async {
                        // cardKey.currentState.toggleCard();
                      },
                    )
                  ],
                ),
              )),
        ));
  }

  PopulateChallenges() {
    challengeCards.add(buildChallengeCard(
        challengeName: "Step Up Your Health",
        imageSource:
            "https://firebasestorage.googleapis.com/v0/b/innov8rz-innovation-challenge.appspot.com/o/bronze_medal.png?alt=media&token=3e3ddff9-a1a9-4fa7-a4ad-70ca4438e70f",
        difficulty: "Easy",
        goal: "Reach 120000 steps this month",
        finishDate: upcomingChallengeExpiryDate,
        points: 10000,
        challengeType: "Steps",
        isParticipating: true));
    challengeCards.add(SizedBox(height: _height * 0.0125));
    challengeCards.add(buildChallengeCard(
        challengeName: "Calory Victory",
        imageSource:
            "https://firebasestorage.googleapis.com/v0/b/innov8rz-innovation-challenge.appspot.com/o/bronze_calories.png?alt=media&token=9a6fa73c-3d00-4eff-9806-74b17258887c",
        difficulty: "Easy",
        goal: "Burn at least 10000 calories a week for a month",
        finishDate: upcomingChallengeExpiryDate,
        points: 1500,
        challengeType: "Calories",
        isParticipating: true));
  }
}
