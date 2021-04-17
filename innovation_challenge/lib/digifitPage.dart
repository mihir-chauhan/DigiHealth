import 'package:DigiHealth/digifit_questionnaire.dart';
import 'package:DigiHealth/provider_widget.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:draw_graph/draw_graph.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:DigiHealth/appPrefs.dart';
import 'package:draw_graph/models/feature.dart';
import 'package:category_picker/category_picker.dart';
import 'package:category_picker/category_picker_item.dart';
import 'package:multi_charts/multi_charts.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DigiFitPage extends StatefulWidget {
  DigiFitPage();

  @override
  _DigiFitPageState createState() => _DigiFitPageState();
}

class _DigiFitPageState extends State<DigiFitPage> {
  final List<Feature> features = [
    Feature(
      title: "Calories Burnt",
      color: Colors.blue,
      data: [0.2, 0.3, 0.4, 0.7, 0.9],
    ),
    Feature(
      title: "Time Exercised",
      color: Colors.red,
      data: [0.1, 0.5, 0.3, 0.6, 0.7],
    )
  ];
  List<String> indoor = ['Treadmill', 'S1'];
  List<String> outdoor = ['Running', 'S2'];
  List<String> highImpact = ['Biking', 'S3'];
  List<String> lowImpact = ['Walking', 'S4'];
  String otherValue = 'Indoor';
  int listNumForIndoor = 0;
  int listNumForOutdoor = 0;
  int listNumForHighImpact = 0;
  int listNumForLowImpact = 0;
  Icon dietIcon = Icon(Icons.whatshot_rounded, color: Colors.white);
  Icon journalIcon = Icon(Icons.analytics_outlined, color: Colors.white);
  var _height;
  var _width;
  void updateTabBarController(int i) {
    setState(() {
      dietIcon = (i == 0)
          ? Icon(Icons.whatshot_rounded, color: Colors.white)
          : Icon(Icons.whatshot_outlined, color: Colors.white);
      journalIcon = (i == 1)
          ? Icon(Icons.analytics_rounded, color: Colors.white)
          : Icon(Icons.analytics_outlined, color: Colors.white);
    });
  }

