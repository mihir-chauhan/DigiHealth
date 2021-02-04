import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final primaryColor = const Color(0xFF75A2EA);

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;

    return CupertinoPageScaffold(
      child: Container(
        width: _width,
        height: _height,
        color: primaryColor,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                SizedBox(
                  height: _height * 0.1,
                ),
                Text("You are Signed In",
                    style: TextStyle(fontSize: 48, color: Colors.white)),
                SizedBox(
                  height: _height * 0.1,
                ),
                AutoSizeText("Your first step to a healthier life",
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 40, color: Colors.white))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
