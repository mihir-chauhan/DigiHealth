import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:DigiHealth/appPrefs.dart';
import 'package:ko_swipe_card/ko_swipe_card.dart';
import 'package:category_picker/category_picker.dart';
import 'package:category_picker/category_picker_item.dart';

class DigiFitPage extends StatefulWidget {
  DigiFitPage();

  @override
  _DigiFitPageState createState() => _DigiFitPageState();
}

class _DigiFitPageState extends State<DigiFitPage> {
  String title;
  CategoryPickerItem settingCategories(String value) {
    return CategoryPickerItem(value: value);
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: secondaryColor,
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
              settingCategories('Indoor'),
              settingCategories('Outdoor'),
              settingCategories('High-Impact'),
              settingCategories('Low-Impact'),
            ],
            onValueChanged: (value) {
              setState(() {});
            },
            backgroundColor: primaryColor,
            selectedItemColor: tertiaryColor,
            unselectedItemBorderColor: Colors.black,
            selectedItemTextDarkThemeColor: Colors.white,
            selectedItemTextLightThemeColor: Colors.white,
            unselectedItemTextDarkThemeColor: Colors.black,
            unselectedItemTextLightThemeColor: Colors.black,
          ),
          CupertinoButton(
            child: Container(
              width: 300.0,
              height: 300.0,
              decoration: new BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.play_arrow,
                color: Colors.green,
                size: 300.0,
              ),
            ),
          )
        ],
      ),
    );
  }

  // List<String> activityList = [
  //   "Outdoor Run",
  //   "Indoor Jog",
  //   "Cycling",
  //   "Treadmill",
  // ];

  List<Color> activityColor = [
    //outdoor is orange, indoor is blue
    outdoorExerciseColor,
    tertiaryColor,
    outdoorExerciseColor,
    tertiaryColor
  ];

  // Widget _buildCard(BuildContext context, int index, double rotateFraction) {
  //   return GestureDetector(
  //     child: Container(
  //       color: activityColor[index],
  //       child: Column(
  //         children: [
  //           Align(
  //             alignment: Alignment.topCenter,
  //             child: Image.asset(
  //               (activityList[index] == "Outdoor Run"
  //                   ? "outdoorrun.gif"
  //                   : activityList[index] == "Indoor Jog"
  //                       ? "indoorjog.gif"
  //                       : activityList[index] == "Cycling"
  //                           ? "cycling.gif"
  //                           : "treadmill.gif"),
  //               height: MediaQuery.of(context).size.width * 0.25,
  //             ),
  //           ),
  //           Padding(
  //             padding:
  //                 EdgeInsets.all(MediaQuery.of(context).size.height * 0.05),
  //             child: AutoSizeText(activityList[index],
  //                 maxLines: 2,
  //                 textAlign: TextAlign.center,
  //                 style: TextStyle(
  //                     fontSize: 35,
  //                     color: Colors.white,
  //                     fontFamily: 'Nunito',
  //                     fontWeight: FontWeight.w500)),
  //           )
  //         ],
  //       ),
  //     ),
  //     onTap: () {
  //       //index always 0 because it is top of deck
  //     },
  //   );
  // }
}
// KoSwipeCard(
// cardWidth: MediaQuery.of(context).size.width * 0.75,
// cardHeight: MediaQuery.of(context).size.height * 0.5,
// cardDeltaHeight: 10,
// itemCount: activityList.length,
// indexedCardBuilder: (ctx, index, rotateFraction, translateFraction) =>
// _buildCard(ctx, index, translateFraction),
// topCardDismissListener: () {
// setState(() {
// String activityBeingSwipedOut = activityList.elementAt(0);
// activityList.removeAt(0);
// activityList.add(activityBeingSwipedOut);
//
// Color colorBeingSwipedOut = activityColor.elementAt(0);
// activityColor.removeAt(0);
// activityColor.add(colorBeingSwipedOut);
// });
// },
// ),