  Widget updateViewBasedOnTab(int i) {
    if (Provider.of(context).auth.showDigiFitQuestionnaire) {
      openQuestionnaire();
    }
    if (i == 0) {
      return CupertinoPageScaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: primaryColor,
        child: Column(
          children: [
            CategoryPicker(
              items: [
                CategoryPickerItem(value: 'Indoor'),
                CategoryPickerItem(value: 'Outdoor'),
                CategoryPickerItem(value: 'High-Impact'),
                CategoryPickerItem(value: 'Low-Impact'),
              ],
              onValueChanged: (value) {
                setState(() {
                  otherValue = value.value;
                });
              },
              backgroundColor: primaryColor,
              selectedItemColor: tertiaryColor,
              unselectedItemBorderColor: Colors.black,
              selectedItemTextDarkThemeColor: Colors.white,
              selectedItemTextLightThemeColor: Colors.white,
              unselectedItemTextDarkThemeColor: Colors.black,
              unselectedItemTextLightThemeColor: Colors.black,
            ),
            SizedBox(height: 25),
            Text(
              otherValue == 'Indoor'
                  ? indoor[listNumForIndoor]
                  : otherValue == 'Outdoor'
                      ? outdoor[listNumForOutdoor]
                      : otherValue == 'High-Impact'
                          ? highImpact[listNumForHighImpact]
                          : lowImpact[listNumForLowImpact],
              style: TextStyle(
                  color: Colors.white, fontFamily: 'Nunito', fontSize: 60),
            ),
            SizedBox(
              height: 25,
            ),
            CupertinoButton(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.5,
                height: MediaQuery.of(context).size.width * 0.5,
                decoration: new BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.play_arrow,
                  color: Colors.green,
                  size: MediaQuery.of(context).size.width * 0.5,
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                      builder: (context) => SecondRoute(otherValue)),
                );
              },
            )
          ],
        ),
      );
    } else {
      return new Scaffold(
        backgroundColor: primaryColor,
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(5.0),
            child: Column(
              children: [
                SizedBox(
                  height: _height * 0.01,
                ),
                Container(
                  width: _width,
                  height: _height * 0.0025,
                  color: secondaryColor,
                ),
                Center(
                    child: Text("Your Fitness Stats",
                        style: TextStyle(
                            fontSize: 30,
                            color: Colors.white,
                            fontFamily: 'Nunito',
                            fontWeight: FontWeight.w200))),
                Container(
                  width: _width,
                  height: _height * 0.0025,
                  color: secondaryColor,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, top: 10.0),
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: AutoSizeText("Improvement Over Time",
                          maxLines: 1,
                          style: TextStyle(
                              fontSize: 30,
                              color: Colors.white,
                              fontFamily: 'Nunito',
                              fontWeight: FontWeight.w400))),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 350,
                  decoration: BoxDecoration(
                      color: tertiaryColor,
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 30.0,
                    ),
                    child: LineGraph(
                      features: features,
                      size: Size(320, 300),
                      labelX: ['Day 1', 'Day 5', 'Day 10', 'Day 15', 'Day 20'],
                      labelY: ['20', '40', '60', '80', '100'],
                      showDescription: true,
                      graphColor: Colors.white60,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, top: 10.0),
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: AutoSizeText("Average Type of Exercise Done",
                          maxLines: 1,
                          style: TextStyle(
                              fontSize: 30,
                              color: Colors.white,
                              fontFamily: 'Nunito',
                              fontWeight: FontWeight.w400))),
                ),
                Container(
                  height: 320,
                  decoration: BoxDecoration(
                      color: tertiaryColor,
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: PieChart(
                      values: [
                        23,
                        39,
                        24,
                        14,
                      ],
                      labels: [
                        "Indoor",
                        "Outdoor",
                        "High-Impact",
                        "Low-Impact",
                      ],
                      labelColor: Colors.white,
                      legendTextColor: Colors.white,
                      textScaleFactor: 0.07,
                      curve: Curves.easeInOutExpo,
                      legendPosition: LegendPosition.Bottom,
                      separateFocusedValue: true,
                    ),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.only(left: 8.0, top: 10.0),
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: AutoSizeText(
                            "Rate of Improvement Per Day: 13.4%",
                            maxLines: 1,
                            style: TextStyle(
                                fontSize: 30,
                                color: Colors.white,
                                fontFamily: 'Nunito',
                                fontWeight: FontWeight.w400)))),
              ],
            ),
          ),
        ),
      );
    }
  }

  bool hasShownQuestionnaire = false;

  void openQuestionnaire() async {
    await Future.delayed(Duration(milliseconds: 1000), () {
      if (!hasShownQuestionnaire) {
        Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (context) => DigiFitQuestionnairePage()));
        hasShownQuestionnaire = true;
        Provider.of(context).auth.showDigiFitQuestionnaire = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    return CupertinoTabScaffold(
        tabBar: CupertinoTabBar(
            backgroundColor: secondaryColor,
            items: [
              BottomNavigationBarItem(icon: dietIcon),
              BottomNavigationBarItem(icon: journalIcon),
            ],
            onTap: (i) async {
              updateTabBarController(i);
            }),
        tabBuilder: (context, i) {
          return CupertinoPageScaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: primaryColor,
            navigationBar: CupertinoNavigationBar(
              transitionBetweenRoutes: false,
              heroTag: "digifitPage",
              middle: Text("DigiFit " + (i == 0 ? "Fitness Tracker" : "Stats"),
                  style: TextStyle(color: Colors.white, fontFamily: 'Nunito')),
              backgroundColor: secondaryColor,
              leading: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(
                  CupertinoIcons.back,
                  color: CupertinoColors.white,
                  size: 30,
                ),
              ),
              trailing: GestureDetector(
                onTap: () {
                  print('Too Coolio for Schoolio');
                  setState(() {
                    if (otherValue == 'Indoor') {
                      listNumForIndoor++;
                    } else if (otherValue == 'Outdoor') {
                      listNumForOutdoor++;
                    } else if (otherValue == 'High-Impact') {
                      listNumForHighImpact++;
                    } else if (otherValue == 'Low-Impact') {
                      listNumForLowImpact++;
                    }

                    if (listNumForIndoor == indoor.length) {
                      listNumForIndoor = 0;
                    } else if (listNumForOutdoor == outdoor.length) {
                      listNumForOutdoor = 0;
                    } else if (listNumForHighImpact == highImpact.length) {
                      listNumForHighImpact = 0;
                    } else if (listNumForLowImpact == lowImpact.length) {
                      listNumForLowImpact = 0;
                    }
                  });
                },
                child: Icon(
                  CupertinoIcons.refresh,
                  color: CupertinoColors.white,
                  size: 30,
                ),
              ),
            ),
            child: updateViewBasedOnTab(i),
          );
        });
  }

  List<Color> activityColor = [
    //outdoor is orange, indoor is blue
    outdoorExerciseColor,
    tertiaryColor,
    outdoorExerciseColor,
    tertiaryColor
  ];
}

