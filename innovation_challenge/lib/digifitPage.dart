import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:DigiHealth/appPrefs.dart';
import 'package:category_picker/category_picker.dart';
import 'package:category_picker/category_picker_item.dart';
import 'package:multi_charts/multi_charts.dart';

class DigiFitPage extends StatefulWidget {
  DigiFitPage();

  @override
  _DigiFitPageState createState() => _DigiFitPageState();
}

class _DigiFitPageState extends State<DigiFitPage> {
  String title = 'Treadmill';
  Icon dietIcon = Icon(Icons.whatshot_outlined, color: Colors.white);
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
                  if (value.value == 'Indoor') {
                    title = 'Treadmill';
                  } else if (value.value == 'Outdoor') {
                    title = 'Running';
                  } else if (value.value == 'High-Impact') {
                    title = 'Biking';
                  } else if (value.value == 'Low-Impact') {
                    title = 'Walking';
                  }
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
              title,
              style: TextStyle(
                  color: Colors.white, fontFamily: 'Nunito', fontSize: 60),
            ),
            SizedBox(
              height: 25,
            ),
            CupertinoButton(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.75,
                height: MediaQuery.of(context).size.width * 0.75,
                decoration: new BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.play_arrow,
                  color: Colors.green,
                  size: MediaQuery.of(context).size.width * 0.75,
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(builder: (context) => SecondRoute(title)),
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
                      child: AutoSizeText("Consumption per Food Group",
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
                    child: RadarChart(
                      values: [5, 10, 3, 5, 6, 9],
                      labels: [
                        "Protein",
                        "Carbs",
                        "Dairy",
                        "Fruits",
                        "Veggies",
                        "Grains",
                      ],
                      maxValue: 10,
                      fillColor: Colors.blue,
                      strokeColor: Colors.white,
                      labelColor: Colors.white,
                      textScaleFactor: 0.07,
                      curve: Curves.easeInOutExpo,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, top: 10.0),
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: AutoSizeText("Average Calories per Meal",
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
                      values: [34.76, 32.21, 33.03],
                      labels: [
                        "Breakfast",
                        "Lunch",
                        "Dinner",
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
                            "Daily Average Total Calories: 1952.534",
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
              middle: Text("DigiFit " + (i == 0 ? "Workout" : "Stats"),
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
    }
  }

  void popupInSeconds() async {
    await Future.delayed(Duration(seconds: 1), () {
      if (isRunningStopWatch == true) {
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
                      });
                    },
            ),
          ),
        ],
      ),
    );
  }
}
