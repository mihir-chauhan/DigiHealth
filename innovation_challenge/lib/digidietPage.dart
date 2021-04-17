import 'package:DigiHealth/digidiet_questionnaire.dart';
import 'package:DigiHealth/provider_widget.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:DigiHealth/appPrefs.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:multi_charts/multi_charts.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class DigiDietPage extends StatefulWidget {
  DigiDietPage();

  @override
  _DigiDietPageState createState() => _DigiDietPageState();
}

class _DigiDietPageState extends State<DigiDietPage> {
  Icon dietIcon = Icon(Icons.fastfood_rounded, color: Colors.white);
  Icon journalIcon = Icon(Icons.analytics_outlined, color: Colors.white);
  var _height;
  var _width;
  final firebaseRTDatabaseRef = FirebaseDatabase.instance;
  String mealPlannerDay = "Today";
  int dayofweek = 0;
  String nameOfDiet = "Loading";
  List<String> breakfastList = [
    "Loading",
    "Loading",
    "Loading",
    "Loading",
    "Loading",
    "Loading",
    "Loading",
    "Loading",
  ];

  List<String> breakfastLinkList = [
    "Loading",
    "Loading",
    "Loading",
    "Loading",
    "Loading",
    "Loading",
    "Loading",
    "Loading",
  ];

  List<String> lunchList = [
    "Loading",
    "Loading",
    "Loading",
    "Loading",
    "Loading",
    "Loading",
    "Loading",
    "Loading",
  ];

  List<String> lunchLinkList = [
    "Loading",
    "Loading",
    "Loading",
    "Loading",
    "Loading",
    "Loading",
    "Loading",
    "Loading",
  ];

  List<String> dinnerList = [
    "Loading",
    "Loading",
    "Loading",
    "Loading",
    "Loading",
    "Loading",
    "Loading",
    "Loading",
  ];

