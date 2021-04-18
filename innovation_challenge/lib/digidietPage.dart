import 'package:DigiHealth/digidiet_questionnaire.dart';
import 'package:DigiHealth/provider_widget.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:draw_graph/draw_graph.dart';
import 'package:draw_graph/models/feature.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:DigiHealth/appPrefs.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:multi_charts/multi_charts.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:DigiHealth/recipeWebViewPage.dart';

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
              middle: Text((i == 0 ? "Meal Planner" : "Statistics"),
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
            ),
            child: updateViewBasedOnTab(i, context),
          );
        });
  }

  List<double> bmiList;
  List<double> weightList;
  List<double> lbmList;
  List<double> fatList;

  void updateMealPlanBasedOnDiet() async {
    final FirebaseUser user =
        await Provider.of(context).auth.firebaseAuth.currentUser();

    Firestore.instance.collection('User Data').document(user.email).get().then<dynamic>((DocumentSnapshot snapshot) {
      if(snapshot.data["Diet Questionnaire"] == false) {
        openQuestionnaire();
      } else {
        getData(user);
      }
    });
  }

  void getData(FirebaseUser user) async {
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
    bmiList = new List<double>();
    weightList = new List<double>();
    lbmList = new List<double>();
    fatList = new List<double>();
    Firestore.instance
        .collection('User Data')
        .document(user.email)
        .collection('Health Logs')
        .orderBy('Timestamp', descending: false)
        .getDocuments()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.documents.forEach((doc) {
        bmiList.add(doc['Body Mass Index']/30);
        weightList.add(doc['Weight']/300);
        lbmList.add(doc['Lean Body Mass']/80);
        fatList.add(doc['Fat Concentration']/100);
        setState(() {
          bmi = doc['Body Mass Index'];
          heightController.text = (doc['Height']).toString();
          weightController.text = (doc['Weight']).toString();
          height = (doc['Height']);
          weight = (doc['Weight']);
          bmiHeightfeatures = [
            Feature(
              title: "BMI",
              color: Colors.red,
              data: bmiList,
            ),
            Feature(
              title: "Weight",
              color: Colors.blue,
              data: weightList,
            ),
          ];

          lbmFatFeatures = [
            Feature(
              title: "Lean Body Mass",
              color: Colors.red,
              data: lbmList,
            ),
            Feature(
              title: "Fat Percentage",
              color: Colors.blue,
              data: fatList,
            ),
          ];
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

  double weight = 0;
  double height = 0;
  TextEditingController weightController = new TextEditingController();
  TextEditingController heightController = new TextEditingController();

  double lbm = 100.0, bmi = 22.0, fatConcentration = 60;

  List<Feature> bmiHeightfeatures = [
    Feature(
      title: "BMI",
      color: Colors.red,
      data: [0],
    ),
    Feature(
      title: "Weight",
      color: Colors.blue,
      data: [0],
    ),
  ];

  List<Feature> lbmFatFeatures = [
    Feature(
      title: "Lean Body Mass",
      color: Colors.red,
      data: [0],
    ),
    Feature(
      title: "Fat Percentage",
      color: Colors.blue,
      data: [0],
    ),
  ];

  Widget updateViewBasedOnTab(int i, context) {
    if (breakfastList[0] == "Loading") {
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
                            }),
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
                            }),
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
                    child: Text("Input Your Metrics",
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
                Container(height: _height * 0.01),
                CupertinoTextField(
                  controller: weightController,
                  style: TextStyle(
                      fontSize: 22,
                      color: Colors.black87,
                      fontFamily: 'Nunito',
                      fontWeight: FontWeight.w300),
                  onChanged: (String value) => weight = double.parse(value),
                  placeholder: "Weight (pounds)",
                  placeholderStyle: TextStyle(color: hintColor),
                  cursorColor: Colors.black87,
                  keyboardType: TextInputType.number,
                  decoration: BoxDecoration(
                      color: textColor, borderRadius: BorderRadius.circular(9)),
                ),
                Container(height: _height * 0.01),
                CupertinoTextField(
                  controller: heightController,
                  style: TextStyle(
                      fontSize: 22,
                      color: Colors.black87,
                      fontFamily: 'Nunito',
                      fontWeight: FontWeight.w300),
                  onChanged: (String value) => height = double.parse(value),
                  placeholder: "Height (inches)",
                  placeholderStyle: TextStyle(color: hintColor),
                  cursorColor: Colors.black87,
                  keyboardType: TextInputType.number,
                  decoration: BoxDecoration(
                      color: textColor, borderRadius: BorderRadius.circular(9)),
                ),
                SizedBox(
                  height: _height * 0.01,
                ),
                Wrap(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: CupertinoButton(
                          padding: EdgeInsets.only(
                              left: 20.0, right: 20.0, top: 8.0, bottom: 8.0),
                          color: Colors.orange,
                          child: Text('Enter',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Nunito',
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.bold)),
                          onPressed: () async {
                            setState(() {
                              lbm = ((((0.407 * (weight * 0.4536)) +
                                  (0.267 * (height * 2.54)) -
                                  19.2) *
                                  100)
                                  .round()) /
                                  100;
                              bmi = ((weight / (height * height) * 703 * 100)
                                  .round()) /
                                  100;
                              weightList.add(weight/300);
                              bmiList.add(bmi/30);
                              bmiHeightfeatures = [
                                Feature(
                                  title: "BMI",
                                  color: Colors.red,
                                  data: bmiList,
                                ),
                                Feature(
                                  title: "Weight",
                                  color: Colors.blue,
                                  data: weightList,
                                ),
                              ];

                              fatConcentration = 100 -
                                  ((((weight - lbm) / weight) * 1000).round()) /
                                      10;

                              lbmList.add(lbm/80);
                              fatList.add(fatConcentration/100);
                              lbmFatFeatures = [
                                Feature(
                                  title: "Lean Body Mass",
                                  color: Colors.red,
                                  data: lbmList,
                                ),
                                Feature(
                                  title: "Fat Percentage",
                                  color: Colors.blue,
                                  data: fatList,
                                ),
                              ];
                              heightController.clear();
                              weightController.clear();

                              writeDietDataToFirestoreLog(
                                  lbm, bmi, fatConcentration, weight, height);
                            });

                            showCupertinoDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                    CupertinoAlertDialog(
                                      title: new Text("Your Calculated Metric"),
                                      content: new Text(
                                          "Body Mass Index: $bmi\nLean Body Mass: $lbm\nFat Percentage $fatConcentration%"),
                                      actions: <Widget>[
                                        CupertinoDialogAction(
                                          isDefaultAction: true,
                                          child: Text("Okay"),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        )
                                      ],
                                    ));
                          }),
                    ),
                  ],
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
                      child: AutoSizeText("Your Lean Body Mass Stats",
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
                      features: bmiHeightfeatures,
                      size: Size(320, 300),
                      labelX: ['1', '5', '10', '15', '20'],
                      labelY: ['20%', '40%', '60%', '80%', '100%'],
                      showDescription: true,
                      graphColor: Colors.white60,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, top: 10.0),
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: AutoSizeText("Your Weight and BMI Stats",
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
                      features: lbmFatFeatures,
                      size: Size(320, 300),
                      labelX: ['1', '5', '10', '15', '20'],
                      labelY: ['20%', '40%', '60%', '80%', '100%'],
                      showDescription: true,
                      graphColor: Colors.white60,
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
                        child: AutoSizeText(
                            "Body Mass Index: " + bmi.toString(),
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
    Navigator.push(
      context,
      CupertinoPageRoute(
          builder: (context) => RecipeWebViewPage(url)),
    );
  }

  void writeDietDataToFirestoreLog(double lbm, double bmi,
      double fatConcentration, double weight, double height) async {
    final FirebaseUser user =
        await Provider.of(context).auth.firebaseAuth.currentUser();
    final databaseReference = Firestore.instance;

    await databaseReference
        .collection("User Data")
        .document(user.email)
        .collection("Health Logs")
        .add({
      "Lean Body Mass": lbm,
      "Body Mass Index": bmi,
      "Fat Concentration": fatConcentration,
      "Weight": weight,
      "Height": height,
      "Timestamp": Timestamp.now()
    });
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
