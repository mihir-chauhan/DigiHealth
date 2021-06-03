import 'dart:math';
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
import 'package:health_kit/health_kit.dart';

class DigiFitPage extends StatefulWidget {
  DigiFitPage();

  @override
  _DigiFitPageState createState() => _DigiFitPageState();
}

class _DigiFitPageState extends State<DigiFitPage> {
  var caloriesBurnt = ValueNotifier<List<double>>(<double>[]);
  var timeExercised = ValueNotifier<List<double>>(<double>[]);
  var exercisePercentage = ValueNotifier<List<String>>(<String>[]);
  bool hasShownGraphs = false;
  List<double> percentageList = [];
  int highestSecondsForGraph = 0;
  var total = 0.0;

  @override
  void initState() {
    super.initState();
  }

  Future<bool> readPermissionsForHealthKit() async {
    try {
      final responses = await HealthKit.hasPermissions([DataType.STEP_COUNT]);

      if (!responses) {
        final value = await HealthKit.requestPermissions([DataType.STEP_COUNT]);

        return value;
      } else {
        return true;
      }
    } on UnsupportedException catch (e) {
      // thrown in case e.dataType is unsupported
      print("Error:::::::::::::::::: $e");
      return false;
    }
  }

  void getYesterdayStep() async {
    var permissionsGiven = await readPermissionsForHealthKit();

    print("Permission Status: $permissionsGiven");
    if (true) {
      var current = DateTime.now();

      var dateFrom = DateTime.now().subtract(Duration(
        hours: current.hour + 24,
        minutes: current.minute,
        seconds: current.second,
      ));
      var dateTo = dateFrom.add(Duration(
        hours: 23,
        minutes: 59,
        seconds: 59,
      ));

      print('dateFrom: $dateFrom');
      print('dateTo: $dateTo');

      try {
        var results = await HealthKit.read(
          DataType.STEP_COUNT,
          dateFrom: dateFrom,
          dateTo: dateTo,
        );
        if (results != null) {
          for (var result in results) {
            total += result.value;
          }
        }
        setState(() {});
        print('value: $total');
      } on Exception catch (ex) {
        print('Exception in getYesterdayStep: $ex');
      }
    }
  }

