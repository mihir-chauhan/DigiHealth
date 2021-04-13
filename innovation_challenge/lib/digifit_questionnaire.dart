import 'package:auto_size_text/auto_size_text.dart';
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
                              question1Selection = 0;
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
                              question2Selection = 0;
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
                              question3Selection = 0;
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
                              question4Selection = 0;
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
                              "150-250",
                              "200-250",
                              "250-300"
                                  "300-500",
                              "500-1000",
                            ],
                            onSelected: (String selected) {
                              question5Selection = 0;
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
