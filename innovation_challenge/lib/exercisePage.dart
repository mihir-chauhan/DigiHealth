import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class ExercisePage extends StatelessWidget {
  final String exerciseType;
  ExercisePage({Key key, @required this.exerciseType}) : super(key: key);

  final primaryColor = const Color(0xFF75A2EA);
  final tertiaryColor = const Color(0xFFFFFFFF);
  final hintColor = const Color(0xFF808080);
  final secondaryColor = const Color(0xFF5c7fb8);
  final quaternaryColor = const Color(0xFF395075);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: secondaryColor,
      navigationBar: CupertinoNavigationBar(
        middle: Text(exerciseType,
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
      child: Text("Hi"),
    );
  }
}
