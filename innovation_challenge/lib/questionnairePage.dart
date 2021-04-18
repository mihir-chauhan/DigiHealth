import 'package:DigiHealth/provider_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:DigiHealth/appPrefs.dart';
import 'package:grouped_buttons/grouped_buttons.dart';

class QuestionnairePage extends StatefulWidget {
  @override
  _QuestionnairePageState createState() =>
      _QuestionnairePageState();
}

class _QuestionnairePageState extends State<QuestionnairePage> {
  int question1Selection = -1;
  int question2Selection = -1;
  int question3Selection = -1;
  int question4Selection = -1;
  int question5Selection = -1;

  int fitquestion1Selection = -1;
  int fitquestion2Selection = -1;
  int fitquestion3Selection = -1;
  int fitquestion4Selection = -1;
  int fitquestion5Selection = -1;

  bool hideResult = true;
  String dietName = "Mediterranean Diet";
  var _height;

  @override
  Widget build(BuildContext context) {
    var _context = context;
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
                  question5Selection != -1 &&
                  fitquestion1Selection != -1 &&
                  fitquestion2Selection != -1 &&
                  fitquestion3Selection != -1 &&
                  fitquestion4Selection != -1 &&
                  fitquestion5Selection != -1) {
                final FirebaseUser user =
                    await Provider.of(context).auth.firebaseAuth.currentUser();
                final databaseReference = Firestore.instance;

                dietName = dietRecommendationFromAnswers();
                await databaseReference
                    .collection("User Data")
                    .document(user.email)
                    .updateData({"Diet Plan": dietName});
                await databaseReference
                    .collection("User Data")
                    .document(user.email)
                    .updateData({
                  "Diet Question 1": question1Selection,
                  "Diet Question 2": question2Selection,
                  "Diet Question 3": question3Selection,
                  "Diet Question 4": question4Selection,
                  "Diet Question 5": question5Selection,
                  "Fit Question 1": fitquestion1Selection,
                  "Fit Question 2": fitquestion2Selection,
                  "Fit Question 3": fitquestion3Selection,
                  "Fit Question 4": fitquestion4Selection,
                  "Fit Question 5": fitquestion5Selection,
                  "Questionnaire": true,
                });
                showCupertinoDialog(
                    context: context,
                    builder: (BuildContext context) => CupertinoAlertDialog(
                          title: new Text("Your Diet Is..."),
                          content: new Text(dietName + "!"),
                          actions: <Widget>[
                            CupertinoDialogAction(
                              isDefaultAction: true,
                              child: Text("Continue"),
                              onPressed: () {
                                Navigator.of(context).pop();
                                Navigator.of(_context).pop();
                              },
                            )
                          ],
                        ));
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
                              "I’d like to lose some weight and\nbe healthier.")) {
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
                ),
                SizedBox(height: _height * 0.05),
                Container(
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text("What are your fitness goals?",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontFamily: 'Nunito')),
                      ),
                      RadioButtonGroup(
                        labels: <String>[
                          "No Pain No Gain!",
                          "I want to go to the gym many\ntimes a week.",
                          "I'm looking to start my fitness\nadventure.",
                          "I want to exercise sometimes?",
                        ],
                        onSelected: (String selected) {
                          if (selected
                              .contains("No Pain No Gain!")) {
                            fitquestion1Selection = 0;
                          } else if (selected.contains(
                              "I want to go to the gym many\ntimes a week.")) {
                            fitquestion1Selection = 1;
                          } else if (selected.contains(
                              "I'm looking to start my fitness\nadventure.")) {
                            fitquestion1Selection = 2;
                          } else if (selected.contains(
                              "I want to exercise sometimes?")) {
                            fitquestion1Selection = 3;
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
                        child: Text("Currently, how active are you?",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontFamily: 'Nunito')),
                      ),
                      RadioButtonGroup(
                        labels: <String>[
                          "GYM IS LIFE!",
                          "I occasionally gym out.",
                          "I only exercise when I'm forced to.",
                          "What is exercise?",
                        ],
                        onSelected: (String selected) {
                          if (selected
                              .contains("GYM IS LIFE!")) {
                            fitquestion2Selection = 0;
                          } else if (selected.contains(
                              "I occasionally gym out.")) {
                            fitquestion2Selection = 1;
                          } else if (selected.contains(
                              "I only exercise when I'm forced to.")) {
                            fitquestion2Selection = 2;
                          } else if (selected.contains(
                              "What is exercise?")) {
                            fitquestion2Selection = 3;
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
                        child: Text("What type of exercise suits you?",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontFamily: 'Nunito')),
                      ),
                      RadioButtonGroup(
                        labels: <String>[
                          "I'm fine with anything.",
                          "I need that burn.",
                          "Slow and steady wins the race.",
                          "I don't exercise often enough to\nhave a type.",
                        ],
                        onSelected: (String selected) {
                          if (selected
                              .contains("I'm fine with anything.")) {
                            fitquestion3Selection = 0;
                          } else if (selected.contains(
                              "I need that burn.")) {
                            fitquestion3Selection = 1;
                          } else if (selected.contains(
                              "Slow and steady wins the race.")) {
                            fitquestion3Selection = 2;
                          } else if (selected.contains(
                              "I don't exercise often enough to\nhave a type.")) {
                            fitquestion3Selection = 3;
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
                        child: Text("What is you height in feet?",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontFamily: 'Nunito')),
                      ),
                      RadioButtonGroup(
                        labels: <String>[
                          "3-4",
                          "4-5",
                          "5-6",
                          "6-7",
                        ],
                        onSelected: (String selected) {
                          if (selected
                              .contains("3-4")) {
                            fitquestion4Selection = 0;
                          } else if (selected.contains(
                              "4-5")) {
                            fitquestion4Selection = 1;
                          } else if (selected.contains(
                              "5-6")) {
                            fitquestion4Selection = 2;
                          } else if (selected.contains(
                              "6-7")) {
                            fitquestion4Selection = 3;
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
                        child: Text("What is your weight in lbs?",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontFamily: 'Nunito')),
                      ),
                      RadioButtonGroup(
                        labels: <String>[
                          "0-50",
                          "50-100",
                          "100-150",
                          "150-200",
                          "200-250",
                          "250-300",
                          "300-500",
                          "500-1000",
                        ],
                        onSelected: (String selected) {
                          if (selected
                              .contains("0-50")) {
                            fitquestion5Selection = 0;
                          } else if (selected.contains(
                              "50-100")) {
                            fitquestion5Selection = 1;
                          } else if (selected.contains(
                              "100-150")) {
                            fitquestion5Selection = 2;
                          } else if (selected.contains(
                              "150-200")) {
                            fitquestion5Selection = 3;
                          } else if (selected.contains(
                              "200-250")) {
                            fitquestion5Selection = 4;
                          } else if (selected.contains(
                              "250-300")) {
                            fitquestion5Selection = 5;
                          } else if (selected.contains(
                              "300-500")) {
                            fitquestion5Selection = 6;
                          } else if (selected.contains(
                              "500-1000")) {
                            fitquestion5Selection = 7;
                          }
                        },
                        labelStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontFamily: 'Nunito'),
                        activeColor: Colors.white,
                      ),
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