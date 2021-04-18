import 'package:DigiHealth/provider_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:DigiHealth/appPrefs.dart';
import 'package:grouped_buttons/grouped_buttons.dart';

class DigiFitQuestionnairePage extends StatefulWidget {
  @override
  _DigiFitQuestionnairePageState createState() =>
      _DigiFitQuestionnairePageState();
}

class _DigiFitQuestionnairePageState extends State<DigiFitQuestionnairePage> {
  int question1Selection = -1;
  int question2Selection = -1;
  int question3Selection = -1;
  int question4Selection = -1;
  int question5Selection = -1;
  bool hideResult = true;
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
            heroTag: "DigiFitQuestionnairePage",
            middle: Text("DigiFit Questionnaire",
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

                  await databaseReference
                      .collection("User Data")
                      .document(user.email)
                      .updateData({"Fitness Question 1": question1Selection, "Fitness Question 2": question2Selection, "Fitness Question 3": question3Selection, "Fitness Question 4": question4Selection, "Fitness Question 5": question5Selection, "Fitness Questionnaire": true});

                  showCupertinoDialog(
                      context: context,
                      builder: (BuildContext context) => CupertinoAlertDialog(
                            title: new Text("Thanks!"),
                            content: new Text("Have Fun Exercising!"),
                            actions: <Widget>[
                              CupertinoDialogAction(
                                isDefaultAction: true,
                                child: Text("Start Exercising!"),
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
        child: Stack(children: [
          Scaffold(
              backgroundColor: primaryColor,
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(children: <Widget>[
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
                                question1Selection = 0;
                              } else if (selected.contains(
                                  "I want to go to the gym many\ntimes a week.")) {
                                question1Selection = 1;
                              } else if (selected.contains(
                                  "I'm looking to start my fitness\nadventure.")) {
                                question1Selection = 2;
                              } else if (selected.contains(
                                  "I want to exercise sometimes?")) {
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
                                question2Selection = 0;
                              } else if (selected.contains(
                                  "I occasionally gym out.")) {
                                question2Selection = 1;
                              } else if (selected.contains(
                                  "I only exercise when I'm forced to.")) {
                                question2Selection = 2;
                              } else if (selected.contains(
                                  "What is exercise?")) {
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
                                question3Selection = 0;
                              } else if (selected.contains(
                                  "I need that burn.")) {
                                question3Selection = 1;
                              } else if (selected.contains(
                                  "Slow and steady wins the race.")) {
                                question3Selection = 2;
                              } else if (selected.contains(
                                  "I don't exercise often enough to\nhave a type.")) {
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
                                question4Selection = 0;
                              } else if (selected.contains(
                                  "4-5")) {
                                question4Selection = 1;
                              } else if (selected.contains(
                                  "5-6")) {
                                question4Selection = 2;
                              } else if (selected.contains(
                                  "6-7")) {
                                question4Selection = 3;
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
                                question5Selection = 0;
                              } else if (selected.contains(
                                  "50-100")) {
                                question5Selection = 1;
                              } else if (selected.contains(
                                  "100-150")) {
                                question5Selection = 2;
                              } else if (selected.contains(
                                  "150-200")) {
                                question5Selection = 3;
                              } else if (selected.contains(
                                  "200-250")) {
                                question5Selection = 4;
                              } else if (selected.contains(
                                  "250-300")) {
                                question5Selection = 5;
                              } else if (selected.contains(
                                  "300-500")) {
                                question5Selection = 6;
                              } else if (selected.contains(
                                  "500-1000")) {
                                question5Selection = 7;
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
                    ),
                  ]),
                ),
              )),
          hideResult
              ? new Container()
              : Container(
                  alignment: Alignment.center,
                  padding: new EdgeInsets.only(right: 20.0, left: 20.0),
                  child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: tertiaryColor),
                      height: MediaQuery.of(context).size.height * 0.161,
                      width: MediaQuery.of(context).size.width,
                      child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(children: [
                            Align(
                                alignment: Alignment.bottomCenter,
                                child: CupertinoButton(
                                  color: primaryColor,
                                  child: Text('Start Exercising!',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'Nunito',
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.w300)),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ))
                          ]))))
        ]));
  }
}
