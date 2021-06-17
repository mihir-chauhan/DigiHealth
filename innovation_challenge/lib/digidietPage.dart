import 'package:DigiHealth/provider_widget.dart';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:DigiHealth/appPrefs.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:health_kit/health_kit.dart';
import 'package:keyboard_actions/external/platform_check/platform_check.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:lists/lists.dart';
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
  DateTime timeOfCreation;
  int differenceInIndex;
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
  final FocusNode _nodeText1 = FocusNode();
  final FocusNode _nodeText2 = FocusNode();

  Future<bool> readPermissionsForHealthKit() async {
    try {
      final responses = await HealthKit.hasPermissions(
          [DataType.HEIGHT, DataType.WEIGHT]); //, DataType.HEART_RATE]);

      if (!responses) {
        final value = await HealthKit.requestPermissions(
            [DataType.HEIGHT, DataType.WEIGHT]); //, DataType.HEART_RATE]);

        return value;
      } else {
        return true;
      }
    } on UnsupportedException catch (e) {
      // thrown in case e.dataType is unsupported
      print("Error: DigiFit: readPermissionsForHealthKit $e");
      return false;
    }
  }

  Future<SparseList<num>> getHealthData(
      DateTime dateFrom, DataType dataType) async {
    var permissionsGiven = await readPermissionsForHealthKit();

    print("Permission Status: $permissionsGiven");
    if (true) {
      var dateTo = DateTime.now();

      print('dateFrom: $dateFrom');
      print('dateTo: $dateTo');
      try {
        var results = await HealthKit.read(
          dataType,
          dateFrom: dateFrom,
          dateTo: dateTo,
        );
        if (results != null) {
          SparseList<num> listOfHealthData = new SparseList();
          for (var result in results) {
            print("Results: $result.value");
            listOfHealthData.add(result.value);
          }
          print('value: ' + listOfHealthData.toString());
          return listOfHealthData;
        }
      } on Exception catch (ex) {
        print('Exception in getYesterdayStep: $ex');
      }
      return new SparseList();
    }
  }

  SparseList heartData;

  writeLatestHealthData() async {
    final User user = Provider.of(context).auth.firebaseAuth.currentUser;
    DateTime lastOpenedDate;
    FirebaseFirestore.instance
        .collection('User Data')
        .doc(user.email)
        .get()
        .then((DocumentSnapshot snapshot) {
      lastOpenedDate = snapshot["Previous Use Date for DigiDiet"].toDate();
      print("Got latest date: " +
          snapshot["Previous Use Date for DigiDiet"].toDate().toString());
    }).then((value) async {
      print("Restore? " +
          DateTime.now().difference(lastOpenedDate).inDays.toString());
      if (DateTime.now().difference(lastOpenedDate).inDays > 14) {
        print("Not restoring data");
      } else if (DateTime.now().difference(lastOpenedDate).inDays == 0) {
        print("Updating today's data");
        SparseList heightData = await getHealthData(
            DateTime(
                DateTime.now().year, DateTime.now().month, DateTime.now().day),
            DataType.HEIGHT);
        print("Got height Data: " + heightData.toString());

        SparseList weightData = await getHealthData(
            DateTime(
                DateTime.now().year, DateTime.now().month, DateTime.now().day),
            DataType.WEIGHT);
        print("Got weight Data: " + weightData.toString());
        num height = 0;
        num weight = 0;
        if (heightData.length > 0) {
          height = heightData.elementAt(0);
          print("-- Date: " +
              DateTime(DateTime.now().year, DateTime.now().month,
                      DateTime.now().day)
                  .toString() +
              ", Steps: $height");
          FirebaseFirestore.instance
              .collection('User Data')
              .doc(user.email)
              .collection('Health Logs')
              .doc(DateTime(DateTime.now().year, DateTime.now().month,
                      DateTime.now().day)
                  .toString())
              .set({"height": height, "timeStamp": DateTime.now()},
                  SetOptions(merge: true));
        } else {
          FirebaseFirestore.instance
              .collection('User Data')
              .doc(user.email)
              .collection('Health Logs')
              .doc(DateTime(DateTime.now().year, DateTime.now().month,
                      DateTime.now().day)
                  .toString())
              .set({"height": 0, "timeStamp": DateTime.now()},
                  SetOptions(merge: true));
        }

        if (weightData.length > 0) {
          weight = weightData.elementAt(0);
          print("-- Date: " +
              DateTime(DateTime.now().year, DateTime.now().month,
                      DateTime.now().day)
                  .toString() +
              ", Calories: $weight");
          FirebaseFirestore.instance
              .collection('User Data')
              .doc(user.email)
              .collection('Health Logs')
              .doc(DateTime(DateTime.now().year, DateTime.now().month,
                      DateTime.now().day)
                  .toString())
              .set({"weight": weight, "timeStamp": DateTime.now()},
                  SetOptions(merge: true));
        } else {
          FirebaseFirestore.instance
              .collection('User Data')
              .doc(user.email)
              .collection('Health Logs')
              .doc(DateTime(DateTime.now().year, DateTime.now().month,
                      DateTime.now().day)
                  .toString())
              .set({"weight": 0, "timeStamp": DateTime.now()},
                  SetOptions(merge: true));
        }

        FirebaseFirestore.instance.collection('User Data').doc(user.email).set(
            {"Previous Use Date for DigiDiet": DateTime.now()},
            SetOptions(merge: true));
      } else {
        print("Writing data until today");
        SparseList heightData =
            await getHealthData(lastOpenedDate, DataType.HEIGHT);
        print("Got step Data: " + heightData.toString());

        SparseList weightData =
            await getHealthData(lastOpenedDate, DataType.WEIGHT);
        print("Got calorie Data: " + weightData.toString());

        // heartData = await getHealthData(lastOpenedDate, DataType.HEART_RATE);
        // print("Got heart Data: " + heartData.toString());

        if (heightData.length > 0) {
          for (int i = 0; i < heightData.length; i++) {
            print("i $i");
            DateTime newDate = lastOpenedDate.add(Duration(days: i));
            num height = heightData.elementAt(i);
            print("$i -- Date: " +
                newDate.toString() +
                ", month: " +
                nameOfMonthFromMonthNumber(newDate.month) +
                ", Steps: $height");
            FirebaseFirestore.instance
                .collection('User Data')
                .doc(user.email)
                .collection('Health Logs')
                .doc(DateTime(newDate.year, newDate.month, newDate.day)
                    .toString())
                .set({"height": height, "timeStamp": newDate},
                    SetOptions(merge: true));

            if (weightData.length <= i + 1 && heightData.length <= i + 1) {
              FirebaseFirestore.instance
                  .collection('User Data')
                  .doc(user.email)
                  .collection('Health Logs')
                  .doc(DateTime(newDate.year, newDate.month, newDate.day)
                      .toString())
                  .set({"weight": 0, "height": 0}, SetOptions(merge: true));
            }
          }
        }

        if (weightData.length > 0) {
          for (int i = 0;
              i < (DateTime.now().difference(lastOpenedDate).inDays + 1);
              i++) {
            DateTime newDate = lastOpenedDate.add(Duration(days: i));
            num weight = weightData.elementAt(i);
            print("$i -- Date: " +
                newDate.toString() +
                ", month: " +
                nameOfMonthFromMonthNumber(newDate.month) +
                ", Steps: $weight");
            FirebaseFirestore.instance
                .collection('User Data')
                .doc(user.email)
                .collection('Health Logs')
                .doc(DateTime(newDate.year, newDate.month, newDate.day)
                    .toString())
                .set({"weight": weight, "timeStamp": newDate},
                    SetOptions(merge: true));
            if (heightData.length <= i + 1) {
              FirebaseFirestore.instance
                  .collection('User Data')
                  .doc(user.email)
                  .collection('Health Logs')
                  .doc(DateTime(newDate.year, newDate.month, newDate.day)
                      .toString())
                  .set({"height": 0}, SetOptions(merge: true));
            }
          }
        }

        FirebaseFirestore.instance.collection('User Data').doc(user.email).set(
            {"Previous Use Date for DigiDiet": DateTime.now()},
            SetOptions(merge: true));
      }

      // Calling again to update today's data because when time is over 1 day, it doesn't update.

      print("Updating today's data");
      SparseList heightData = await getHealthData(
          DateTime(
              DateTime.now().year, DateTime.now().month, DateTime.now().day),
          DataType.HEIGHT);
      print("Got step Data: " + heightData.toString());

      SparseList weightData = await getHealthData(
          DateTime(
              DateTime.now().year, DateTime.now().month, DateTime.now().day),
          DataType.WEIGHT);
      print("Got calorie Data: " + weightData.toString());
      num height = 0;
      num weight = 0;
      if (heightData.length > 0 && weightData.length > 0) {
        height = heightData.elementAt(0);
        print("-- Date: " +
            DateTime(DateTime.now().year, DateTime.now().month,
                    DateTime.now().day)
                .toString() +
            ", Steps: $height");
        FirebaseFirestore.instance
            .collection('User Data')
            .doc(user.email)
            .collection('Health Logs')
            .doc(DateTime(DateTime.now().year, DateTime.now().month,
                    DateTime.now().day)
                .toString())
            .set({"height": height, "timeStamp": DateTime.now()},
                SetOptions(merge: true));
      } else {
        FirebaseFirestore.instance
            .collection('User Data')
            .doc(user.email)
            .collection('Health Logs')
            .doc(DateTime(DateTime.now().year, DateTime.now().month,
                    DateTime.now().day)
                .toString())
            .set({"height": 0, "timeStamp": DateTime.now()},
                SetOptions(merge: true));
      }

      if (weightData.length > 0) {
        weight = weightData.elementAt(0);
        print("-- Date: " +
            DateTime(DateTime.now().year, DateTime.now().month,
                    DateTime.now().day)
                .toString() +
            ", Calories: $weight");
        FirebaseFirestore.instance
            .collection('User Data')
            .doc(user.email)
            .collection('Health Logs')
            .doc(DateTime(DateTime.now().year, DateTime.now().month,
                    DateTime.now().day)
                .toString())
            .set({"weight": weight, "timeStamp": DateTime.now()},
                SetOptions(merge: true));
      } else {
        FirebaseFirestore.instance
            .collection('User Data')
            .doc(user.email)
            .collection('Health Logs')
            .doc(DateTime(DateTime.now().year, DateTime.now().month,
                    DateTime.now().day)
                .toString())
            .set({"weight": 0, "timeStamp": DateTime.now()},
                SetOptions(merge: true));
      }

      FirebaseFirestore.instance.collection('User Data').doc(user.email).set(
          {"Previous Use Date for DigiDiet": DateTime.now()},
          SetOptions(merge: true));
    }).then((value) {
      // Graph Population
      FirebaseFirestore.instance
          .collection('User Data')
          .doc(user.email)
          .get()
          .then((value) {
        FirebaseFirestore.instance
            .collection('User Data')
            .doc(user.email)
            .collection('Health Logs')
            .orderBy("timeStamp", descending: false)
            .get()
            .then((QuerySnapshot querySnapshot) {
          querySnapshot.docs.forEach((doc) {
            print("Reading Graph Data " + (doc.id.toString()));
            DateTime dateTime = doc["timeStamp"].toDate();
            weight = (doc['weight'] * 2.20462);
            bmi = (((doc["weight"] / ((doc["height"]) * doc["height"])) * 100)
                    .round() /
                100);
            lbm = (((((0.407 * ((doc["weight"] * 2.20462) * 0.4536)) +
                            (0.267 * ((doc["height"] * 39.3701) * 2.54)) -
                            19.2) *
                        100)
                    .round()) /
                100);
            fatConcentration =
                (100 - ((((weight - lbm) / weight) * 1000).round()) / 10);
            print(
                'WEIGHT: $weight BMI: $bmi LBM: $lbm FAT CONCENTRATION: $fatConcentration');
            if (dateTime.month == DateTime.now().month) {
              setState(() {
                bmiMonth
                    .add(new FlSpot((dateTime.day / 1.0 - 1), (bmi / 75) * 9));
              });
              setState(() {
                weightMonth.add(
                    new FlSpot((dateTime.day / 1.0 - 1), (weight / 450) * 9));
              });
              setState(() {
                lbmMonth
                    .add(new FlSpot((dateTime.day / 1.0 - 1), (lbm / 135) * 9));
              });
              setState(() {
                fatMonth.add(new FlSpot(
                    (dateTime.day / 1.0 - 1), (fatConcentration / 500) * 9));
              });
            }
          });
        });
      });
    });
  }

  KeyboardActionsConfig _buildConfig(BuildContext context) {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      keyboardBarColor: Colors.grey[200],
      nextFocus: false,
      actions: [
        KeyboardActionsItem(
          focusNode: _nodeText1,
          toolbarButtons: [
            (node) {
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: GestureDetector(
                  onTap: () => node.unfocus(),
                  child: Container(
                    color: primaryColor,
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Done",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              );
            }
          ],
        ),
        KeyboardActionsItem(
          focusNode: _nodeText2,
          toolbarButtons: [
            (node) {
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: GestureDetector(
                  onTap: () => node.unfocus(),
                  child: Container(
                    color: primaryColor,
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Done",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              );
            }
          ],
        ),
      ],
    );
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

  List<FlSpot> bmiMonth = [];
  List<FlSpot> weightMonth = [];
  List<FlSpot> lbmMonth = [];
  List<FlSpot> fatMonth = [];

  void updateMealPlanBasedOnDiet() async {
    final User user = Provider.of(context).auth.firebaseAuth.currentUser;

    final ref = firebaseRTDatabaseRef.reference();
    FirebaseFirestore.instance
        .collection('User Data')
        .doc(user.email)
        .get()
        .then<dynamic>((DocumentSnapshot snapshot) {
      setState(() {
        nameOfDiet = snapshot["Diet Plan"];
        timeOfCreation = user.metadata.creationTime;
        print(timeOfCreation.toString());
      });

      ref
          .child("Diets")
          .child(nameOfDiet)
          .child("breakfast")
          .once()
          .then((snapshot) {
        setState(() {
          differenceInIndex =
              DateTime.now().difference(timeOfCreation).inDays % 30;
          dayofweek = differenceInIndex;
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

  double weight = 0;
  double height = 0;
  double lbm = 100.0, bmi = 22.0, fatConcentration = 60;

  bool hasWrittenLatestFitnessData = false;

  Widget updateViewBasedOnTab(int i, context) {
    if (!hasWrittenLatestFitnessData) {
      writeLatestHealthData();
      hasWrittenLatestFitnessData = true;
    }
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
                      displayingOne() {
                        int numberOfDays = 30;
                        if (nameOfMonthFromMonthNumber(date.month) ==
                                'January' ||
                            nameOfMonthFromMonthNumber(date.month) == 'March' ||
                            nameOfMonthFromMonthNumber(date.month) == 'May' ||
                            nameOfMonthFromMonthNumber(date.month) == 'July' ||
                            nameOfMonthFromMonthNumber(
                                    date.month) ==
                                'August' ||
                            nameOfMonthFromMonthNumber(date.month) ==
                                'October' ||
                            nameOfMonthFromMonthNumber(date.month) ==
                                'December') {
                          numberOfDays = 31;
                        } else if (nameOfMonthFromMonthNumber(date.month) ==
                            'February') {
                          numberOfDays = 28;
                          if (date.year % 4 == 0) {
                            numberOfDays = 29;
                          }
                        }
                        int plusDay = numberOfDays - now.day;
                        dayofweek = date.day + plusDay;
                        mealPlannerDay = nameOfDayFromWeekday(date.weekday) +
                            ", " +
                            nameOfMonthFromMonthNumber(date.month) +
                            " " +
                            date.day.toString();
                      }

                      if (now.day == date.day) {
                        mealPlannerDay = "Today";
                        dayofweek = differenceInIndex % 30;
                      } else if (now.day + 1 == date.day) {
                        mealPlannerDay = "Tomorrow";
                        dayofweek = (differenceInIndex + 1) % 30;
                      } else if (now.day < date.day) {
                        dayofweek =
                            (differenceInIndex + (date.day - now.day)) % 30;
                        mealPlannerDay = nameOfDayFromWeekday(date.weekday) +
                            ", " +
                            nameOfMonthFromMonthNumber(date.month) +
                            " " +
                            date.day.toString();
                      } else {
                        displayingOne();
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
                            if (PlatformCheck.isAndroid) {
                              _launchURL(breakfastLinkList[dayofweek]);
                            } else {
                              if (await AppTrackingTransparency
                                          .trackingAuthorizationStatus ==
                                      TrackingStatus.notDetermined ||
                                  await AppTrackingTransparency
                                          .trackingAuthorizationStatus ==
                                      TrackingStatus.denied) {
                                await AppTrackingTransparency
                                    .requestTrackingAuthorization();
                                final uuid = await AppTrackingTransparency
                                    .getAdvertisingIdentifier();
                                if (!uuid.toString().contains(
                                    "00000000-0000-0000-0000-000000000000")) {
                                  _launchURL(breakfastLinkList[dayofweek]);
                                }
                              } else {
                                _launchURL(breakfastLinkList[dayofweek]);
                              }
                            }
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
        body: KeyboardActions(
          config: _buildConfig(context),
          child: SingleChildScrollView(
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
                        child: AutoSizeText("Your BMI Stats",
                            maxLines: 1,
                            style: TextStyle(
                                fontSize: 30,
                                color: Colors.white,
                                fontFamily: 'Nunito',
                                fontWeight: FontWeight.w400))),
                  ),
                  SizedBox(height: _height * 0.01),
                  Stack(
                    children: <Widget>[
                      AspectRatio(
                        aspectRatio: 1.70,
                        child: Container(
                          decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(18),
                              ),
                              color: Color(0xff232d37)),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                right: 18.0, left: 12.0, top: 24, bottom: 12),
                            child: LineChart(
                              bmiMonthData(bmiMonth),
                              // showMonthlyData
                              //     ? stepMonthData(stepMonth)
                              //     : stepYearData(stepYear),
                              swapAnimationDuration:
                                  Duration(milliseconds: 750), // Optional
                              swapAnimationCurve: Curves.linear,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 60,
                        height: 34,
                        child: TextButton(
                          onPressed: () {
                            setState(() {
                              // showMonthlyData = !showMonthlyData;
                            });
                          },
                          child: Text(
                            // showMonthlyData ? 'Month' : 'Year',
                            "Month",
                            style: TextStyle(fontSize: 12, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: _height * 0.01),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, top: 10.0),
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: AutoSizeText("Your Weight Stats",
                            maxLines: 1,
                            style: TextStyle(
                                fontSize: 30,
                                color: Colors.white,
                                fontFamily: 'Nunito',
                                fontWeight: FontWeight.w400))),
                  ),
                  SizedBox(height: _height * 0.01),
                  Stack(
                    children: <Widget>[
                      AspectRatio(
                        aspectRatio: 1.70,
                        child: Container(
                          decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(18),
                              ),
                              color: Color(0xff232d37)),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                right: 18.0, left: 12.0, top: 24, bottom: 12),
                            child: LineChart(
                              weightMonthData(weightMonth),
                              // showMonthlyData
                              //     ? stepMonthData(stepMonth)
                              //     : stepYearData(stepYear),
                              swapAnimationDuration:
                                  Duration(milliseconds: 750), // Optional
                              swapAnimationCurve: Curves.linear,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 60,
                        height: 34,
                        child: TextButton(
                          onPressed: () {
                            setState(() {
                              // showMonthlyData = !showMonthlyData;
                            });
                          },
                          child: Text(
                            // showMonthlyData ? 'Month' : 'Year',
                            "Month",
                            style: TextStyle(fontSize: 12, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: _height * 0.01),
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
                  SizedBox(height: _height * 0.01),
                  Stack(
                    children: <Widget>[
                      AspectRatio(
                        aspectRatio: 1.70,
                        child: Container(
                          decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(18),
                              ),
                              color: Color(0xff232d37)),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                right: 18.0, left: 12.0, top: 24, bottom: 12),
                            child: LineChart(
                              lbmMonthData(lbmMonth),
                              // showMonthlyData
                              //     ? stepMonthData(stepMonth)
                              //     : stepYearData(stepYear),
                              swapAnimationDuration:
                                  Duration(milliseconds: 750), // Optional
                              swapAnimationCurve: Curves.linear,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 60,
                        height: 34,
                        child: TextButton(
                          onPressed: () {
                            setState(() {
                              // showMonthlyData = !showMonthlyData;
                            });
                          },
                          child: Text(
                            // showMonthlyData ? 'Month' : 'Year',
                            "Month",
                            style: TextStyle(fontSize: 12, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: _height * 0.01),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, top: 10.0),
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: AutoSizeText("Your Fat Percentage Stats",
                            maxLines: 1,
                            style: TextStyle(
                                fontSize: 30,
                                color: Colors.white,
                                fontFamily: 'Nunito',
                                fontWeight: FontWeight.w400))),
                  ),
                  SizedBox(height: _height * 0.01),
                  Stack(
                    children: <Widget>[
                      AspectRatio(
                        aspectRatio: 1.70,
                        child: Container(
                          decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(18),
                              ),
                              color: Color(0xff232d37)),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                right: 18.0, left: 12.0, top: 24, bottom: 12),
                            child: LineChart(
                              fatMonthData(fatMonth),
                              // showMonthlyData
                              //     ? stepMonthData(stepMonth)
                              //     : stepYearData(stepYear),
                              swapAnimationDuration:
                                  Duration(milliseconds: 750), // Optional
                              swapAnimationCurve: Curves.linear,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 60,
                        height: 34,
                        child: TextButton(
                          onPressed: () {
                            setState(() {
                              // showMonthlyData = !showMonthlyData;
                            });
                          },
                          child: Text(
                            // showMonthlyData ? 'Month' : 'Year',
                            "Month",
                            style: TextStyle(fontSize: 12, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: _height * 0.01),
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
        ),
      );
    }
  }

  _launchURL(String url) async {
    Navigator.push(
      context,
      CupertinoPageRoute(builder: (context) => RecipeWebViewPage(url)),
    );
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

LineChartData bmiMonthData(List<FlSpot> spots) {
  return LineChartData(
    lineTouchData: LineTouchData(enabled: false),
    gridData: FlGridData(
      show: true,
      drawHorizontalLine: true,
      getDrawingVerticalLine: (value) {
        return FlLine(
          color: const Color(0xff37434d),
          strokeWidth: 1,
        );
      },
      getDrawingHorizontalLine: (value) {
        return FlLine(
          color: const Color(0xff37434d),
          strokeWidth: 1,
        );
      },
    ),
    titlesData: FlTitlesData(
      show: true,
      bottomTitles: SideTitles(
        showTitles: true,
        reservedSize: 22,
        getTextStyles: (value) => const TextStyle(
            color: Color(0xff68737d),
            fontWeight: FontWeight.bold,
            fontSize: 16),
        getTitles: (value) {
          switch (value.toInt()) {
            case 0:
              return '1';
            case 14:
              return '15';
            case 29:
              return '30';
          }
          return '';
        },
        margin: 8,
      ),
      leftTitles: SideTitles(
        showTitles: true,
        getTextStyles: (value) => const TextStyle(
          color: Color(0xff67727d),
          fontWeight: FontWeight.bold,
          fontSize: 15,
        ),
        getTitles: (value) {
          switch (value.toInt()) {
            case 1:
              return '8';
            case 3:
              return '24';
            case 5:
              return '40';
            case 7:
              return '56';
          }
          return '';
        },
        reservedSize: 28,
        margin: 12,
      ),
    ),
    borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d), width: 1)),
    minX: 0,
    maxX: 30,
    minY: 0,
    maxY: 8,
    lineBarsData: [
      LineChartBarData(
        spots: spots,
        isCurved: false,
        colors: [
          ColorTween(begin: gradientColors[0], end: gradientColors[1])
              .lerp(0.2),
          ColorTween(begin: gradientColors[0], end: gradientColors[1])
              .lerp(0.2),
        ],
        barWidth: 5,
        isStrokeCapRound: true,
        dotData: FlDotData(
          show: false,
        ),
        belowBarData: BarAreaData(show: true, colors: [
          ColorTween(begin: gradientColors[0], end: gradientColors[1])
              .lerp(0.2)
              .withOpacity(0.1),
          ColorTween(begin: gradientColors[0], end: gradientColors[1])
              .lerp(0.2)
              .withOpacity(0.1),
        ]),
      ),
    ],
  );
}

LineChartData weightMonthData(List<FlSpot> spots) {
  return LineChartData(
    lineTouchData: LineTouchData(enabled: false),
    gridData: FlGridData(
      show: true,
      drawHorizontalLine: true,
      getDrawingVerticalLine: (value) {
        return FlLine(
          color: const Color(0xff37434d),
          strokeWidth: 1,
        );
      },
      getDrawingHorizontalLine: (value) {
        return FlLine(
          color: const Color(0xff37434d),
          strokeWidth: 1,
        );
      },
    ),
    titlesData: FlTitlesData(
      show: true,
      bottomTitles: SideTitles(
        showTitles: true,
        reservedSize: 22,
        getTextStyles: (value) => const TextStyle(
            color: Color(0xff68737d),
            fontWeight: FontWeight.bold,
            fontSize: 16),
        getTitles: (value) {
          switch (value.toInt()) {
            case 0:
              return '1';
            case 14:
              return '15';
            case 29:
              return '30';
          }
          return '';
        },
        margin: 8,
      ),
      leftTitles: SideTitles(
        showTitles: true,
        getTextStyles: (value) => const TextStyle(
          color: Color(0xff67727d),
          fontWeight: FontWeight.bold,
          fontSize: 15,
        ),
        getTitles: (value) {
          switch (value.toInt()) {
            case 1:
              return '50';
            case 3:
              return '150';
            case 5:
              return '250';
            case 7:
              return '350';
          }
          return '';
        },
        reservedSize: 28,
        margin: 12,
      ),
    ),
    borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d), width: 1)),
    minX: 0,
    maxX: 30,
    minY: 0,
    maxY: 8,
    lineBarsData: [
      LineChartBarData(
        spots: spots,
        isCurved: false,
        colors: [
          ColorTween(begin: gradientColors[0], end: gradientColors[1])
              .lerp(0.2),
          ColorTween(begin: gradientColors[0], end: gradientColors[1])
              .lerp(0.2),
        ],
        barWidth: 5,
        isStrokeCapRound: true,
        dotData: FlDotData(
          show: false,
        ),
        belowBarData: BarAreaData(show: true, colors: [
          ColorTween(begin: gradientColors[0], end: gradientColors[1])
              .lerp(0.2)
              .withOpacity(0.1),
          ColorTween(begin: gradientColors[0], end: gradientColors[1])
              .lerp(0.2)
              .withOpacity(0.1),
        ]),
      ),
    ],
  );
}

LineChartData lbmMonthData(List<FlSpot> spots) {
  return LineChartData(
    lineTouchData: LineTouchData(enabled: false),
    gridData: FlGridData(
      show: true,
      drawHorizontalLine: true,
      getDrawingVerticalLine: (value) {
        return FlLine(
          color: const Color(0xff37434d),
          strokeWidth: 1,
        );
      },
      getDrawingHorizontalLine: (value) {
        return FlLine(
          color: const Color(0xff37434d),
          strokeWidth: 1,
        );
      },
    ),
    titlesData: FlTitlesData(
      show: true,
      bottomTitles: SideTitles(
        showTitles: true,
        reservedSize: 22,
        getTextStyles: (value) => const TextStyle(
            color: Color(0xff68737d),
            fontWeight: FontWeight.bold,
            fontSize: 16),
        getTitles: (value) {
          switch (value.toInt()) {
            case 0:
              return '1';
            case 14:
              return '15';
            case 29:
              return '30';
          }
          return '';
        },
        margin: 8,
      ),
      leftTitles: SideTitles(
        showTitles: true,
        getTextStyles: (value) => const TextStyle(
          color: Color(0xff67727d),
          fontWeight: FontWeight.bold,
          fontSize: 15,
        ),
        getTitles: (value) {
          switch (value.toInt()) {
            case 1:
              return '15';
            case 3:
              return '45';
            case 5:
              return '75';
            case 7:
              return '105';
          }
          return '';
        },
        reservedSize: 28,
        margin: 12,
      ),
    ),
    borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d), width: 1)),
    minX: 0,
    maxX: 30,
    minY: 0,
    maxY: 8,
    lineBarsData: [
      LineChartBarData(
        spots: spots,
        isCurved: false,
        colors: [
          ColorTween(begin: gradientColors[0], end: gradientColors[1])
              .lerp(0.2),
          ColorTween(begin: gradientColors[0], end: gradientColors[1])
              .lerp(0.2),
        ],
        barWidth: 5,
        isStrokeCapRound: true,
        dotData: FlDotData(
          show: false,
        ),
        belowBarData: BarAreaData(show: true, colors: [
          ColorTween(begin: gradientColors[0], end: gradientColors[1])
              .lerp(0.2)
              .withOpacity(0.1),
          ColorTween(begin: gradientColors[0], end: gradientColors[1])
              .lerp(0.2)
              .withOpacity(0.1),
        ]),
      ),
    ],
  );
}

LineChartData fatMonthData(List<FlSpot> spots) {
  return LineChartData(
    lineTouchData: LineTouchData(enabled: false),
    gridData: FlGridData(
      show: true,
      drawHorizontalLine: true,
      getDrawingVerticalLine: (value) {
        return FlLine(
          color: const Color(0xff37434d),
          strokeWidth: 1,
        );
      },
      getDrawingHorizontalLine: (value) {
        return FlLine(
          color: const Color(0xff37434d),
          strokeWidth: 1,
        );
      },
    ),
    titlesData: FlTitlesData(
      show: true,
      bottomTitles: SideTitles(
        showTitles: true,
        reservedSize: 22,
        getTextStyles: (value) => const TextStyle(
            color: Color(0xff68737d),
            fontWeight: FontWeight.bold,
            fontSize: 16),
        getTitles: (value) {
          switch (value.toInt()) {
            case 0:
              return '1';
            case 14:
              return '15';
            case 29:
              return '30';
          }
          return '';
        },
        margin: 8,
      ),
      leftTitles: SideTitles(
        showTitles: true,
        getTextStyles: (value) => const TextStyle(
          color: Color(0xff67727d),
          fontWeight: FontWeight.bold,
          fontSize: 15,
        ),
        getTitles: (value) {
          switch (value.toInt()) {
            case 1:
              return '50';
            case 3:
              return '150';
            case 5:
              return '250';
            case 7:
              return '350';
          }
          return '';
        },
        reservedSize: 28,
        margin: 12,
      ),
    ),
    borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d), width: 1)),
    minX: 0,
    maxX: 30,
    minY: 0,
    maxY: 8,
    lineBarsData: [
      LineChartBarData(
        spots: spots,
        isCurved: false,
        colors: [
          ColorTween(begin: gradientColors[0], end: gradientColors[1])
              .lerp(0.2),
          ColorTween(begin: gradientColors[0], end: gradientColors[1])
              .lerp(0.2),
        ],
        barWidth: 5,
        isStrokeCapRound: true,
        dotData: FlDotData(
          show: false,
        ),
        belowBarData: BarAreaData(show: true, colors: [
          ColorTween(begin: gradientColors[0], end: gradientColors[1])
              .lerp(0.2)
              .withOpacity(0.1),
          ColorTween(begin: gradientColors[0], end: gradientColors[1])
              .lerp(0.2)
              .withOpacity(0.1),
        ]),
      ),
    ],
  );
}
