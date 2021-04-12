import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:DigiHealth/appPrefs.dart';
import 'package:category_picker/category_picker.dart';
import 'package:category_picker/category_picker_item.dart';
import 'digidietPage.dart';

class DigiFitPage extends StatefulWidget {
  DigiFitPage();

  @override
  _DigiFitPageState createState() => _DigiFitPageState();
}

class _DigiFitPageState extends State<DigiFitPage> {
  String title = 'Treadmill';

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: primaryColor,
      navigationBar: CupertinoNavigationBar(
        transitionBetweenRoutes: false,
        heroTag: "digifitPage",
        middle: Text("DigiFit",
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
              color: Colors.blue,
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
