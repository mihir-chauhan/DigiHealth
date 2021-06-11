import 'package:DigiHealth/provider_widget.dart';
import 'package:DigiHealth/questionnairePage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropdown_alert/alert_controller.dart';
import 'package:flutter_dropdown_alert/dropdown_alert.dart';
import 'package:flutter_dropdown_alert/model/data_alert.dart';
import 'package:vertical_card_pager/vertical_card_pager.dart';
import 'package:DigiHealth/appPrefs.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<String> titles = [
    "DigiFit",
    "DigiDiet",
  ];

  final List<Widget> images = [
    ClipRRect(
      borderRadius: BorderRadius.circular(20.0),
      child: Image.asset(
        "images/digifit.jpg",
        fit: BoxFit.cover,
      ),
    ),
    ClipRRect(
      borderRadius: BorderRadius.circular(20.0),
      child: Image.asset(
        "images/dietplanner2.png",
        fit: BoxFit.cover,
      ),
    ),
  ];

  bool openedQuestionnaire = false;

  @override
  Widget build(BuildContext context) {
    if (!openedQuestionnaire) {
      openQuestionnaire();
      openedQuestionnaire = true;
    }

    FirebaseFirestore.instance
        .collection('DigiFit Challenges')
        .orderBy("endDate", descending: false)
        .get()
        .then((QuerySnapshot snapshot) {
      if (snapshot.docs.length > 0) {
        DateTime startDate = snapshot.docs.elementAt(0)['startDate'].toDate();
        final User user = Provider.of(context).auth.firebaseAuth.currentUser;
        DateTime lastOpenedDate;
        FirebaseFirestore.instance
            .collection('User Data')
            .doc(user.email)
            .get()
            .then((DocumentSnapshot snapshot) {
          lastOpenedDate = snapshot["Previous Use Date"].toDate();
          if (lastOpenedDate.isBefore(startDate) &&
              DateTime.now().isAfter(startDate)) {
            AlertController.show("New Challenges Await!",
                "Check out new challenges under DigiFit!", TypeAlert.warning);
          }
        });
      }
    });

    WidgetsFlutterBinding.ensureInitialized();
    return CupertinoPageScaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: secondaryColor,
        navigationBar: CupertinoNavigationBar(
          transitionBetweenRoutes: false,
          heroTag: "homePage",
          middle: Text("Home",
              style: TextStyle(color: Colors.white, fontFamily: 'Nunito')),
          backgroundColor: secondaryColor,
          leading: GestureDetector(
            child: Icon(
              Icons.circle,
              color: secondaryColor,
            ),
          ),
        ),
        child: Stack(
          children: [
            Scaffold(
              backgroundColor: primaryColor,
              body: SafeArea(
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        child: VerticalCardPager(
                          titles: titles,
                          // required
                          images: images,
                          // required
                          textStyle: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'Nunito'),
                          // optional
                          onPageChanged: (page) {
                            // optional
                          },
                          onSelectedItem: (index) {
                            if (index == 0) {
                              Navigator.pushNamed(context, '/digifit');
                            } else {
                              Navigator.pushNamed(context, '/digidiet');
                            }
                          },
                          initialPage: 0,
                          // optional
                          align: ALIGN.CENTER, // optional
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            DropdownAlert(
              warningBackground: tertiaryColor,
              errorBackground: badColor,
              warningImage: "images/challenge.png",
              duration: 300,
              delayDismiss: 0,
              titleStyle: TextStyle(color: Colors.white, fontFamily: 'Nunito'),
              contentStyle:
                  TextStyle(color: Colors.white, fontFamily: 'Nunito'),
            )
          ],
        ));
  }

  bool alreadyCalledOpenQuestionnaire = false;
  void openQuestionnaire() {
    if (!alreadyCalledOpenQuestionnaire) {
      final User user = Provider.of(context).auth.firebaseAuth.currentUser;
      FirebaseFirestore.instance
          .collection('User Data')
          .doc(user.email)
          .get()
          .then((DocumentSnapshot snapshot) {
        print(snapshot["Questionnaire"].toString());
        if (snapshot["Questionnaire"] == false) {
          launchQuestionnaire();
        }
      });
      alreadyCalledOpenQuestionnaire = true;
    }
  }

  void launchQuestionnaire() async {
    print("opening questionnaire");
    await Future.delayed(Duration(milliseconds: 1000), () {
      Navigator.push(context,
          CupertinoPageRoute(builder: (context) => QuestionnairePage()));
    });
  }
}
