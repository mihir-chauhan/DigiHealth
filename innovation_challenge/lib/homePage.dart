import 'package:DigiHealth/provider_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:vertical_card_pager/vertical_card_pager.dart';
import 'package:DigiHealth/appPrefs.dart';

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

  @override
  Widget build(BuildContext context) {
    if (Provider.of(context).auth.madeNewAccount) {
        popupInSeconds(1000);
    }
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
          ),),
        child: Scaffold(
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
                          color: Colors.white, fontWeight: FontWeight.w400, fontFamily: 'Nunito'),
                      // optional
                      onPageChanged: (page) {
                        // optional
                      },
                      onSelectedItem: (index) {
                        if(index == 0) {
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
        ));
  }

  bool hasShownDialog = false;
  void popupInSeconds(int time) async {
    await Future.delayed(Duration(milliseconds: time), () {
      if (!hasShownDialog) {
        showCupertinoDialog(
            context: context,
            builder: (_) => Container(
                child: NetworkGiffyDialog(
                  image: Image.asset("welcome.gif"),
                  title: Text("Welcome to DigiHealth!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                          fontFamily: 'Nunito',
                          fontWeight: FontWeight.w600)),
                  description: Text(
                    "Choose a workout or get diet suggestions from intelligent AI, encourage others with the chat, and view your all-time stats!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.w400),
                  ),
                  entryAnimation: EntryAnimation.DEFAULT,
                  onOkButtonPressed: () {},
                  buttonCancelText: Text(
                    "I'm Ready!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.w300),
                  ),
                  buttonCancelColor: primaryColor,
                  onlyCancelButton: true,
                ),
              )

            );
        hasShownDialog = true;
        Provider.of(context).auth.madeNewAccount = false;
      }
    });
  }
}

