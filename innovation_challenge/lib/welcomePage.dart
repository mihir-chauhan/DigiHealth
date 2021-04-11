import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WelcomePage extends StatelessWidget {
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
                  height: _height * 0.05,
                ),
                Text("Welcome to",
                    style: TextStyle(fontSize: 48, color: Colors.white, fontFamily: 'Nunito', fontWeight: FontWeight.w200)),
                SizedBox(height: _height * 0.05),
                Image.asset(
                  'assets/DigiHealthBanner.png',
                ),
                SizedBox(height: _height * 0.05),
                TypewriterAnimatedTextKit(
                  text: [
                    "Health like never before",
                  ],
                  textStyle: TextStyle(
                      fontSize: 30.0,
                      fontFamily: "Barlow"
                  ),
                  textAlign: TextAlign.start,
                  speed: Duration(milliseconds: 100),
                  pause: Duration(milliseconds: 1000),
                ),
                SizedBox(height: _height * 0.1),
                CupertinoButton(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                  child: Text(
                    "Get Started",
                    style: TextStyle(fontSize: 28, color: primaryColor, fontFamily: 'Nunito', fontWeight: FontWeight.w200)
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/signUp');
                  },
                ),
                SizedBox(height: _height * 0.01),
                CupertinoButton(
                  child: Text(
                    "Sign In",
                    style: TextStyle(fontSize: 25, color: Colors.white, fontFamily: 'Nunito', fontWeight: FontWeight.w200),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/signIn');
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
