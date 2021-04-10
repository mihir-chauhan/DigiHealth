import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:DigiHealth/appPrefs.dart';

class DynamicAIPage extends StatelessWidget {
  final String viewTitleText;
  DynamicAIPage(this.viewTitleText);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: secondaryColor,
      navigationBar: CupertinoNavigationBar(
        transitionBetweenRoutes: false,
        heroTag: "DynamicAIPage",
        middle: Text(viewTitleText,
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
      child: Container(

        child: Text("Hi"),
      ),
    );
  }
}