class SecondRoute extends StatefulWidget {
  final String exerciseName;

  const SecondRoute(this.exerciseName);

  @override
  _SecondRouteState createState() => _SecondRouteState();
}

class _SecondRouteState extends State<SecondRoute> {
  double calorieCounter = 0;
  int secondsMarker = 0;
  int secondsTwoMarker = 0;
  int minutesMarker = 0;
  int minutesTwoMarker = 0;
  bool isRunningStopWatch = true;
  bool stopStopWatch = false;
  int timeCounter = 0;

  bool startButtonEnabled = true;
  bool stopButtonEnabled = false;
  bool resetButtonEnabled = false;

  int counterForCaloriesTenSecond = 0;

  caloriesCounter() {
    if (widget.exerciseName == 'Treadmill') {
      calorieCounter = (((calorieCounter + 1.6) * 100).round()) / 100;
    } else if (widget.exerciseName == 'Running') {
      calorieCounter = (((calorieCounter + 1.9) * 100).round()) / 100;
    } else if (widget.exerciseName == 'Biking') {
      calorieCounter = (((calorieCounter + 2.1) * 100).round()) / 100;
    } else if (widget.exerciseName == 'Walking') {
      calorieCounter = (((calorieCounter + 1) * 100).round()) / 100;
    } else {
      calorieCounter = (((calorieCounter + 1.5) * 100).round()) / 100;
    }
  }

