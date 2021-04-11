import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:DigiHealth/appPrefs.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';

class DigiDietPage extends StatefulWidget {
  DigiDietPage();

  @override
  _DigiDietPageState createState() => _DigiDietPageState();
}

class _DigiDietPageState extends State<DigiDietPage> {
  Icon journalIcon = Icon(Icons.note_rounded, color: Colors.white);
  Icon dietIcon = Icon(Icons.fastfood_outlined, color: Colors.white);
  var _height;
  var _width;

  String mealPlannerDay = "Today";

  List<String> diets = [
    "Intermittent Fasting",
    "Plant-Based Diet",
    "Low-Carb Diet",
    "Paleo Diet",
    "Low-Fat Diet",
    "Mediterranean Diet",
    "DASH Diet",
    "Gluten-Free Diet"
  ];

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    return CupertinoTabScaffold(
        tabBar: CupertinoTabBar(
            backgroundColor: secondaryColor,
            items: [
              BottomNavigationBarItem(icon: journalIcon),
              BottomNavigationBarItem(icon: dietIcon),
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
              middle: Text("DigiDiet " + (i == 0 ? "Journal" : "Meal Planner"),
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

  void updateTabBarController(int i) {
    setState(() {
      journalIcon = (i == 0)
          ? Icon(Icons.note_rounded, color: Colors.white)
          : Icon(Icons.note_outlined, color: Colors.white);
      dietIcon = (i == 1)
          ? Icon(Icons.fastfood_rounded, color: Colors.white)
          : Icon(Icons.fastfood_outlined, color: Colors.white);
    });
  }

  Widget updateViewBasedOnTab(int i) {
    if (i == 0) {
      return Container(child: Text("hi"));
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
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
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
                          } else if (now.day + 1 == date.day) {
                            mealPlannerDay = "Tomorrow";
                          } else {
                            mealPlannerDay =
                                nameOfDayFromWeekday(date.weekday) +
                                    ", " +
                                    nameOfMonthFromMonthNumber(date.month) +
                                    " " +
                                    date.day.toString();
                          }
                        });
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: _height * 0.01,
                ),
                Center(
                    child: Text(mealPlannerDay,
                        style: TextStyle(
                            fontSize: 30,
                            color: Colors.white,
                            fontFamily: 'Nunito',
                            fontWeight: FontWeight.w200))),
              ],
            ),
          ),
        ),
      );
    }
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
