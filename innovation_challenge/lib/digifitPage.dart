import 'package:DigiHealth/provider_widget.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:DigiHealth/appPrefs.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:health_kit/health_kit.dart';
import 'package:horizontal_card_pager/card_item.dart';
import 'package:horizontal_card_pager/horizontal_card_pager.dart';
import 'package:line_icons/line_icons.dart';
import 'package:lists/lists.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:slide_countdown_clock/slide_countdown_clock.dart';

class DigiFitPage extends StatefulWidget {
  DigiFitPage();

  @override
  _DigiFitPageState createState() => _DigiFitPageState();
}

class _DigiFitPageState extends State<DigiFitPage> {
  num total;

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    return CupertinoTabScaffold(
        tabBar: CupertinoTabBar(
            backgroundColor: secondaryColor,
            items: [
              BottomNavigationBarItem(icon: activityIcon),
              BottomNavigationBarItem(icon: statsIcon),
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
              middle: Text((i == 0 ? "Fitness Tracker" : "Challenges"),
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
            child: updateViewBasedOnTab(i),
          );
        });
  }

  Future<bool> readPermissionsForHealthKit() async {
    try {
      final responses = await HealthKit.hasPermissions(
          [DataType.STEP_COUNT, DataType.ENERGY]); //, DataType.HEART_RATE]);

      if (!responses) {
        final value = await HealthKit.requestPermissions(
            [DataType.STEP_COUNT, DataType.ENERGY]); //, DataType.HEART_RATE]);

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

  writeLatestFitnessData() async {
    double totalCaloriesGained = 0.0;
    final User user = Provider.of(context).auth.firebaseAuth.currentUser;
    DateTime lastOpenedDate;
    FirebaseFirestore.instance
        .collection('User Data')
        .doc(user.email)
        .get()
        .then((DocumentSnapshot snapshot) {
      lastOpenedDate = snapshot["Previous Use Date"].toDate();
      print("Got latest date: " +
          snapshot["Previous Use Date"].toDate().toString());
    }).then((value) async {
      print("Restore? " +
          DateTime.now().difference(lastOpenedDate).inDays.toString());
      if (DateTime.now().difference(lastOpenedDate).inDays > 7) {
        print("Not restoring data");
      } else if (DateTime.now().difference(lastOpenedDate).inDays == 0) {
        print("Updating today's data");
        SparseList stepData = await getHealthData(
            DateTime(
                DateTime.now().year, DateTime.now().month, DateTime.now().day),
            DataType.STEP_COUNT);
        print("Got step Data: " + stepData.toString());

        SparseList calorieData = await getHealthData(
            DateTime(
                DateTime.now().year, DateTime.now().month, DateTime.now().day),
            DataType.ENERGY);
        print("Got calorie Data: " + calorieData.toString());

        // SparseList heartData = await getHealthData(
        //     DateTime(
        //         DateTime.now().year, DateTime.now().month, DateTime.now().day),
        //     DataType.HEART_RATE);
        // print("Got heart Data: " + heartData.toString());

        if (stepData.length > 0) {
          num steps = stepData.elementAt(0);
          print("-- Date: " +
              DateTime(DateTime.now().year, DateTime.now().month,
                      DateTime.now().day)
                  .toString() +
              ", Steps: $steps");
          FirebaseFirestore.instance
              .collection('User Data')
              .doc(user.email)
              .collection('DigiFit Data')
              .doc(DateTime(DateTime.now().year, DateTime.now().month,
                      DateTime.now().day)
                  .toString())
              .set({"Steps": steps}, SetOptions(merge: true));
        }

        if (calorieData.length > 0) {
          num calories = calorieData.elementAt(0);
          print("-- Date: " +
              DateTime(DateTime.now().year, DateTime.now().month,
                      DateTime.now().day)
                  .toString() +
              ", Calories: $calories");
          FirebaseFirestore.instance
              .collection('User Data')
              .doc(user.email)
              .collection('DigiFit Data')
              .doc(DateTime(DateTime.now().year, DateTime.now().month,
                      DateTime.now().day)
                  .toString())
              .set({"Calories": calories}, SetOptions(merge: true));
          totalCaloriesGained = calories;
          FirebaseFirestore.instance
              .collection('User Data')
              .doc(user.email)
              .get()
              .then((DocumentSnapshot snapshot) {
            FirebaseFirestore.instance
                .collection('User Data')
                .doc(user.email)
                .set({"Points": snapshot["Points"] + totalCaloriesGained.round()},
                    SetOptions(merge: true));
          });
        }

        FirebaseFirestore.instance.collection('User Data').doc(user.email).set(
            {"Previous Use Date": DateTime.now()}, SetOptions(merge: true));
      } else {
        print("Writing data until today");
        SparseList stepData =
            await getHealthData(lastOpenedDate, DataType.STEP_COUNT);
        print("Got step Data: " + stepData.toString());

        SparseList calorieData =
            await getHealthData(lastOpenedDate, DataType.ENERGY);
        print("Got calorie Data: " + calorieData.toString());

        // heartData = await getHealthData(lastOpenedDate, DataType.HEART_RATE);
        // print("Got heart Data: " + heartData.toString());

        if (stepData.length > 0) {
          for (int i = 0; i < stepData.length; i++) {
            print("i $i");
            DateTime newDate = lastOpenedDate.add(Duration(days: i));
            num steps = stepData.elementAt(i);
            print("$i -- Date: " +
                newDate.toString() +
                ", month: " +
                nameOfMonthFromMonthNumber(newDate.month) +
                ", Steps: $steps");
            FirebaseFirestore.instance
                .collection('User Data')
                .doc(user.email)
                .collection('DigiFit Data')
                .doc(newDate.toString())
                .set({"Steps": steps, "timeStamp": newDate},
                    SetOptions(merge: true));
            if (calorieData.length <= i + 1) {
              FirebaseFirestore.instance
                  .collection('User Data')
                  .doc(user.email)
                  .collection('DigiFit Data')
                  .doc(newDate.toString())
                  .set({"Calories": 0}, SetOptions(merge: true));
            }
          }
        }

        if (calorieData.length > 0) {
          for (int i = 0;
              i < (DateTime.now().difference(lastOpenedDate).inDays + 1);
              i++) {
            DateTime newDate = lastOpenedDate.add(Duration(days: i));
            num calories = calorieData.elementAt(i);
            print("$i -- Date: " +
                newDate.toString() +
                ", month: " +
                nameOfMonthFromMonthNumber(newDate.month) +
                ", Steps: $calories");
            FirebaseFirestore.instance
                .collection('User Data')
                .doc(user.email)
                .collection('DigiFit Data')
                .doc(newDate.toString())
                .set({"Calories": calories, "timeStamp": newDate},
                    SetOptions(merge: true));
            totalCaloriesGained += calories;

            if (stepData.length <= i + 1) {
              FirebaseFirestore.instance
                  .collection('User Data')
                  .doc(user.email)
                  .collection('DigiFit Data')
                  .doc(newDate.toString())
                  .set({"Steps": 0}, SetOptions(merge: true));
            }
          }
        }

        FirebaseFirestore.instance
            .collection('User Data')
            .doc(user.email)
            .get()
            .then((DocumentSnapshot snapshot) {
          FirebaseFirestore.instance
              .collection('User Data')
              .doc(user.email)
              .set({"Points": snapshot["Points"] + totalCaloriesGained.round()},
              SetOptions(merge: true));
        });

        FirebaseFirestore.instance.collection('User Data').doc(user.email).set(
            {"Previous Use Date": DateTime.now()}, SetOptions(merge: true));
      }
    }).then((value) {
      FirebaseFirestore.instance
          .collection('User Data')
          .doc(user.email)
          .get()
          .then<dynamic>((DocumentSnapshot snapshot) {
        setState(() {
          stepGoal = snapshot["Step Goal"] + 0.0;
          calorieGoal = snapshot["Calorie Goal"] + 0.0;
        });
      }).then((value) {
        FirebaseFirestore.instance
            .collection('User Data')
            .doc(user.email)
            .collection('DigiFit Data')
            .orderBy("timeStamp", descending: false)
            .get()
            .then((QuerySnapshot querySnapshot) {
          querySnapshot.docs.forEach((doc) {
            print("Reading Graph Data " + (doc.id.toString()));
            DateTime dateTime = doc["timeStamp"].toDate();

            if (dateTime.year == DateTime.now().year &&
                dateTime.month == DateTime.now().month &&
                dateTime.day == DateTime.now().day) {
              setState(() {
                todaySteps = doc["Steps"] + 0.0;
                todayCalories = doc["Calories"] + 0.0;
              });
            }

            if (dateTime.month == DateTime.now().month) {
              setState(() {
                stepMonth.add(new FlSpot(
                    (dateTime.day / 1.0), (doc["Steps"] / 18000.0) * 9.0));
              });
              setState(() {
                calorieMonth.add(new FlSpot(
                    (dateTime.day / 1.0),
                    (((2 * (doc["Calories"] / 3750.0) * 5.0)) - 1.0) >= 0
                        ? (((2 * (doc["Calories"] / 3750.0) * 5.0)) - 1.0)
                        : 0));
              });
            }
          });
        });
      });
    });
  }

  Icon activityIcon = Icon(Icons.whatshot_rounded, color: Colors.white);
  Icon statsIcon = Icon(Icons.emoji_events_outlined, color: Colors.white);
  var _height;
  var _width;

  void updateTabBarController(int i) {
    setState(() {
      activityIcon = (i == 0)
          ? Icon(Icons.whatshot_rounded, color: Colors.white)
          : Icon(Icons.whatshot_outlined, color: Colors.white);
      statsIcon = (i == 1)
          ? Icon(Icons.emoji_events_sharp, color: Colors.white)
          : Icon(Icons.emoji_events_outlined, color: Colors.white);
    });
  }

  bool showMonthlyData = true;
  int currentDataPage = 1;
  Duration time = DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day + 7)
      .difference(DateTime.now());
  bool hasWrittenLatestFitnessData = false;

  List<FlSpot> stepYear = [];

  List<FlSpot> stepMonth = [];

  List<FlSpot> calorieYear = [];

  List<FlSpot> calorieMonth = [];

  List<FlSpot> heartDay = [];

  double todaySteps = 0;
  double stepGoal = 1;
  double todayCalories = 0;
  double calorieGoal = 1;

  List<Widget> challengeCards = [];

  Widget updateViewBasedOnTab(int i) {
    if (!hasWrittenLatestFitnessData) {
      writeLatestFitnessData();
      final User user = Provider.of(context).auth.firebaseAuth.currentUser;
      FirebaseFirestore.instance
          .collection('DigiFit Challenges')
          .orderBy("endDate", descending: false)
          .get()
          .then((QuerySnapshot snapshot) {
        DateTime upcomingChallengeExpiryDate;
        int i = 0;
        snapshot.docs.forEach((doc) {
          DateTime expiryOfChallenge = doc["endDate"].toDate();
          if (i == 0) {
            upcomingChallengeExpiryDate = expiryOfChallenge;
            time = upcomingChallengeExpiryDate.difference(DateTime.now());
            i++;
          }
          if (expiryOfChallenge.isAtSameMomentAs(upcomingChallengeExpiryDate)) {
            try {
              FirebaseFirestore.instance
                  .collection('DigiFit Challenges')
                  .doc(doc.id.toString())
                  .collection("Participants")
                  .get()
                  .then((QuerySnapshot snapshot) {
                for (int x = 0; x < snapshot.docs.length; i++) {
                  print("here:111");
                  if (snapshot.docs
                      .elementAt(x)
                      .id
                      .toString()
                      .contains(user.email)) {
                    challengeCards.add(buildChallengeCard(
                        challengeName: doc.id.toString(),
                        imageSource: doc['image'],
                        difficulty: doc['complexity'],
                        goal: doc['goal'],
                        finishDate: upcomingChallengeExpiryDate,
                        points: doc['pointsForCompletion'],
                        isParticipating: true));
                    challengeCards.add(SizedBox(height: _height * 0.0125));
                    break;
                  } else {
                    challengeCards.add(buildChallengeCard(
                        challengeName: doc.id.toString(),
                        imageSource: doc['image'],
                        difficulty: doc['complexity'],
                        goal: doc['goal'],
                        finishDate: upcomingChallengeExpiryDate,
                        points: doc['pointsForCompletion'],
                        isParticipating: false));
                    challengeCards.add(SizedBox(height: _height * 0.0125));
                    break;
                  }
                }
              });
            } catch (e) {
              print("here:1212113");
              challengeCards.add(buildChallengeCard(
                  challengeName: doc.id.toString(),
                  imageSource: doc['image'],
                  difficulty: doc['complexity'],
                  goal: doc['goal'],
                  finishDate: upcomingChallengeExpiryDate,
                  points: doc['pointsForCompletion'],
                  isParticipating: false));
              challengeCards.add(SizedBox(height: _height * 0.0125));
            }
          }
        });
      });
      hasWrittenLatestFitnessData = true;
    }

    if (i == 0) {
      return Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: primaryColor,
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  HorizontalCardPager(
                    onPageChanged: (page) {
                      int previousDataPage = currentDataPage;
                      currentDataPage = page <= 0.25
                          ? 0
                          : (page <= 1.25 && page >= 0.75)
                              ? 1
                              : page >= 1.75
                                  ? 2
                                  : currentDataPage;
                      if (previousDataPage != currentDataPage) {
                        print("currentPage: $currentDataPage");
                        setState(() {
                          currentDataPage = currentDataPage;
                        });
                      }
                      // if (page == 0) {
                      //   getYesterdayStep();
                      // }
                    },
                    initialPage: 1,
                    items: [
                      IconTitleCardItem(
                        text: "Heart",
                        iconData: Icon(LineIcons.heartbeat).icon,
                      ),
                      IconTitleCardItem(
                        text: "Steps",
                        iconData: Icon(LineIcons.shoePrints).icon,
                      ),
                      IconTitleCardItem(
                        text: "Calories",
                        iconData: Icon(LineIcons.fire).icon,
                      )
                    ],
                  ),
                  buildFitDataPage()
                ],
              ),
            ),
          ));
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
                    child: Text("This Week's Challenges",
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
                SizedBox(height: _height * 0.0125),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Expires: ",
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontFamily: 'Nunito',
                            fontWeight: FontWeight.w700)),
                    SlideCountdownClock(
                      duration: time,
                      slideDirection: SlideDirection.Up,
                      separator: ":",
                      textStyle: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontFamily: 'Nunito',
                          fontWeight: FontWeight.w700),
                      shouldShowDays: true,
                    ),
                  ],
                ),
                SizedBox(height: _height * 0.0125),
                Column(
                  children: challengeCards,
                )
              ],
            ),
          ),
        ),
      );
    }
  }

  Widget buildChallengeCard(
      {String challengeName,
      String imageSource,
      String difficulty,
      String goal,
      DateTime finishDate,
      int points,
      bool isParticipating}) {
    GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();
    return FlipCard(
      key: cardKey,
      back: Container(
        child: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          color: secondaryColor,
          shadowColor: Colors.black54,
          child: Container(
              width: _width * 0.9,
              child: Padding(
                padding: EdgeInsets.all(15),
                child: Column(
                  children: [
                    Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: secondaryColor,
                        ),
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.only(
                            left: 15, right: 15, top: 7.5, bottom: 7.5),
                        child: Padding(
                          padding: EdgeInsets.all(5),
                          child: Row(
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    Align(
                                      child: AutoSizeText(
                                        "User",
                                        maxLines: 1,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'Nunito',
                                            fontSize: 100),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 25),
                                child: Align(
                                  child: AutoSizeText(
                                    "1115",
                                    maxLines: 1,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Nunito',
                                        fontSize: 100,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )),
                    Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: secondaryColor,
                        ),
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.only(
                            left: 15, right: 15, top: 7.5, bottom: 7.5),
                        child: Padding(
                          padding: EdgeInsets.all(5),
                          child: Row(
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    Align(
                                      child: AutoSizeText(
                                        "User",
                                        maxLines: 1,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'Nunito',
                                            fontSize: 100),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 25),
                                child: Align(
                                  child: AutoSizeText(
                                    "1114",
                                    maxLines: 1,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Nunito',
                                        fontSize: 100,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )),
                    Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: secondaryColor,
                        ),
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.only(
                            left: 15, right: 15, top: 7.5, bottom: 7.5),
                        child: Padding(
                          padding: EdgeInsets.all(5),
                          child: Row(
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    Align(
                                      child: AutoSizeText(
                                        "User",
                                        maxLines: 1,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'Nunito',
                                            fontSize: 100),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 25),
                                child: Align(
                                  child: AutoSizeText(
                                    "1113",
                                    maxLines: 1,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Nunito',
                                        fontSize: 100,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )),
                    Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: secondaryColor,
                        ),
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.only(
                            left: 15, right: 15, top: 7.5, bottom: 7.5),
                        child: Padding(
                          padding: EdgeInsets.all(5),
                          child: Row(
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    Align(
                                      child: AutoSizeText(
                                        "User",
                                        maxLines: 1,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'Nunito',
                                            fontSize: 100),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 25),
                                child: Align(
                                  child: AutoSizeText(
                                    "1112",
                                    maxLines: 1,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Nunito',
                                        fontSize: 100,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )),
                    Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: secondaryColor,
                        ),
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.only(
                            left: 15, right: 15, top: 7.5, bottom: 7.5),
                        child: Padding(
                          padding: EdgeInsets.all(5),
                          child: Row(
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    Align(
                                      child: AutoSizeText(
                                        "You",
                                        maxLines: 1,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'Nunito',
                                            fontSize: 100),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 25),
                                child: Align(
                                  child: AutoSizeText(
                                    "1111",
                                    maxLines: 1,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Nunito',
                                        fontSize: 100,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ))
                  ],
                ),
              )),
        ),
      ),
      front: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        color: secondaryColor,
        shadowColor: Colors.black54,
        child: Container(
            width: _width * 0.9,
            child: Padding(
              padding: EdgeInsets.all(15),
              child: Column(
                children: [
                  Image.network(imageSource),
                  SizedBox(height: _height * 0.0125),
                  Padding(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      child: AutoSizeText(challengeName,
                          maxLines: 1,
                          maxFontSize: 30,
                          style: TextStyle(
                              fontSize: 30,
                              color: Colors.white,
                              fontFamily: 'Nunito',
                              fontWeight: FontWeight.w200))),
                  SizedBox(height: _height * 0.0125),
                  Padding(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child: AutoSizeText(goal,
                          maxLines: 2,
                          maxFontSize: 22,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 22,
                              color: Colors.white,
                              fontFamily: 'Nunito',
                              fontWeight: FontWeight.w200))),
                  SizedBox(height: _height * 0.0125),
                  Text("Complexity: $difficulty",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 22,
                          color: Colors.white,
                          fontFamily: 'Nunito',
                          fontWeight: FontWeight.w200)),
                  Text("Points: $points",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 22,
                          color: Colors.white,
                          fontFamily: 'Nunito',
                          fontWeight: FontWeight.w200)),
                  SizedBox(height: _height * 0.0125),
                  CupertinoButton(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    child: Text(
                        !isParticipating ? "Participate" : "View Competitors",
                        style: TextStyle(
                            fontSize: 20,
                            color: primaryColor,
                            fontFamily: 'Nunito',
                            fontWeight: FontWeight.w200)),
                    onPressed: () async {
                      if (!isParticipating) {
                        final User user =
                            Provider.of(context).auth.firebaseAuth.currentUser;
                        FirebaseFirestore.instance
                            .collection('DigiFit Challenges')
                            .doc(challengeName)
                            .collection('Participants')
                            .doc(user.email)
                            .set({"value": 0}, SetOptions(merge: true));
                        setState(() {
                          isParticipating = true;
                        });
                      } else {
                        cardKey.currentState.toggleCard();
                      }
                    },
                  )
                ],
              ),
            )),
      ),
    );
  }

  Widget buildFitDataPage() {
    if (currentDataPage == 0) {
      return Column(
        children: [
          SizedBox(height: _height * 0.05),
          AspectRatio(
            aspectRatio: 1.5,
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18)),
              color: const Color(0xff81e5cd),
              child: Stack(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Text(
                          'Weekly Heart Data',
                          style: TextStyle(
                              color: const Color(0xff0f4a3c),
                              fontSize: 24,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Expanded(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: BarChart(
                              mainBarData(),
                              swapAnimationDuration:
                                  Duration(milliseconds: 250),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          SizedBox(height: _height * 0.01),
        ],
      );
    } else if (currentDataPage == 1) {
      return new Column(
        children: [
          SizedBox(height: _height * 0.05),
          Padding(
            padding: EdgeInsets.all(8),
            child: Text(
              "Today's Step Goal: $todaySteps of $stepGoal",
              style: TextStyle(
                  color: Colors.white, fontFamily: 'Nunito', fontSize: 20),
            ),
          ),
          new LinearPercentIndicator(
            // radius: 120.0,
            lineHeight: 25.0,
            animation: true,
            percent:
                (todaySteps / stepGoal) > 1.0 ? 1 : (todaySteps / stepGoal),
            progressColor: goodColor,
            backgroundColor: tertiaryColor,
          ),
          SizedBox(height: _height * 0.05),
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
                      stepMonthData(stepMonth),
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
                      showMonthlyData = !showMonthlyData;
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
        ],
      );
    } else {
      return new Column(
        children: [
          SizedBox(height: _height * 0.05),
          Padding(
            padding: EdgeInsets.all(8),
            child: Text(
              "Today's Calorie Goal: $todayCalories of $calorieGoal",
              style: TextStyle(
                  color: Colors.white, fontFamily: 'Nunito', fontSize: 20),
            ),
          ),
          new LinearPercentIndicator(
            // radius: 120.0,
            lineHeight: 25.0,
            animation: true,
            percent: (todayCalories / calorieGoal) > 1.0
                ? 1
                : (todayCalories / calorieGoal),
            progressColor: goodColor,
            backgroundColor: tertiaryColor,
          ),
          SizedBox(height: _height * 0.05),
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
                      // showMonthlyData
                      //     ? calorieMonthData(calorieMonth)
                      //     : calorieYearData(calorieYear),
                      calorieMonthData(calorieMonth),
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
                      showMonthlyData = !showMonthlyData;
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
        ],
      );
    }
  }

  int touchedIndex = -1;

  List<BarChartGroupData> showingGroups() => List.generate(7, (i) {
        switch (i) {
          case 0:
            return makeGroupData(0, 150, isTouched: i == touchedIndex);
          case 1:
            return makeGroupData(1, 165, isTouched: i == touchedIndex);
          case 2:
            return makeGroupData(2, 105, isTouched: i == touchedIndex);
          case 3:
            return makeGroupData(3, 175, isTouched: i == touchedIndex);
          case 4:
            return makeGroupData(4, 109, isTouched: i == touchedIndex);
          case 5:
            return makeGroupData(5, 115, isTouched: i == touchedIndex);
          case 6:
            return makeGroupData(6, 165, isTouched: i == touchedIndex);
          default:
            return makeGroupData(0, 110, isTouched: i == touchedIndex);
        }
      });

  BarChartGroupData makeGroupData(
    int x,
    double y, {
    bool isTouched = false,
    Color barColor = Colors.white,
    double width = 30,
    List<int> showTooltips = const [],
  }) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          y: isTouched ? y + 1 : y,
          colors: isTouched ? [Colors.yellow] : [barColor],
          width: width,
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            y: 200,
            colors: [Color(0xff72d8bf)],
          ),
        ),
      ],
      showingTooltipIndicators: showTooltips,
    );
  }

  BarChartData mainBarData() {
    return BarChartData(
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: Colors.blueGrey,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              String weekDay;
              switch (group.x.toInt()) {
                case 0:
                  weekDay = 'Monday';
                  break;
                case 1:
                  weekDay = 'Tuesday';
                  break;
                case 2:
                  weekDay = 'Wednesday';
                  break;
                case 3:
                  weekDay = 'Thursday';
                  break;
                case 4:
                  weekDay = 'Friday';
                  break;
                case 5:
                  weekDay = 'Saturday';
                  break;
                case 6:
                  weekDay = 'Sunday';
                  break;
                default:
                  throw Error();
              }
              return BarTooltipItem(
                weekDay + '\n',
                TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: (rod.y - 1).toString(),
                    style: TextStyle(
                      color: Colors.yellow,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              );
            }),
        touchCallback: (barTouchResponse) {
          setState(() {
            if (barTouchResponse.spot != null &&
                barTouchResponse.touchInput is PointerUpEvent &&
                barTouchResponse.touchInput is PointerExitEvent) {
              touchedIndex = barTouchResponse.spot.touchedBarGroupIndex;
            } else {
              touchedIndex = -1;
            }
          });
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          getTextStyles: (value) => const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
          margin: 16,
          getTitles: (double value) {
            switch (value.toInt()) {
              case 0:
                return 'M';
              case 1:
                return 'T';
              case 2:
                return 'W';
              case 3:
                return 'T';
              case 4:
                return 'F';
              case 5:
                return 'S';
              case 6:
                return 'S';
              default:
                return '';
            }
          },
        ),
        leftTitles: SideTitles(
          showTitles: false,
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: showingGroups(),
    );
  }

  LineChartData stepYearData(List<FlSpot> spots) {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
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
              fontSize: 16,
              fontFamily: "Nunito"),
          getTitles: (value) {
            switch (value.toInt()) {
              case 0:
                return 'JAN';
              case 6:
                return 'JUL';
              case 11:
                return 'DEC';
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
              fontFamily: "Nunito"),
          getTitles: (value) {
            switch (value.toInt()) {
              case 1:
                return '2k';
              case 3:
                return '6k';
              case 5:
                return '10k';
              case 7:
                return '14k';
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
      maxX: 12,
      minY: 0,
      maxY: 8,
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: false,
          colors: gradientColors,
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            colors:
                gradientColors.map((color) => color.withOpacity(0.3)).toList(),
          ),
        ),
      ],
    );
  }

  LineChartData stepMonthData(List<FlSpot> spots) {
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
                return '2k';
              case 3:
                return '6k';
              case 5:
                return '10k';
              case 7:
                return '14k';
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

  LineChartData calorieYearData(List<FlSpot> spots) {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
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
              fontSize: 16,
              fontFamily: "Nunito"),
          getTitles: (value) {
            switch (value.toInt()) {
              case 0:
                return 'JAN';
              case 6:
                return 'JUL';
              case 11:
                return 'DEC';
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
              fontFamily: "Nunito"),
          getTitles: (value) {
            switch (value.toInt()) {
              case 1:
                return '2k';
              case 3:
                return '6k';
              case 5:
                return '10k';
              case 7:
                return '14k';
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
      maxX: 12,
      minY: 0,
      maxY: 8,
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: false,
          colors: gradientColors,
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            colors:
                gradientColors.map((color) => color.withOpacity(0.3)).toList(),
          ),
        ),
      ],
    );
  }

  LineChartData calorieMonthData(List<FlSpot> spots) {
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
                return '750';
              case 3:
                return '1.5k';
              case 5:
                return '2.25k';
              case 7:
                return '3k';
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