  void popupInSeconds() async {
    await Future.delayed(Duration(seconds: 1), () {
      if (isRunningStopWatch == true) {
        timeCounter++;
        popupInSeconds();
        if (counterForCaloriesTenSecond < 10) {
          counterForCaloriesTenSecond++;
        } else {
          counterForCaloriesTenSecond = 0;
          caloriesCounter();
        }
        setState(() {
          if (minutesTwoMarker == 5 &&
              minutesMarker == 9 &&
              secondsTwoMarker == 5 &&
              secondsMarker == 9) {
            secondsMarker = 0;
            secondsTwoMarker = 0;
            minutesMarker = 0;
            minutesTwoMarker = 0;
          } else if (minutesMarker == 9 &&
              secondsTwoMarker == 5 &&
              secondsMarker == 9) {
            minutesTwoMarker++;
            minutesMarker = 0;
          } else if (secondsTwoMarker == 5 && secondsMarker == 9) {
            minutesMarker++;
            secondsTwoMarker = 0;
            secondsMarker = 0;
          } else if (secondsMarker == 9) {
            secondsTwoMarker++;
            secondsMarker = 0;
          } else if (secondsMarker < 9) {
            secondsMarker++;
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: primaryColor,
      navigationBar: CupertinoNavigationBar(
        middle: Text(
          'Stopwatch',
          style: TextStyle(color: Colors.white, fontFamily: 'Nunito'),
        ),
        backgroundColor: secondaryColor,
        leading: GestureDetector(
          child: Icon(
            Icons.circle,
            color: secondaryColor,
          ),
        ),
        trailing: GestureDetector(
          onTap: () async {
            isRunningStopWatch = false;
            if(timeCounter >= 10) {
              writeExerciseDataToFirestoreLog();
            }
             Navigator.of(context).pop();
          },
          child: Icon(
            Icons.done,
            color: CupertinoColors.white,
            size: 30,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Center(
            child: Text(
              minutesTwoMarker.toString() +
                  minutesMarker.toString() +
                  ':' +
                  secondsTwoMarker.toString() +
                  secondsMarker.toString(),
              style: TextStyle(
                  color: Colors.white, fontFamily: 'Nunito', fontSize: 100),
            ),
          ),
          Center(
            child: Text(
              'Calories Burnt: ' + calorieCounter.toString(),
              style: TextStyle(
                  color: Colors.white, fontFamily: 'Nunito', fontSize: 25),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 75.0),
            child: CupertinoButton(
              color: Colors.green,
              disabledColor: tertiaryColor,
              child: Text('Start',
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Nunito',
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold)),
              onPressed: !startButtonEnabled
                  ? null
                  : () {
                      setState(() {
                        isRunningStopWatch = true;
                        stopStopWatch = false;
                        popupInSeconds();
                        startButtonEnabled = false;
                        stopButtonEnabled = true;
                        resetButtonEnabled = false;
                      });
                    },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 75.0),
            child: CupertinoButton(
              color: Colors.orange,
              disabledColor: tertiaryColor,
              child: Text('Pause',
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Nunito',
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold)),
              onPressed: !stopButtonEnabled
                  ? null
                  : () {
                      setState(() {
                        isRunningStopWatch = false;
                        stopStopWatch = false;
                        startButtonEnabled = true;
                        stopButtonEnabled = false;
                        resetButtonEnabled = true;
                      });
                    },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 75.0),
            child: CupertinoButton(
              color: Colors.red,
              disabledColor: tertiaryColor,
              child: Text(
                'Reset',
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Nunito',
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold),
              ),
              onPressed: !resetButtonEnabled
                  ? null
                  : () {
                      setState(() {
                        isRunningStopWatch = false;
                        stopStopWatch = true;
                        calorieCounter = 0.0;
                        startButtonEnabled = true;
                        stopButtonEnabled = false;
                        resetButtonEnabled = false;
                        secondsMarker = 0;
                        secondsTwoMarker = 0;
                        minutesTwoMarker = 0;
                        minutesMarker = 0;
                        timeCounter = 0;
                      });
                    },
            ),
          ),
        ],
      ),
    );
  }

  void writeExerciseDataToFirestoreLog() async {
    final FirebaseUser user =
    await Provider.of(context).auth.firebaseAuth.currentUser();
    final databaseReference = Firestore.instance;

    await databaseReference
        .collection("User Data")
        .document(user.email)
        .collection("Exercise Logs")
        .add({
      "Calories Burned": calorieCounter,
      "Points Earned": calorieCounter*10,
      "Type of Exercise": widget.exerciseName,
      "Seconds of Exercise": timeCounter,
      "Timestamp": Timestamp.now()
    });
    await databaseReference
        .collection("User Data").document(user.email).get().then<dynamic>(( DocumentSnapshot snapshot) async {
      int newPoints = (snapshot.data["Points"] + calorieCounter*10).round();
      print(newPoints);
      databaseReference.collection("User Data").document(user.email).updateData({"Points": newPoints});
    });

  }
}