  List<String> dinnerLinkList = [
    "Loading",
    "Loading",
    "Loading",
    "Loading",
    "Loading",
    "Loading",
    "Loading",
    "Loading",
  ];

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
              heroTag: "digidietPage",
              middle: Text("DigiDiet " + (i == 0 ? "Meal Planner" : "Stats"),
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
            child: updateViewBasedOnTab(i, context),
          );
        });
  }

  void updateMealPlanBasedOnDiet() async {
    final FirebaseUser user =
        await Provider.of(context).auth.firebaseAuth.currentUser();
    final ref = firebaseRTDatabaseRef.reference();
    Firestore.instance
        .collection('User Data')
        .document(user.email)
        .get()
        .then<dynamic>((DocumentSnapshot snapshot) {
      setState(() {
        nameOfDiet = snapshot.data["Diet Plan"];
      });

      ref
          .child("Diets")
          .child(nameOfDiet)
          .child("breakfast")
          .once()
          .then((snapshot) {
        setState(() {
          breakfastList = List<String>.from(snapshot.value as List<dynamic>);
        });
      });

      ref
          .child("Diets")
          .child(nameOfDiet)
          .child("breakfastLink")
          .once()
          .then((snapshot) {
        setState(() {
          breakfastLinkList =
              List<String>.from(snapshot.value as List<dynamic>);
        });
      });

      ref
          .child("Diets")
          .child(nameOfDiet)
          .child("lunch")
          .once()
          .then((snapshot) {
        setState(() {
          lunchList = List<String>.from(snapshot.value as List<dynamic>);
        });
      });

      ref
          .child("Diets")
          .child(nameOfDiet)
          .child("lunchLink")
          .once()
          .then((snapshot) {
        setState(() {
          lunchLinkList = List<String>.from(snapshot.value as List<dynamic>);
        });
      });

      ref
          .child("Diets")
          .child(nameOfDiet)
          .child("dinner")
          .once()
          .then((snapshot) {
        setState(() {
          dinnerList = List<String>.from(snapshot.value as List<dynamic>);
        });
      });

      ref
          .child("Diets")
          .child(nameOfDiet)
          .child("dinnerLink")
          .once()
          .then((snapshot) {
        setState(() {
          dinnerLinkList = List<String>.from(snapshot.value as List<dynamic>);
        });
      });
    });
  }

  void updateTabBarController(int i) {
    setState(() {
      dietIcon = (i == 0)
          ? Icon(Icons.fastfood_rounded, color: Colors.white)
          : Icon(Icons.fastfood_outlined, color: Colors.white);
      journalIcon = (i == 1)
          ? Icon(Icons.analytics_rounded, color: Colors.white)
          : Icon(Icons.analytics_outlined, color: Colors.white);
    });
  }

  bool hasShownQuestionnaire = false;

  bool hasupdatedmeal = false;

  Widget updateViewBasedOnTab(int i, context) {
    if (Provider.of(context).auth.showDigiDietQuestionnaire) {
      openQuestionnaire();
    }
    if (!hasupdatedmeal) {
      hasupdatedmeal = true;
      updateMealPlanBasedOnDiet();
    }

    if (i == 0) {
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
                DatePicker(
                  DateTime.now(),
                  initialSelectedDate: DateTime.now(),
                  selectionColor: tertiaryColor,
                  selectedTextColor: Colors.white,
                  daysCount: 8,
                  onDateChange: (date) {
                    setState(() {
                      var now = DateTime.now();
                      if (now.day == date.day) {
                        mealPlannerDay = "Today";
                        dayofweek = 0;
                      } else if (now.day + 1 == date.day) {
                        mealPlannerDay = "Tomorrow";
                        dayofweek = 1;
                      } else {
                        dayofweek = date.day - now.day;
                        mealPlannerDay = nameOfDayFromWeekday(date.weekday) +
                            ", " +
                            nameOfMonthFromMonthNumber(date.month) +
                            " " +
                            date.day.toString();
                      }
                    });
                  },
                ),
                SizedBox(
                  height: _height * 0.01,
                ),
                Container(
                  width: _width,
                  height: _height * 0.0025,
                  color: secondaryColor,
                ),
                Center(
                    child: Text(mealPlannerDay,
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
                      child: Text("Breakfast",
                          style: TextStyle(
                              fontSize: 30,
                              color: Colors.white,
                              fontFamily: 'Nunito',
                              fontWeight: FontWeight.w400))),
                ),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: AutoSizeText(breakfastList[dayofweek],
                          maxLines: 2,
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontFamily: 'Nunito',
                              fontWeight: FontWeight.w200)),
                    ),
                  ),
                ),
                Wrap(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 32.0, top: 8),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: CupertinoButton(
                          padding: EdgeInsets.all(8.0),
                            color: Colors.orange,
                            child: Text('Show Recipe',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Nunito',
                                    fontSize: 17.0,
                                    fontWeight: FontWeight.bold)),
                            onPressed: () async {
                              _launchURL(breakfastLinkList[dayofweek]);
                            },
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, top: 10.0),
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Lunch",
                          style: TextStyle(
                              fontSize: 30,
                              color: Colors.white,
                              fontFamily: 'Nunito',
                              fontWeight: FontWeight.w400))),
                ),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: AutoSizeText(lunchList[dayofweek],
                          maxLines: 2,
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontFamily: 'Nunito',
                              fontWeight: FontWeight.w200)),
                    ),
                  ),
                ),
                Wrap(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 32.0, top: 8),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: CupertinoButton(
                            padding: EdgeInsets.all(8.0),
                            color: Colors.orange,
                            child: Text('Show Recipe',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Nunito',
                                    fontSize: 17.0,
                                    fontWeight: FontWeight.bold)),
                            onPressed: () async {
                              _launchURL(lunchLinkList[dayofweek]);
                            }
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, top: 10.0),
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Dinner",
                          style: TextStyle(
                              fontSize: 30,
                              color: Colors.white,
                              fontFamily: 'Nunito',
                              fontWeight: FontWeight.w400))),
                ),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: AutoSizeText(dinnerList[dayofweek],
                          maxLines: 2,
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontFamily: 'Nunito',
                              fontWeight: FontWeight.w200)),
                    ),
                  ),
                ),
                Wrap(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 32.0, top: 8),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: CupertinoButton(
                            padding: EdgeInsets.all(8.0),
                            color: Colors.orange,
                            child: Text('Show Recipe',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Nunito',
                                    fontSize: 17.0,
                                    fontWeight: FontWeight.bold)),
                            onPressed: () async {
                              _launchURL(dinnerLinkList[dayofweek]);
                            }
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
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
                    child: Text("Your Diet Stats",
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
                      child: Text("Diet Option",
                          style: TextStyle(
                              fontSize: 30,
                              color: Colors.white,
                              fontFamily: 'Nunito',
                              fontWeight: FontWeight.w400))),
                ),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(nameOfDiet,
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontFamily: 'Nunito',
                              fontWeight: FontWeight.w200)),
                    ),
                  ),
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
                      textScaleFactor: 0.06,
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

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void openQuestionnaire() async {
    await Future.delayed(Duration(milliseconds: 1000), () {
      if (!hasShownQuestionnaire) {
        Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (context) => DigiDietQuestionnairePage()));
        hasShownQuestionnaire = true;
        Provider.of(context).auth.showDigiDietQuestionnaire = false;
      }
    });
  }

  String nameOfDayFromWeekday(int weekday) {
    return (weekday == 0
        ? "Sunday"
        : weekday == 1
            ? "Monday"
            : weekday == 2
                ? "Tuesday"
                : weekday == 3
                    ? "Wednesday"
                    : weekday == 4
                        ? "Thursday"
                        : weekday == 5
                            ? "Friday"
                            : "Saturday");
  }

  String nameOfMonthFromMonthNumber(int month) {
    month--;
    return (month == 0
        ? "January"
        : month == 1
            ? "February"
            : month == 2
                ? "March"
                : month == 3
                    ? "April"
                    : month == 4
                        ? "May"
                        : month == 5
                            ? "June"
                            : month == 6
                                ? "July"
                                : month == 7
                                    ? "August"
                                    : month == 8
                                        ? "Sept."
                                        : month == 9
                                            ? "October"
                                            : month == 10
                                                ? "November"
                                                : "December");
  }
}
