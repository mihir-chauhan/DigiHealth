import 'package:DigiHealth/provider_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:DigiHealth/appPrefs.dart';
import 'package:grouped_buttons/grouped_buttons.dart';

class DigiDietQuestionnairePage extends StatefulWidget {
  @override
  _DigiDietQuestionnairePageState createState() =>
      _DigiDietQuestionnairePageState();
}

class _DigiDietQuestionnairePageState extends State<DigiDietQuestionnairePage> {
  int question1Selection = -1;
  int question2Selection = -1;
  int question3Selection = -1;
  int question4Selection = -1;
  int question5Selection = -1;
  bool hideResult = true;
  String dietName = "Mediterranean Diet";
  var _height;

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    return CupertinoPageScaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: secondaryColor,
      navigationBar: CupertinoNavigationBar(
          transitionBetweenRoutes: false,
          heroTag: "digidietQuestionnairePage",
          middle: Text("DigiDiet Questionnaire",
              style: TextStyle(color: Colors.white, fontFamily: 'Nunito')),
          backgroundColor: secondaryColor,
          leading: GestureDetector(
            child: Icon(
              Icons.circle,
              color: secondaryColor,
            ),
          ),
          trailing: GestureDetector(
            onTap: () async {
              if (question1Selection != -1 &&
                  question2Selection != -1 &&
                  question3Selection != -1 &&
                  question4Selection != -1 &&
                  question5Selection != -1) {
                final FirebaseUser user =
                    await Provider.of(context).auth.firebaseAuth.currentUser();
                final databaseReference = Firestore.instance;

                dietName = dietRecommendationFromAnswers();
                await databaseReference
                    .collection("User Data")
                    .document(user.email)
                    .updateData({"Diet Plan": dietName});
                setState(() {
                  hideResult = false;
                });
              }
            },
            child: Icon(
              Icons.done,
              color: CupertinoColors.white,
              size: 30,
            ),
          )),
      child: Scaffold(
        backgroundColor: primaryColor,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: <Widget>[
                Container(
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text("What are your dieting goals?",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontFamily: 'Nunito')),
                      ),
                      RadioButtonGroup(
                        labels: <String>[
                          "I'm looking to shred fat fast!",
                          "I’d like to lose some weight and\nbe healthier.",
                          "I’m really looking for balance and\nlong-term health.",
                          "I want to improve my health in a\nway that’s also sustainable.",
                        ],
                        onSelected: (String selected) {
                          if (selected
                              .contains("I'm looking to shred fat fast!")) {
                            question1Selection = 0;
                          } else if (selected.contains(
                              "I’d like to lose some weight and be\nhealthier.")) {
                            question1Selection = 1;
                          } else if (selected.contains(
                              "I’m really looking for balance and\nlong-term health.")) {
                            question1Selection = 2;
                          } else if (selected.contains(
                              "I want to improve my health in a\nway that’s also sustainable.")) {
                            question1Selection = 3;
                          }
                        },
                        labelStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontFamily: 'Nunito'),
                        activeColor: Colors.white,
                      )
                    ],
                  ),
                ),
                SizedBox(height: _height * 0.05),
                Container(
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text("How committed are you willing to be?",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontFamily: 'Nunito')),
                      ),
                      RadioButtonGroup(
                        labels: <String>[
                          "I'm ready to go the full nine\nyards on my eating habits.",
                          "I can put in the hard work but\nI also need my cheat days.",
                          "I don’t mind making sacrifices\nwhen it’s important.",
                          "I’m really not looking to go too\nfar outside my comfort zone.",
                        ],
                        onSelected: (String selected) {
                          if (selected.contains(
                              "I'm ready to go the full nine\nyards on my eating habits.")) {
                            question2Selection = 0;
                          } else if (selected.contains(
                              "I can put in the hard work but\nI also need my cheat days.")) {
                            question2Selection = 1;
                          } else if (selected.contains(
                              "I don’t mind making sacrifices\nwhen it’s important.")) {
                            question2Selection = 2;
                          } else if (selected.contains(
                              "I’m really not looking to go too\nfar outside my comfort zone.")) {
                            question2Selection = 3;
                          }
                        },
                        labelStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontFamily: 'Nunito'),
                        activeColor: Colors.white,
                      )
                    ],
                  ),
                ),
                SizedBox(height: _height * 0.05),
                Container(
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Are you a meat eater?",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontFamily: 'Nunito')),
                      ),
                      RadioButtonGroup(
                        labels: <String>[
                          "I love it all.",
                          "Is there anything else?",
                          "I try to limit red meat.",
                          "There are so many better sources\nof protein.",
                        ],
                        onSelected: (String selected) {
                          if (selected.contains("I love it all.")) {
                            question3Selection = 0;
                          } else if (selected
                              .contains("Is there anything else?")) {
                            question3Selection = 1;
                          } else if (selected
                              .contains("I try to limit red meat.")) {
                            question3Selection = 2;
                          } else if (selected.contains(
                              "There are so many better sources\nof protein.")) {
                            question3Selection = 3;
                          }
                        },
                        labelStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontFamily: 'Nunito'),
                        activeColor: Colors.white,
                      )
                    ],
                  ),
                ),
                SizedBox(height: _height * 0.05),
                Container(
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Do you love carbs?",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontFamily: 'Nunito')),
                      ),
                      RadioButtonGroup(
                        labels: <String>[
                          "Yes! In every glorious form!",
                          "There are healthy carbs, right?",
                          "No way, I want my body burning\nclean fuel.",
                        ],
                        onSelected: (String selected) {
                          if (selected
                              .contains("Yes! In every glorious form!")) {
                            question4Selection = 0;
                          } else if (selected
                              .contains("There are healthy carbs, right?")) {
                            question4Selection = 1;
                          } else if (selected.contains(
                              "No way, I want my body burning\nclean fuel.")) {
                            question4Selection = 2;
                          }
                        },
                        labelStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontFamily: 'Nunito'),
                        activeColor: Colors.white,
                      )
                    ],
                  ),
                ),
                SizedBox(height: _height * 0.05),
                Container(
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text("What are your feelings on dairy?",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontFamily: 'Nunito')),
                      ),
                      RadioButtonGroup(
                        labels: <String>[
                          "Lactose intolerant and fine with it.",
                          "Who doesn’t like butter and\ncheese?",
                          "Ice cream is pure joy. No one is\ntaking that from me.",
                        ],
                        onSelected: (String selected) {
                          if (selected.contains(
                              "Lactose intolerant and fine with it.")) {
                            question5Selection = 0;
                          } else if (selected.contains(
                              "Who doesn’t like butter and\ncheese?")) {
                            question5Selection = 1;
                          } else if (selected.contains(
                              "Ice cream is pure joy. No one is\ntaking that from me.")) {
                            question5Selection = 2;
                          }
                        },
                        labelStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontFamily: 'Nunito'),
                        activeColor: Colors.white,
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  String dietRecommendationFromAnswers() {
    print(question1Selection.toString() +
        ", " +
        question2Selection.toString() +
        ", " +
        question3Selection.toString() +
        ", " +
        question4Selection.toString() +
        ", " +
        question5Selection.toString());
    int pointsForPaleolithic = 0;
    int pointsForMediterraneanDiet = 0;
    int pointsForIntermittentFasting = 0;
    int pointsForWFPBDiet = 0;

    /**Question 1**/
    if (question1Selection == 0) {
      pointsForIntermittentFasting++;
    } else if (question1Selection == 1) {
      pointsForPaleolithic++;
    } else if (question1Selection == 2) {
      pointsForMediterraneanDiet++;
    } else if (question1Selection == 3) {
      pointsForWFPBDiet++;
    }

    /**Question 2**/
    if (question2Selection == 0) {
      pointsForIntermittentFasting++;
    } else if (question2Selection == 1) {
      pointsForPaleolithic++;
    } else if (question2Selection == 2) {
      pointsForWFPBDiet++;
    } else if (question2Selection == 3) {
      pointsForMediterraneanDiet++;
    }

    /**Question 3**/
    if (question3Selection == 0) {
      pointsForPaleolithic++;
    } else if (question3Selection == 1) {
      pointsForIntermittentFasting++;
    } else if (question3Selection == 2) {
      pointsForMediterraneanDiet++;
    } else if (question3Selection == 3) {
      pointsForWFPBDiet += 3;
      pointsForIntermittentFasting += 3;
    }

    /**Question 4**/
    if (question4Selection == 0) {
      pointsForMediterraneanDiet++;
    } else if (question4Selection == 1) {
      pointsForPaleolithic++;
    } else if (question4Selection == 2) {
      pointsForWFPBDiet++;
    }

    /**Question 5**/
    if (question5Selection == 0) {
      pointsForPaleolithic++;
    } else if (question5Selection == 1) {
      pointsForMediterraneanDiet++;
    } else if (question5Selection == 2) {
      pointsForIntermittentFasting++;
    }

    if (pointsForPaleolithic > pointsForMediterraneanDiet &&
        pointsForPaleolithic > pointsForIntermittentFasting &&
        pointsForPaleolithic > pointsForWFPBDiet) {
      return "Paleolithic Diet";
    } else if (pointsForMediterraneanDiet > pointsForPaleolithic &&
        pointsForMediterraneanDiet > pointsForIntermittentFasting &&
        pointsForMediterraneanDiet > pointsForWFPBDiet) {
      return "Mediterranean Diet";
    } else if (pointsForIntermittentFasting > pointsForPaleolithic &&
        pointsForIntermittentFasting > pointsForIntermittentFasting &&
        pointsForIntermittentFasting > pointsForWFPBDiet) {
      return "Intermittent Fasting";
    } else if (pointsForWFPBDiet > pointsForPaleolithic &&
        pointsForWFPBDiet > pointsForIntermittentFasting &&
        pointsForWFPBDiet > pointsForMediterraneanDiet) {
      return "Whole Food Plant Based Diet";
    } else {
      return "Whole Food Plant Based Diet";
    }
  }
}