  setupGraphs() async {
    caloriesBurnt.value.clear();
    timeExercised.value.clear();
    exercisePercentage.value.clear();
    final User user = Provider.of(context).auth.firebaseAuth.currentUser;

    FirebaseFirestore.instance
        //setsup arraylist
        .collection('User Data')
        .doc(user.email)
        .collection('Exercise Logs')
        .orderBy('Timestamp', descending: false)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        caloriesBurnt.value.add(doc['Calories Burned'] / 1.0);
        timeExercised.value.add(doc['Seconds of Exercise'] / 1.0);
        if (doc['Seconds of Exercise'] > highestSecondsForGraph) {
          highestSecondsForGraph = doc['Seconds of Exercise'];
        }
        exercisePercentage.value.add(doc['Type of Exercise']);
        features = [
          Feature(
            title: "Calories Burnt",
            color: Colors.red,
            data: caloriesBurnt.value,
          ),
          Feature(
            title: "Time Exercised",
            color: Colors.blue,
            data: timeExercised.value,
          ),
        ];
      });
    }).then((value) {
      List<double> timeExerciseScaled = <double>[];
      for (int i = 0; i < timeExercised.value.length; i++) {
        timeExerciseScaled
            .add(timeExercised.value.elementAt(i) / highestSecondsForGraph);
      }
      timeExercised.value = timeExerciseScaled;

      List<double> caloriesBurntScaled = <double>[];
      for (int i = 0; i < caloriesBurnt.value.length; i++) {
        caloriesBurntScaled.add(
            caloriesBurnt.value.elementAt(i) / (highestSecondsForGraph * 0.25));
      }
      caloriesBurnt.value = caloriesBurntScaled;

      setState(() {
        features = [
          Feature(
            title: "Calories Burnt",
            color: Colors.red,
            data: caloriesBurnt.value,
          ),
          Feature(
            title: "Time Exercised",
            color: Colors.blue,
            data: timeExercised.value,
          ),
        ];
        percentageList = percentagesOfExercises();
      });
    });
  }

  List<double> percentagesOfExercises() {
    var indoor = 0;
    var outdoor = 0;
    var highImpact = 0;
    var lowImpact = 0;
    var total = 0;
    for (int i = 0; i < exercisePercentage.value.length; i++) {
      if (exercisePercentage.value[i] == 'Indoor') {
        indoor++;
      } else if (exercisePercentage.value[i] == 'Outdoor') {
        outdoor++;
      } else if (exercisePercentage.value[i] == 'High-Impact') {
        highImpact++;
      } else if (exercisePercentage.value[i] == 'Low-Impact') {
        lowImpact++;
      }
    }

    total = indoor + outdoor + lowImpact + highImpact;
    double percentageOfIndoor = (((indoor / total) * 1000).round()) / 10;
    double percentageOfOutdoor = (((outdoor / total) * 1000).round()) / 10;
    double percentageOfHighImpact =
        (((highImpact / total) * 1000).round()) / 10;
    double percentageOfLowImpact = (((100 -
                    percentageOfOutdoor -
                    percentageOfHighImpact -
                    percentageOfIndoor) *
                10)
            .round()) /
        10;
    return [
      percentageOfIndoor,
      percentageOfOutdoor,
      percentageOfHighImpact,
      percentageOfLowImpact
    ];
  }

  List<Feature> features = [
    Feature(
      title: "Calories Burnt",
      color: Colors.red,
      data: [0],
    ),
    Feature(
      title: "Time Exercised",
      color: Colors.blue,
      data: [0],
    ),
  ];

  List<String> indoor = [
    'Push-Ups',
    'Plank',
    'Curl-Ups',
    'Sit-Ups',
    'Jumping Jacks',
    'Treadmill',
    'Crunches',
    'Squats',
    'Pull-Ups',
    'Weight-Lifting',
    'Lunges',
    'Yoga',
    'Mountain Climbers',
    'Jog in Place',
    'Bicycle',
    'Scissor Kick',
  ];
  List<String> outdoor = [
    'Walking',
    'Hiking',
    'Swimming',
    'Running',
    'Badminton',
    'Tennis',
    'Baseball',
    'Handball',
    'Biking',
    'Basketball',
    'Ice skating',
    'Roller Skating',
    'Volleyball',
    'Horse Riding',
    'Soccer',
    'Golf',
    'Frisbee',
    'Football',
    'Hockey',
    'Bowling',
    'Dancing',
  ];
  List<String> highImpact = [
    'Hiking',
    'Volleyball',
    'Squats',
    'Running',
    'Bicycle Crunch',
    'Aerobics',
    'HIIT Workout',
    'Racquetball',
    'Long Jumps',
    'Tennis',
    'Tricep Dips',
    'Jump Rope',
    'Gymnastics',
    'Burpees',
    'Soccer',
  ];
  List<String> lowImpact = [
    'Swimming',
    'Lunges',
    'Elliptical',
    'Foam Roaller Stretching',
    'Upper Body Stretches',
    'Breathing Exercises',
    'Pilates',
    'Curl-Ups',
    'Walking',
    'Squats',
    'Sitting Stretches',
    'Jog in Place',
    'Golf',
    'Rowing',
    'Total Resistance Xercise'
  ];
  String otherValue = 'Indoor';
  int listNumForIndoor = new Random().nextInt(15);
  int listNumForOutdoor = new Random().nextInt(15);
  int listNumForHighImpact = new Random().nextInt(15);
  int listNumForLowImpact = new Random().nextInt(15);
  Icon dietIcon = Icon(Icons.whatshot_rounded, color: Colors.white);
  Icon journalIcon = Icon(Icons.analytics_outlined, color: Colors.white);
  var _height;
  var _width;

  void updateTabBarController(int i) {
    setupGraphs();
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
    if (!hasShownGraphs) {
      hasShownGraphs = true;
      setupGraphs();
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
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: AutoSizeText(
                otherValue == 'Indoor'
                    ? indoor[listNumForIndoor]
                    : otherValue == 'Outdoor'
                        ? outdoor[listNumForOutdoor]
                        : otherValue == 'High-Impact'
                            ? highImpact[listNumForHighImpact]
                            : lowImpact[listNumForLowImpact],
                maxLines: 1,
                style: TextStyle(
                    color: Colors.white, fontFamily: 'Nunito', fontSize: 60),
              ),
            ),
            SizedBox(
              height: 10,
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
                getYesterdayStep();
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
                      labelX: ['1', '5', '10', '15', '20'],
                      labelY: ['', '', '', '', ''],
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
                (percentageList.length == 0)
                    ? Container(
                        height: 320,
                        decoration: BoxDecoration(
                            color: tertiaryColor,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: Align(
                          alignment: Alignment.center,
                          child: AutoSizeText("No Data",
                              maxLines: 1,
                              style: TextStyle(
                                  fontSize: 30,
                                  color: Colors.white,
                                  fontFamily: 'Nunito',
                                  fontWeight: FontWeight.w400)),
                        ),
                      )
                    : Container(
                        height: 320,
                        decoration: BoxDecoration(
                            color: tertiaryColor,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: PieChart(
                            values: percentageList,
                            labels: [
                              "Indoor",
                              "Outdoor",
                              "High-Impact",
                              "Low-Impact",
                            ],
                            labelColor: Colors.transparent,
                            legendTextColor: Colors.white,
                            textScaleFactor: 0.07,
                            curve: Curves.easeInOutExpo,
                            legendPosition: LegendPosition.Bottom,
                            separateFocusedValue: true,
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ),
      );
    }
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
              middle: Text((i == 0 ? "Fitness Tracker" : "Statistics"),
                  style: TextStyle(color: Colors.white, fontFamily: 'Nunito')),
              backgroundColor: secondaryColor,
              leading: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.home_rounded,
                  color: CupertinoColors.white,
                  size: 30,
                ),
              ),
              trailing: GestureDetector(
                onTap: () {
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
                  Icons.refresh,
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
